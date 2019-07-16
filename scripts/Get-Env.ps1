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
