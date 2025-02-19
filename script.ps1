function Check-Installed {
    param (
        [string]$Command,
        [string]$CheckString
    )
    try {
        $output = & $Command 2>$null
        return $output -match $CheckString
    } catch {
        return $false
    }
}

function Install-PowerToys {
    param ([string]$Method)
    switch ($Method) {
        "winget" {
            if (Check-Installed -Command "winget list" -CheckString "PowerToys") {
                Write-Host "PowerToys is already installed via Winget."
            } else {
                winget install --id Microsoft.PowerToys --source winget
            }
        }
        "choco" {
            if (Check-Installed -Command "choco list --local-only" -CheckString "powertoys") {
                Write-Host "PowerToys is already installed via Chocolatey. Upgrading..."
                choco upgrade powertoys -y
            } else {
                choco install powertoys -y
            }
        }
        "scoop" {
            scoop bucket add extras
            if (Check-Installed -Command "scoop list" -CheckString "powertoys") {
                Write-Host "PowerToys is already installed via Scoop. Upgrading..."
                scoop update powertoys
            } else {
                scoop install powertoys
            }
        }
        "github" {
            Start-Process "https://github.com/microsoft/PowerToys/releases" -Wait
        }
        "store" {
            Start-Process "ms-windows-store://pdp/?ProductId=9N8D0KXF2MWS" -Wait
        }
        default {
            Write-Host "Invalid option."
        }
    }
}

while ($true) {
    Clear-Host
    Write-Host "Select an installation method for PowerToys:" -ForegroundColor Cyan
    Write-Host "1. Winget"
    Write-Host "2. Chocolatey"
    Write-Host "3. Scoop"
    Write-Host "4. GitHub (Open Download Page)"
    Write-Host "5. Microsoft Store (Open Store Page)"
    Write-Host "6. Exit"
    
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { Install-PowerToys -Method "winget" }
        "2" { Install-PowerToys -Method "choco" }
        "3" { Install-PowerToys -Method "scoop" }
        "4" { Install-PowerToys -Method "github" }
        "5" { Install-PowerToys -Method "store" }
        "6" { exit }
        default { Write-Host "Invalid selection, try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
    }
}
