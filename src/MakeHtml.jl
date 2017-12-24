function maketemptable(timestamp, temp1, temp2; files=String["";])
  
  minmaxs=zeros(0,2)
  
  textblock = """
  <html>
  <head>
  <title>Tempberry Live</title>
  </head>
  <body>
  <h1>Welcome to Tempberry Live</h1>
  <h3>Current status, as of $(timestamp)</h3>
  <table style=\"width:30%\" border=\"1\">
   <tr>
     <th> </th>
     <th>Temp1</th>
     <th>Temp2</th>
   </tr>
   <tr>
     <td>current</td>
     <td>$(temp1)</td>
     <td>$(temp2)</td>
   </tr>
   <tr>
     <td>6h Min/Max</td>
     <td> n/a / N/A </td>
     <td> n/a / N/A </td>
   </tr>
   <tr>
     <td>12h Min/Max</td>
     <td> n/a / N/A </td>
     <td> n/a / N/A </td>
   </tr>
   <tr>
     <td>24h Min/Max</td>
     <td> n/a / N/A </td>
     <td> n/a / N/A </td>
   </tr>
  </table>
  <h3>Historic data for download</h3>
  <table style=\"width:30%\" border=\"1\">
  <tr>
    <th>Downloads</th>
    <th>Min/Max</th>
  </tr>
  """
  i = 0
  for fl in files
      i += 1
      if fl != ""
          lenmm = size(minmaxs,1) >= i
	      flss = split(fl, '/')
		  newline = """
		  <tr>
			<td><a href=\"/download?file=$(flss[end])">$(flss[end])</a></td>
			<td>$(lenmm ? minmaxs[i,1] : "N/A") / $(lenmm ? minmaxs[i,2] : "N/A")</td>
		  </tr>
		  """
		  textblock = textblock*newline
	  end
  end
  newline = """
  </table>
  </html>
  """
  textblock = textblock*newline
  return textblock
end

#/home/pi/temperaturelogs/2017-12-23.csv
#<td><a href="$(fl)" download>$(flss[end])</a></td>
