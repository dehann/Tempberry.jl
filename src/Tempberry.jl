module Tempberry

using HttpServer

export
  lstherm


"""
    lstherm()

List thermometers currently connected and discoverable through `/sys/bus/w1/devices/28-*`
"""
function lstherm()
  here=pwd()
  path = "/sys/bus/w1/devices/"
  cd(path)
  println("Reading $(path) for 28-* therm devices")
  dirfiles = readdir()
  keeplist = String[]
  for fin in dirfiles
    if fin[1:3] == "28-"
      push!(keeplist, fin)
    end
  end
  cd(here)
  keeplist
end


function hostwebpage(;port=8000)
  g = (req, res) -> begin
    if ismatch(r"^/hello/",req.resource)
        string("Hello ", split(req.resource,'/')[3], "!")
    else
        404
    end
  end
  http = HttpHandler() do req::Request, res::Response

      Response(  g(req, res)  )

  end
  server = Server( http )
  run(server, host=IPv4(127,0,0,1), port=port)
  nothing
end

end
