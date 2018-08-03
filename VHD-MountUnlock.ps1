<#
.NAME
    ITAR-Unlock.ps1
.SYNOPSIS
    Mounts and unlocks encrypted containers (VHD) to NTFS junctions.
.DESCRIPTION
    Script is intended to run at OS startup. Iterates through a given set of tuples, each tuple specifying the parameters needed for a container/project mount.
.NOTES
    __WARNING__ - DO NOT run this script with actively accessed projects mounted, as it will immediately unmount them, breaking any active sessions!
    DO feel safe to run during maintenance windows and testing (I.E. when no users are accessing projects) as it will not clobber any data.
    
    Define your container information in the tuples below.
    Example: $tup1 = [System.Tuple]::Create("<Filesystem Label>","<VHD container file path>","<Project/VHD mount point>","<Bitlocker recovery key>")
    Then, add a new tuple to $Projs.

    Revisions:
    v.1:  3/20/2018 - ssafari
    v.2:  4/06/2018 - ssafari
    v1.0: 5/01/2018 - kish
    v2.0: 6/05/2018 - kish
#>



## Container definitions - remove comment symbol to enable (#)
# $tup1 = [System.Tuple]::Create("<Filesystem Label>","<VHD container file path>","<Project/VHD mount point>","<Bitlocker recovery key>")
# $tup2 = [System.Tuple]::Create("<Filesystem Label>","<VHD container file path>","<Project/VHD mount point>","<Bitlocker recovery key>")

$Projs = ($tup1,$tup2)

$logPath = "C:<..>\ITAR-Unlock-log.txt" # Where to create log file

Set-Content -Value "Log file for ITAR-Unlock.ps1." $logPath # overwrites log each run
Add-Content -Value "-----------------------------" $logPath


$Projs | ForEach-Object 
{

    $filesystemLabel = $_.Item1    
    $pathtoVhd = $_.Item2
    $dirProjMount = $_.Item3
    $bitlockerRecoveryKey = $_.Item4

    Write-Output "Container: $pathtoVhd"
    Add-Content -Value "" $logPath
    Add-Content -Value "Container: $pathtoVhd" $logPath
    Add-Content -Value "-----------------------------" $logPath


    ## Dismount and mounted containers (just in case).
    Write-Output "Dismounting image: $pathtoVhd"
    Add-Content -Value "  Dismounting: $pathtoVhd " $logPath
    Dismount-DiskImage -ImagePath $pathtoVhd 
    

    ## Checks - Make sure directory mount point is empty so we don't clobber existing files.
    # If empty, proceed to clean up and mount container.
    # If not empty, stop running on that mount point.
    
    Write-Output "Confirming empty: $dirProjMount"
    Add-Content -Value "  Confirming empty: $dirProjMount" $logPath


    if((Get-ChildItem $dirProjMount -force | Select-Object -First 1 | Measure-Object).Count -eq 0)
    {

        Write-Output "$dirProjMount confirmed empty - continuing."
        Add-Content -Value "  $dirProjMount confirmed empty - continuing" $logPath

        ## Mount VHD.
        # Windows requires VHD/ISO mounts to have a drive letter. Windows can only mount as many disks as there are drive letters (until Z:).
        # Workaround is two part: 
        # 1. VHD's are configured to mount with a drive letter and a mount path (under Disk Manager).
        # 2. Add -NoDriveLetter flag to tell mount-diskimage to exclude the drive letter at mount.

        Write-Output "Attempting to mount VHD file: $pathtoVhd"
        Add-Content -Value "  Mounting VHD File: $pathtoVhd" $logPath
        Mount-DiskImage -ImagePath $pathtoVhd -NoDriveLetter -Passthru


        ## Bitlocker Unlock command - with Recovery Password
        Write-Output "Unlocking $dirProjMount with $bitlockerRecoveryKey"
        Add-Content -Value "  Unlocking $dirProjMount" $logPath
        Unlock-BitLocker -MountPoint $dirProjMount -RecoveryPassword $bitlockerRecoveryKey
   
    } Else
    {
        Write-Output "Error! There are files in the mount point $dirProjMount. This directory must be empty before the container can be mounted."
        Add-Content -Value "  Error! There are files in the mount point $dirProjMount. This directory must be empty before the container can be mounted." $logPath
    }

} # End ForEach-Object loop
