# test email functionality

using SMTPClient
SMTPClient.init()
o=SendOptions(blocking=true, isSSL=true, username="you@gmail.com", passwd="yourgmailpassword")
#Provide the message body as RFC5322 within an IO
body=IOBuffer("Date: Fri, 18 Oct 2013 21:44:29 +0100\nFrom: You <you@gmail.com>\nTo: me@test.com\nSubject: Julia Test\n\nTest Message")
resp=send("smtp://smtp.gmail.com:587", ["<me@test.com>"], "<you@gmail.com>", body, o)
SMTPClient.cleanup()
