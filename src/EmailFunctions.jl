# this file contains all functions related to Tempberry email management

function getTempberryEmailAddr()
  return ENV["TEMPBERRY_EMAIL_ADDRESS"]
end

function getTempberryEmailPswd()
  return ENV["TEMPBERRY_EMAIL_PASSWORD"]
end

function getTempberryReportingAddrs()
  return strip.(split(ENV["TEMPBERRY_REPORTING_ADDRESS"], ';'))
end

function getGmailSMTPClientUrl()
  return "smtp://smtp.gmail.com:587"
end

function generateEmailMsg(addr)
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
function sendTempberryReportingEmails(;
              message="This is a test from Tempberry."  )
  #
  # SMTPClient.init()
  opts=SendOptions(blocking=true, isSSL=true, username=getTempberryEmailAddr(),  passwd=getTempberryEmailPswd() )

  # loop over all reporting emails
  for addr in getTempberryReportingAddrs()
    body = generateEmailMsg(addr)
    #Provide the message body as RFC5322 within an IO
    resp=send(getGmailSMTPClientUrl(), ["<$(getTempberryEmailAddr())>"], "<$(addr)>",  body, opts)
  end

  SMTPClient.cleanup()

  nothing
end





# random testing

using SMTPClient

# addr = getTempberryReportingAddrs()[1]
# generateEmailMsg(addr)

sendTempberryReportingEmails()
