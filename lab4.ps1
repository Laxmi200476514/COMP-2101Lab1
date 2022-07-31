#This function displays the Hardware Information
function get-hardware() 
{
  "System Hardware Information"
   Get-cimInstance Win32_ComputerSystem | select Description | fl 
}


#This function displays the OS Information
function get-os()
{
  "Operating System Information"
   Get-CimInstance Win32_OperatingSystem | select Name, version | fl
}


#This function displays the Processor Information
function get-processor()
{
  "Processor Information"
   Get-CimInstance win32_processor | select Description, CurrentClockSpeed, NumberOfCores, @{n="L1CacheSize";e={switch($_.L1CacheSize){$null{$var="data unavailable"}};$var}}, L2CacheSize, L3CacheSize | fl
}


#This function displays the Primary Memory Information
function get-memory()
{
  "Primary Memory Information"
$ram = 0
Get-CimInstance win32_physicalmemory |
  foreach { 
    New-Object -TypeName psObject -Property @{ 
      Vendor = $_.Manufacturer
      Description = $_.Description
      Size = $_.Capacity/1gb
      Bank = $_.BankLabel
      Slot = $_.DeviceLocator
      }

      $ram += $_.capacity/1gb
      }|
ft Vendor, Description, Size, Bank, Slot
"Total RAM: ${ram}GB"}


#This function displays the Disk Information
function get-disk()
{

  "Disk Information"
$diskdrives = Get-CIMInstance CIM_diskdrive
foreach ($disk in $diskdrives) {
    $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
    foreach ($partition in $partitions) {
          $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
          foreach ($logicaldisk in $logicaldisks) {
             new-object -typename psobject -property @{
               Manufacturer=$disk.Manufacturer
               Model=$disk.Model
               Location=$partition.deviceid
               Drive=$logicaldisk.deviceid
               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
               freeSpace      = [string]($logicalDisk.FreeSpace / 1gb -as [int]) + 'GB'
               "freeSpace(%)" = ([string]((($logicalDisk.FreeSpace / $logicalDisk.Size) * 100) -as [int]) + '%')
                } | ft Drive, Manufacturer, Model, Location, "Size(GB)", freespace, "freeSpace(%)"
           }
      }
  }
}


#This function displays the Network Information
function get-network()
{
  "Network Information"
  Get-CimInstance win32_networkadapterconfiguration |Where IPEnabled |
  select Index, IPAddress, IPSubnet, Description,
  @{n="DNSDomain";e={switch($_.DNSDomain){$null{$stat="data unavailable";$stat}};if($null -ne $_.DNSDomain){$_.DNSDomain}}},
 @{n="DNSServerSearchOrder";e={switch($_.DNSServerSearchOrder){$null{$stat="data unavailable";$stat}};if($null -ne $_.DNSServerSearchOrder){$_.DNSServerSearchOrder}}} | ft
}


#This function displays the Graphics Card Information
function get-video()
{
 "Graphics Card Information:"
$Horizontalpixels=(Get-CimInstance Win32_videocontroller).CurrentHorizontalResolution -as [String]
$Verticalpixels=(gwmi -classNAME win32_videocontroller).CurrentVerticalresolution -as [string]
$Bit=(gwmi -classNAME Win32_videocontroller).CurrentBitsPerPixel -as [string]
$Sum= $Horizontalpixels + " x " + $Verticalpixels + " and " + $Bit + " bits"
gwmi -classNAME win32_videocontroller|
fl @{n="Video Card Vendor"; e={$_.AdapterCompatibility}},
Description, @{n="Resolution"; e={$Sum -as [string]}}
}

