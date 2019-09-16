module Tempberry

using
  Genie

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
include("Logging.jl")
include("TempberryLivePage.jl")

## Testing page ================================================================

include("TestPageFunctions.jl")



end
