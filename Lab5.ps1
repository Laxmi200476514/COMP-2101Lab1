Param(
   [Parameter(position=1)]
   [switch]$system ,
  
   [Parameter(Position=2)]
   [switch]$disk ,
 
   [Parameter(Position=3)]
   [switch]$network

)



if ($system -ne $true -and $disk -ne $true -and $network -ne $true) 
{
    welcome
    cpuinfo
    get-mydisks
    get-system
    get-network
    get-disk
}

elseif ($disk -eq $true) {
    get-disk
}

elseif ($network -eq $true) {
    get-network
}

elseif ($system -eq $true) {
    get-system
}