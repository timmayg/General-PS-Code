#
#  This is meant to be run from your IDE (Powershell ISE \ VCode \ whatever)
#    All this script does is determine if a 3-way TCP handshake is able to complete. 
#
cls
$server="1.1.1.1"
$port="443"


$tcp = New-Object System.Net.Sockets.TcpClient
try { $tcp.connect("$server", "$port") 
      Write-Host -ForegroundColor Green Success
      Write-Host -ForegroundColor Green IP $server tcp $port
     }  catch [system.exception] {
      Write-Host -ForegroundColor Red Failure
      Write-Host -ForegroundColor Red IP $server tcp $port
      Write-Host -ForegroundColor Red $_.Exception.Message
     } 
