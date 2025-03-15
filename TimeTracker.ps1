function Get-Tracker {
    $inputWorkTime = [int](Read-Host "How long do you want to work?: ")
    $endTime = (Get-Date).AddMinutes($inputWorkTime)
    $endTimeString = $endTime.ToString("HH:mm:ss")
    Write-Host "End time: $endTimeString"
    while($true) {
        $currentTime = Get-Date
        $currentTimeString = $currentTime.ToString("HH:mm:ss")
        Write-Host "Current time: $currentTimeString"
        if($currentTime -ge $endTime) {
            Write-Host "Time's up!"
            Add-Type -AssemblyName PresentationFramework[System.Windows.MessageBox]::Show("This is a popup message for you to stop working!")
            break
        }
        Start-Sleep -Seconds 1
        Clear-Host
    }
}

Get-Tracker