function maketemptable(timestamp, temp1, temp2)
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
     <td>24h min-max</td>
     <td> n/a - N/A </td>
     <td> n/a - N/A </td>
   </tr>
  </table>
  <h3>Historic data for download</h3>
  <table style=\"width:30%\" border=\"1\">
  <tr>
    <th>File date</th>
    <th>Download link</th>
  </tr>
  <tr>
    <td>2017/12/01</td>
    <td><a href=\"file:///tmpdata/mydatas.csv\">GetData</a></td>
  </tr>
  </table>
  </html>
  """
  return textblock
end
