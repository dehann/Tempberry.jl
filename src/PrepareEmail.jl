
function prepareSendEmail(temp1::Float64, temp2::Float64)

  # who to send emails to
  addrs = split(ENV["TEMPBERRY_REPORTING_ADDRESS"], ';')

  # compile curl instructions
  for addr in addrs
    nickname = split(addr, '@')[1]
    # prepare the email in a file
    fid = open("/tmp/mail.txt", "w")
    println(fid, "From: \"Tempberry\" <$(ENV["TEMPBERRY_EMAIL_ADDRESS"])>")
    println(fid, "To: \"$(nickname)\" <$(addr)>")
    println(fid, "Subject: temprature out of range alert")
    println(fid, "")
    println(fid, "[$(now())]: Tempberry temperatures are:")
    println(fid, "temp1=$(temp1)")
    println(fid, "temp2=$(temp2)")
    close(fid)
    
    shid = open("/tmp/mail.sh", "w")
    println(shid, "curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from '$(ENV["TEMPBERRY_EMAIL_ADDRESS"])' --mail-rcpt '$(addr)' --upload-file /tmp/mail.txt --user '$(ENV["TEMPBERRY_EMAIL_ADDRESS"]):$(ENV["TEMPBERRY_EMAIL_PASSWORD"])' --insecure")
    close(shid)
    run(`sh /tmp/mail.sh`)
  end

  nothing
end
