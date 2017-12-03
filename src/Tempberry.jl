module Tempberry

using
  HttpServer,
  DataStructures

export
  lstherm,
  readtherm,
  hosttempberrylive,
  hosttestpage


## Temperatures page ===========================================================

include("RaspPiThermDS18B20.jl")
include("MakeHtml.jl")
include("TempberryLivePage.jl")

## Testing page ================================================================

include("TestPageFunctions.jl")



end
