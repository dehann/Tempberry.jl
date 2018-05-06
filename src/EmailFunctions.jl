# this file contains all functions related to Tempberry email management

function getTempberryEmailAddr()
  try
    return ENV["TEMPBERRY_EMAIL_ADDRESS"]
  catch e
    warn("Cannot find bash environment variable: TEMPBERRY_EMAIL_ADDRESS")
  end
end

function getTempberryEmailPswd()
  try
    return ENV["TEMPBERRY_EMAIL_PASSWORD"]
  catch e
    warn("Cannot find bash environment variable: TEMPBERRY_EMAIL_PASSWORD")
  end
end

function getTempberryReportingAddrs()
  try
    return strip.(split(ENV["TEMPBERRY_REPORTING_ADDRESS"], ';'))
  catch e
    warn("Cannot find bash environment variable: TEMPBERRY_REPORTING_ADDRESS")
  end
end

function getGmailSMTPClientUrl()
  return "smtp://smtp.gmail.com:587"
end

function generateEmailMsg(addr, message)
  datetimestr = "Date: Fri, 18 Oct 2013 21:44:29 +0100"
  msg = """
  $(datetimestr)
  From: Temberry  <$(getTempberryEmailAddr())>
  To: $(addr)
  Subject: Julia Test\n
  $(message)"""
  body=IOBuffer(msg)

  return body
end

"""
    sendTempberryReportingEmails(;message=)

Function to send a test email to all email addresses listed in the environment variable.
"""
function sendTempberryReportingEmails(;message="This is a test from Tempberry.")
  #
  # SMTPClient.init()
  try
    opts=SendOptions(blocking=true, isSSL=true, username=getTempberryEmailAddr(),    passwd=getTempberryEmailPswd() )

    # loop over all reporting emails
    for addr in getTempberryReportingAddrs()
    body = generateEmailMsg(addr, message)
    #Provide the message body as RFC5322 within an IO
    resp=send(getGmailSMTPClientUrl(), ["<$(getTempberryEmailAddr())>"], "<$(addr)>",  body, opts)
    end

    # SMTPClient.cleanup()
  catch e
    warn("Failed sending email: $message")
    @show e
    @show stacktrace()
  end

  nothing
end



function checkhours(stl::Dict{Symbol, Any}, testhour::Int)
  abs(testhour - stl[:hourssinceemails]) > stl[:emaildelayhours]
end

"""
Check if temperatures are within the minimum and maximum prescribed values, and send emails if not.
"""
function checkrangesandemail(stl::Dict{Symbol,Any})

  currhours = Dates.hour(now())
  outofrange = checktemperatureranges(stl)
  outofhours = checkhours(stl, currhours)

  if outofrange && outofhours
    message = "[$(now())] Tempberry, out of range, temps at: "
    for i in 1:stl[:numtherms]
      val = round(stl[Symbol("temp$(i)")],1)
      message *= "$(val) C, "
    end
    sendTempberryReportingEmails(message=message)
    stl[:hourssinceemails] = currhours
  end
  nothing
end

function emailwarningsettings!(sharedtempsl::Dict{Symbol, Any})
  sharedtempsl[:hourssinceemails] = 999999
  sharedtempsl[:minimumwarning] = 10
  sharedtempsl[:maximumwarning] = 23
  sharedtempsl[:emaildelayhours] = 6
  nothing
end


function checktemperatureranges(stl::Dict{Symbol,Any})
  minval = stl[:minimumwarning]
  maxval = stl[:maximumwarning]
  for i in 1:stl[:numtherms]
    val = stl[Symbol("temp$(i)")]
    if minval < val < maxval
      return true
    end
  end
  return false
end

# random testing
# sendTempberryReportingEmails()
