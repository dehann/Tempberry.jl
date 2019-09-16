

function builddownloadresponse(stl, file::T) where {T <: AbstractString}
  @warn "download reponse not currently available"
  # fid = open(joinpath(stl[:logdir], file),"r")
  # downloaddata = readstring(fid)
  # close(fid)
  # #downloaddata = "Hey this is my cool string with all the binary data."
  # headers = Dict{AbstractString, AbstractString}(
  #   "Server"            => "Julia/$VERSION",
  #   "Content-Type"      => "application/octet-stream",
  #   "Date"              => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
  # return Response(200, headers, downloaddata)
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


function intervalTimer!(cond::Condition; interval::Float64=5.0)
  while true
    notify(cond)
    sleep(interval)
  end
end

function updateCycle!(sharedtemps::Dict)
  while true
    wait(sharedtemps[:condition])
    loop!(sharedtemps)
  end
end

function initSharedDict()
  @show therms = lstherm()
  sharedtemps = Dict{Symbol, Any}()
  sharedtemps[:timestamp] = now()
  sharedtemps[:therms] = therms
  sharedtemps[:numtherms] = length(therms)
  sharedtemps[:logdir]="$(ENV["HOME"])/temperaturelogs/"
  sharedtemps[:logfiles] = Vector{String}()
  sharedtemps[:condition] = Condition()
  return sharedtemps
end

function defineRoutes!(sharedtemps)
  route("/dashboard") do
    @info "dashboard route"
    html(maketemptable(sharedtemps[:timestamp], sharedtemps[:temp1], sharedtemps[:temp2], files = sharedtemps[:logfiles]))
  end
  route("/index.html") do
    @info "index.html welcome route"
    html("Welcome to Tempberry, see /dashboard for live data")
  end
  route("/download") do
    html("DOWNLOADS NOT AVAILABLE AT THIS TIME")
    @info "download route"
	  #     params = split(split(req.resource,'?')[end], '=')
	  # 	file = params[2]
	  # 	return builddownloadresponse(sharedtemps, file)
  end
  
  nothing
end

function hosttempberrylive(;port=8000,delay=5)

  sharedtemps = initSharedDict()

  # start the update cycle
  @async intervalTimer!(sharedtemps[:condition])
  @async updateCycle!(sharedtemps)  

  # populate the URL routes offered by Tempberry
  defineRoutes!(sharedtemps)

  # start the web server (blocking mode)
  startup(port, async=false)
  
  nothing
end




#
