
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
  @async begin
    tic()
    while true
      devloop!(sharedtemps)
      sleep(delay-toq()) # correct for computation delay
      tic()
    end
  end
  @warn "test handler currently not available"
  # @show "setting up handler"
  # http = HttpHandler() do req::Request, res::Response
  #     Response(  defaultpage(req, res, sharedtemps)  )
  #     #Response(  "This is a test"  )
  # end
  # server = Server( http )
  # @show "going to run handler"
  # run(server, port=port)
  nothing
end
