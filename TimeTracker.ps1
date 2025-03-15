function Get-Tracker {
    param (
        [string]$ProcessName
    )
    $inputWorkTime = [int](Read-Host "How many minutes do you want to work?: ")
    $endTime = (Get-Date).AddMinutes($inputWorkTime)
    $endTimeString = $endTime.ToString("HH:mm:ss")
    Write-Host "End time: $endTimeString"
    $currentTime = Get-Date
    $currentTimeString = $currentTime.ToString("HH:mm:ss")
    while ($true) {
        $currentTime = Get-Date
        if ($currentTime -ge $endTime) {
            Write-Host "Time's up!"
            Add-Type -AssemblyName PresentationFramework
            [System.Windows.MessageBox]::Show("This is a popup message for you to stop working!")
            Clear-Host
            break
        } else {
            if (-not (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)) {
                Write-Host "Process $ProcessName has stopped. Restarting..."
                Start-Process -FilePath $ProcessName -ErrorAction Stop
            }
            $currentTimeString = $currentTime.ToString("HH:mm:ss")
            Write-Host "Current time: $currentTimeString"
            Write-Host "Time left: $(($endTime - $currentTime).ToString("mm\:ss"))"
            Start-Sleep -Seconds 1
            Clear-Host
        }
    }
    return $currentTimeString
}

function Set-TimeTrackerForWork {
    $processName = Read-Host "Enter the process name you want to track: "
    Write-Host "Starting time tracker for $processName"
    if (-not (Get-Process -Name $processName -ErrorAction SilentlyContinue)) {
        Write-Host "Process $processName is not running. Starting it now..."
        Start-Process -FilePath $processName -ErrorAction Stop
    }
    Get-Tracker -ProcessName $processName
    Stop-Process -Name $processName -Force
}

Set-TimeTrackerForWork