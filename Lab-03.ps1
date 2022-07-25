function get-network()
{
Get-CimInstance win32_networkadapterconfiguration | Where IPEnabled | Select -Property Index, IPAddress, IPSubnet, DNSDomain, Description | ft
}