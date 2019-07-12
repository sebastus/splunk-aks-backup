<# 
   .SYNOPSIS - backup an AKS PVC
   .DESCRIPTION - 
   .PARAMETER - 
   .EXAMPLE - 

   Backup-Disk MC_gregAksRg_gregAksCluster_uksouth, splunk-idxcluster-data-indexer-0
    

   .NOTES 
   
   Name :   Backup-Disk
   Author : golive@microsoft.com 
   Version: V1.0 Initial Version 
#>

function Backup-Disk
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, 
            HelpMessage="Name of the resource group containing the AKS cluster.")]
        [String]$aks_asset_rg,
        [Parameter(Mandatory=$true, 
            HelpMessage="Name of the disk to be backed up.")]
        [String]$diskname,
        [Parameter(Mandatory=$true, 
            HelpMessage="Location of the snapshot.")]
        [String]$location
    )
    BEGIN
    {
        Write-Verbose "$((Get-Date).ToLongTimeString()) : Started running $($MyInvocation.MyCommand)"
    }
    PROCESS
    {
        $pvc = (get-content .\pvc_as.json | convertfrom-json)
        $item = ($pvc.items | where-object {$_.metadata.name -eq $diskname})
        $volumeName = $item.spec.volumeName
        $azdisk = Get-AzDisk -ResourceGroupName $aks_asset_rg -diskname "kubernetes-dynamic-$volumeName"

        $ssConfig =  New-AzSnapshotConfig -SourceUri $azdisk.Id -Location $location -CreateOption copy
        $Snapshot = New-AzSnapshot -Snapshot $ssConfig -SnapshotName "disk-$diskName" -ResourceGroupName $aks_asset_rg

        $Snapshot.Name
    }
    END
    {
        Write-Verbose "$((Get-Date).ToLongTimeString()) : Ended running $($MyInvocation.MyCommand)"
    }

}

