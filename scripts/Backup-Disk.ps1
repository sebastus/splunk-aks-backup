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
        [String]$diskname
    )
    BEGIN
    {
        $tcInstrumentationKey = "148b913b-2236-43a1-a600-b396d250c976"
        $tc = [Microsoft.ApplicationInsights.TelemetryClient]::New()
        $tc.InstrumentationKey = $tcInstrumentationKey

        $tc.TrackTrace("$((Get-Date).ToLongTimeString()) : Started running $($MyInvocation.MyCommand)")
    }
    PROCESS
    {

        $pvc = (get-content .\pvc_as.json | convertfrom-json)
        $item = ($pvc.items | where-object {$_.metadata.name -eq $diskname})
        $volumeName = $item.spec.volumeName
        $azdisk = Get-AzDisk -ResourceGroupName $aks_asset_rg -diskname "kubernetes-dynamic-$volumeName"

        $ErrorActionPreference = "SilentlyContinue"
        $ss = Get-AzSnapshot -ResourceGroupName $aks_asset_rg -name $diskName
        if ($null -ne $ss)
        {
            $tc.TrackTrace("Removing old snapshot $diskName.")
            $ss | Remove-AzSnapshot -Force
        }
        $ErrorActionPreference = "continue"

        $tc.TrackTrace("Backing up disk: $diskName.")
        $ssConfig =  New-AzSnapshotConfig -SourceUri $azdisk.Id -Location $azdisk.location -CreateOption copy
        New-AzSnapshot -Snapshot $ssConfig -SnapshotName $diskName -ResourceGroupName $aks_asset_rg

    }
    END
    {
        $tc.TrackTrace("$((Get-Date).ToLongTimeString()) : Ended running $($MyInvocation.MyCommand)")
    }

}

