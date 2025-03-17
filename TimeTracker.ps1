function Get-Tracker {
    param (
        [string]$ProcessName,
        [string]$SearchTerm,
        [string]$Browser
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
                try {
                    $processPath = (Get-Command $ProcessName -ErrorAction Stop).Source
                    Start-Process -FilePath $processPath -ErrorAction Stop
                }
                catch {
                    if ($SearchTerm -and $Browser) {
                        Set-YTSearch -searchTerm $SearchTerm -browser $Browser
                        continue
                    }
                }
            }
            $currentTimeString = $currentTime.ToString("HH:mm:ss")
            Write-Host "Current time: $currentTimeString"
            Write-Host "Time left: $(($endTime - $currentTime).ToString("mm\:ss"))"
            Start-Sleep -Seconds 1
            Clear-Host
        }
    }
}

function Set-TimeTrackerForWork {
    $processName = Read-Host "Enter the process name you want to track"
    
    $searchTerm = Read-Host "Enter the search term"
    $browser = Read-Host "Enter the browser you want to use (e.g., chrome, brave, edge): "
    Set-YTSearch -searchTerm $searchTerm -browser $browser
    
    Get-Tracker -ProcessName $processName -SearchTerm $searchTerm -Browser $browser
}

function Set-YTSearch {
    param (
        [string]$searchTerm,
        [string]$browser
    )

    $searchUrl = "https://www.youtube.com/results?search_query=$searchTerm"
    Write-Host "Opening $searchUrl in $browser"
    
    $browserExe = switch ($browser.ToLower()) {
        "chrome" { "chrome.exe" }
        "brave" { "brave.exe" }
        "edge" { "msedge.exe" }
        default { 
            Write-Host "Unsupported browser. Please use chrome, brave, or edge."
            return
        }
    }
    
    Start-Process $browserExe -ArgumentList $searchUrl
}

Set-TimeTrackerForWork
