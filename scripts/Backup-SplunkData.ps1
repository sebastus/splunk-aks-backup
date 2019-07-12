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

function Connect-AksEnvironment
{
    param
    (
        [Parameter(Mandatory=$true)]
        [String]$tenant_id,

        [Parameter(Mandatory=$true)]
        [String]$app_id,

        [Parameter(Mandatory=$true)]
        [String]$app_key,

        [Parameter(Mandatory=$true)]
        [String]$subscription_id,

        [Parameter(Mandatory=$true)]
        [String]$aks_rg,

        [Parameter(Mandatory=$true)]
        [String]$aks_name
    )    
    $passwd = ConvertTo-SecureString $app_key -AsPlainText -Force
    $pscredential = New-Object System.Management.Automation.PSCredential($app_id, $passwd)
    Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenant_id

    Get-AzSubscription -SubscriptionId $subscription_id -TenantId $tenant_id | Set-AzContext

    Import-AzAksCredential -ResourceGroupName $aks_rg -Name $aks_name
}

function Get-Env
{
    param
    (
        [Parameter(Mandatory=$true)]
        [String]$env
    )
    $var = Get-ChildItem env:$env
    $var.value
}

function Backup-SplunkData
{
    [CmdletBinding()]
    param
    (
    )
    BEGIN
    {
        Write-Verbose "$((Get-Date).ToLongTimeString()) : Started running $($MyInvocation.MyCommand)"

        # get environment vars
        $tenant_id = (Get-ChildItem env:AZURE_TENANT_ID).value
        $app_id = (Get-ChildItem env:AZURE_APP_ID).value
        $app_key = (Get-ChildItem env:AZURE_APP_KEY).value
        $subscription_id = (Get-ChildItem env:AZURE_SUBSCRIPTION_ID).value

        $aks_rg = (Get-ChildItem env:AKS_RG).value
        $aks_asset_rg = (Get-ChildItem env:AKS_ASSET_RG).value
        $aks_name = (Get-ChildItem env:AKS_NAME).value

        Connect-AksEnvironment $tenant_id, $app_id, $app_key, $subscription_id, $aks_rg, $aks_name
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

