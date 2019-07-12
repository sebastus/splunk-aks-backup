<# 
   .SYNOPSIS - backup Splunk indexer data & config disks
   .DESCRIPTION - 
   .PARAMETER - 
   .EXAMPLE - 

   Backup-SplunkData
    

   .NOTES 
   
   Name :   Backup-SplunkData
   Author : golive@microsoft.com 
   Version: V1.0 Initial Version 
#>

function Backup-Disk
{
    [CmdletBinding()]
    param
    (
    )
    BEGIN
    {
        # get environment vars
        $tenant_id = Get-ChildItem env:AZURE_TENANT_ID
        $app_id = Get-ChildItem env:AZURE_APP_ID
        $app_key = Get-ChildItem env:AZURE_APP_KEY
        $aks_rg = Get-ChildItem env:AKS_RG
        $aks_name = Get-ChildItem env:AKS_NAME

        Write-Verbose "$((Get-Date).ToLongTimeString()) : Started running $($MyInvocation.MyCommand)"
    }
    PROCESS
    {
        kubectl -n splunk get pvc -o json > pvc_as.json
    }
    END
    {
        Write-Verbose "$((Get-Date).ToLongTimeString()) : Ended running $($MyInvocation.MyCommand)"
    }

}

