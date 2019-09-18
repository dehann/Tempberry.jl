

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


function intervalTimer!(stl; interval::Float64=5.0)
  cond = stl[:condition]
  while stl[:doIntervals]
    notify(cond)
    sleep(interval)
  end
end

function checkTempAlarms(sharedtemps::Dict)::Nothing
  # short hand variable
  sinceAlarm = now() - sharedtemps[:timeSinceLastAlarm]
  if sinceAlarm < sharedtemps[:alarmPeriod]
    return nothing
  end
  
  temp1 = sharedtemps[:temp1]
  temp2 = sharedtemps[:temp2]
  mintemp = sharedtemps[:minTempAlarm]
  maxtemp = sharedtemps[:maxTempAlarm]
  # check minimum temp alarm condition
  if temp1 < mintemp || temp2 < mintemp || maxtemp < temp1 || maxtemp < temp2
    prepareSendEmail(temp1, temp2)
    # reset the alarm timer
    sharedtemps[:timeSinceLastAlarm] = now()
  end
  return nothing
end

function updateCycle!(sharedtemps::Dict)
  while sharedtemps[:doIntervals]
    wait(sharedtemps[:condition])
    # update the registers with new temperature data
    loop!(sharedtemps)

    # monitor for (and send) alarms
    checkTempAlarms(sharedtemps)
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
  sharedtemps[:doIntervals] = true
  # alarm parameters
  sharedtemps[:alarmPeriod] = Hour(2)
  sharedtemps[:timeSinceLastAlarm] = now() - sharedtemps[:alarmPeriod]
  sharedtemps[:maxTempAlarm] = 30.0
  sharedtemps[:minTempAlarm] = 10.0
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

function conductor(task::Task, stl::Dict)
  while stl[:doIntervals]
    sleep(10)
    if task.state == :failed
      stl[:doIntervals] = false
      file = open("/tmp/tempberry_stacktrace.txt", "w")
      println(file, task.exception)
      close(file)
      @error task.exception
      error(task.exception)
    end
  end
end

function hosttempberrylive(;port=8000,delay=5)

  sharedtemps = initSharedDict()

  # start the update cycle
  @async intervalTimer!(sharedtemps)
  task = @async updateCycle!(sharedtemps)
  @async conductor(task, sharedtemps)

  # populate the URL routes offered by Tempberry
  defineRoutes!(sharedtemps)

  # start the web server (blocking mode)
  startup(port, async=false)
  
  nothing
end




#
