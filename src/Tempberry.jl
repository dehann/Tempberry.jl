module Tempberry

using
  HttpServer,
  SMTPClient

export
  lstherm,
  readtherm,
  hosttempberrylive,
  hosttestpage,
  loop!,
  maketemptable,
  sendTempberryReportingEmails

## Send Emails =================================================================

include("EmailFunctions.jl")

## Temperatures page ===========================================================

include("RaspPiThermDS18B20.jl")
include("MakeHtml.jl")
include("Logging.jl")
include("TempberryLivePage.jl")

## Testing page ================================================================

include("TestPageFunctions.jl")



end
