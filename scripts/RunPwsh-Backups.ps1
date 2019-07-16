# set up access to App Insights
$tcInstrumentationKey = Get-ChildItem env:"AI_INSTRUMENTATION_KEY"
$tc = [Microsoft.ApplicationInsights.TelemetryClient]::New()
$tc.InstrumentationKey = $tcInstrumentationKey

# log the job
$tc.TrackTrace("$((Get-Date).ToLongTimeString()) : Started running $($MyInvocation.MyCommand)")
$tc.Flush()

# make the cmdlets in the source modules available
. ./Get-Env.ps1
. ./Backup-Disk.ps1
. ./Backup-SplunkData.ps1

# execute the main cmdlet
Backup-SplunkData

# log the exit
$tc.TrackTrace("$((Get-Date).ToLongTimeString()) : Ended running $($MyInvocation.MyCommand)")
$tc.Flush()

# leave
exit
