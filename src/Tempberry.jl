module Tempberry

using
  HttpServer

export
  lstherm,
  readtherm,
  hosttempberrylive,
  hosttestpage,
  loop!,
  maketemptable


## Temperatures page ===========================================================

include("RaspPiThermDS18B20.jl")
include("MakeHtml.jl")
include("TempberryLivePage.jl")

## Testing page ================================================================

include("TestPageFunctions.jl")



end
