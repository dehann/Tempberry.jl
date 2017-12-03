
function devloop!(stl::Dict{Symbol, Any})
  stl[:timestamp] = now()
  for i in 1:stl[:numtherms]
    stl[Symbol("temp$(i)")] = round(20+randn(),3)
  end
  nothing
end

function hosttestpage(;port=9000, delay=5)
  sharedtemps = Dict{Symbol, Any}()
  sharedtemps[:numtherms] = 2
  @async begin
    tic()
    while true
      devloop!(sharedtemps)
      sleep(delay-toq()) # correct for computation delay
      tic()
    end
  end
  http = HttpHandler() do req::Request, res::Response
      Response(  defaultpage(req, res, sharedtemps)  )
  end
  server = Server( http )
  run(server, port=port)
  nothing
end
