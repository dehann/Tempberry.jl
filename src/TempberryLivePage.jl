

function defaultpage(req, res, stl)::Response
  if ismatch(r"^/",req.resource)
    # string("Hello ", split(req.resource,'/')[3], "!")
    maketemptable(stl[:timestamp], stl[:temp1], stl[:temp2], files = stl[:logfiles])
  elseif ismatch(r"^/download?file=*", req.resource)
    file = req.resource #strip this to just the file.
    return buildDownloadResponse(file)
  else
    @show "unknown request $(req.resource)"
    404
  end
end

function buildDownloadResponse(file::String)
  exampleDownload = "Hey this is my cool string with all the binary data."
  headers = Headers(
    "Server"            => "Julia/$VERSION",
    "Content-Type"      => "application/octet-stream",
    "Date"              => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
  return Response(200, headers, exampleDownload)
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
      buildDownloadResponse("testFile")
      #Response(  defaultpage(req, res, sharedtemps)  )
  end
  server = Server( http )
  run(server, port=port)
  nothing
end




#
