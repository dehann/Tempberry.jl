module Tempberry

using
  Genie, Genie.Router, Genie.Renderer,
  Dates

export
  lstherm,
  readtherm,
  hosttempberrylive,
  hosttestpage,
  loop!,
  maketemptable,
  prepareSendEmail


## Temperatures page ===========================================================

include("RaspPiThermDS18B20.jl")
include("PrepareEmail.jl")
include("MakeHtml.jl")
include("Logging.jl")
include("TempberryLivePage.jl")

## Testing page ================================================================

include("TestPageFunctions.jl")



end
