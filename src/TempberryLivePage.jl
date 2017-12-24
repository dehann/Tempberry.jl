

#function defaultpage(req, res, stl)::Response
#  if ismatch(r"^/",req.resource)
#	Response(  maketemptable(stl[:timestamp], stl[:temp1], stl[:temp2], files = stl[:logfiles]) )
#  else
#	@show "unknown request $(req.resource)"
#	404
#  end
#end

function builddownloadresponse(stl, file::T) where {T <: AbstractString}
  fid = open(joinpath(stl[:logdir], file),"r")
  downloaddata = readstring(fid)
  close(fid)
  #downloaddata = "Hey this is my cool string with all the binary data."
  headers = Dict{AbstractString, AbstractString}(
    "Server"            => "Julia/$VERSION",
    "Content-Type"      => "application/octet-stream",
    "Date"              => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
  return Response(200, headers, downloaddata)
end

function loop!(stl::Dict{Symbol,Any})
  stl[:timestamp] = now()
  i = 0
  for therm in stl[:therms]
    i += 1
    stl[Symbol("temp$(i)")] = readtherm(therm) # TODO -- make this less hacky, drop temp1 & 2 for actual addresses
  end
  # stl[:minmax24]
  logging(stl)
  nothing
end


function hosttempberrylive(;port=8000,delay=5)
  @show therms = lstherm()
  sharedtemps = Dict{Symbol, Any}()
  sharedtemps[:therms] = therms
  sharedtemps[:numtherms] = length(therms)
  sharedtemps[:logdir]="$(ENV["HOME"])/temperaturelogs/"
  sharedtemps[:logfiles] = Vector{String}()
  @async begin
    tic()
    while true
      loop!(sharedtemps)
      sltime = delay-toq()-0.004 # trail and error compensation value for approx 1/5Hz
      sltime > 0 ? sleep(sltime) : nothing # correct for computation delay
      tic()
    end
  end

  http = HttpHandler() do req::Request, res::Response
      #Response(  defaultpage(req, res, sharedtemps)  )
      if ismatch(r"^/dashboard",req.resource)
		Response(  maketemptable(sharedtemps[:timestamp], sharedtemps[:temp1], sharedtemps[:temp2], files = sharedtemps[:logfiles]) )
	  elseif ismatch(r"^/download", req.resource)
	    params = split(split(req.resource,'?')[end], '=')
		file = params[2]
		return builddownloadresponse(sharedtemps, file)
	  else
		@show "unknown request $(req.resource)"
		404
	  end
  end
  server = Server( http )
  run(server, port=port)
  nothing
end




#
