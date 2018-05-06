

function devloop!(stl::Dict{Symbol, Any})
  stl[:timestamp] = now()
  for i in 1:stl[:numtherms]
    stl[Symbol("temp$(i)")] = round(20+randn(),3)
  end
  logging(stl)
  nothing
end

function hosttestpage(;port=8000,delay=5)
  @show sharedtemps = Dict{Symbol, Any}()
  @show sharedtemps[:numtherms] = 2
  sharedtemps[:logdir]="$(ENV["HOME"])/temperaturelogs/test/"
  sharedtemps[:logfiles] = Vector{String}()
  emailwarningsettings!(sharedtemps)
  @async begin
    tic()
    while true
      devloop!(sharedtemps)
      sleep(delay-toq()) # correct for computation delay
      tic()
    end
  end
  @show "setting up handler"
  http = HttpHandler() do req::Request, res::Response
    if ismatch(r"^/dashboard",req.resource)
      # Response(  defaultpage(req, res, sharedtemps)  )
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
  @show "going to run handler"
  run(server, port=port)
  nothing
end
