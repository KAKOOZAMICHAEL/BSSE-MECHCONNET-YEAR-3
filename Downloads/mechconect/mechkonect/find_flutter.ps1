# Script to find Flutter installation on Windows

Write-Host "Searching for Flutter installation..." -ForegroundColor Yellow

# Common Flutter installation paths
$commonPaths = @(
    "C:\src\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat",
    "$env:USERPROFILE\flutter\bin\flutter.bat",
    "$env:LOCALAPPDATA\flutter\bin\flutter.bat",
    "C:\tools\flutter\bin\flutter.bat"
)

$foundFlutter = $null

# Check common paths
foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        $foundFlutter = $path
        Write-Host "`nFound Flutter at: $path" -ForegroundColor Green
        break
    }
}

# Search in Program Files
if (-not $foundFlutter) {
    Write-Host "Searching in Program Files..." -ForegroundColor Yellow
    $programFiles = Get-ChildItem -Path "C:\Program Files" -Filter "flutter.bat" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($programFiles) {
        $foundFlutter = $programFiles.FullName
        Write-Host "Found Flutter at: $foundFlutter" -ForegroundColor Green
    }
}

# Search in user directory
if (-not $foundFlutter) {
    Write-Host "Searching in user directory..." -ForegroundColor Yellow
    $userFlutter = Get-ChildItem -Path $env:USERPROFILE -Filter "flutter.bat" -Recurse -ErrorAction SilentlyContinue -Depth 3 | Select-Object -First 1
    if ($userFlutter) {
        $foundFlutter = $userFlutter.FullName
        Write-Host "Found Flutter at: $foundFlutter" -ForegroundColor Green
    }
}

# Search entire C: drive (slower, but thorough)
if (-not $foundFlutter) {
    Write-Host "`nFlutter not found in common locations." -ForegroundColor Yellow
    Write-Host "Would you like to search the entire C: drive? (This may take a while)" -ForegroundColor Yellow
    $response = Read-Host "Type 'yes' to continue"
    if ($response -eq "yes") {
        Write-Host "Searching C: drive for flutter.bat..." -ForegroundColor Yellow
        $foundFlutter = Get-ChildItem -Path "C:\" -Filter "flutter.bat" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($foundFlutter) {
            $foundFlutter = $foundFlutter.FullName
            Write-Host "Found Flutter at: $foundFlutter" -ForegroundColor Green
        }
    }
}

if ($foundFlutter) {
    $flutterBinPath = Split-Path -Parent $foundFlutter
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Flutter Bin Path: $flutterBinPath" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "To add Flutter to PATH for current session, run:" -ForegroundColor Yellow
    Write-Host "`$env:Path += `";$flutterBinPath`"" -ForegroundColor White
    
    Write-Host "`nTo add Flutter to PATH permanently:" -ForegroundColor Yellow
    Write-Host "1. Press Win + R, type: sysdm.cpl" -ForegroundColor White
    Write-Host "2. Go to Advanced tab → Environment Variables" -ForegroundColor White
    Write-Host "3. Edit System 'Path' variable" -ForegroundColor White
    Write-Host "4. Add: $flutterBinPath" -ForegroundColor White
    Write-Host "5. Restart PowerShell`n" -ForegroundColor White
    
    # Option to add to PATH now
    Write-Host "Would you like to add Flutter to PATH for this session?" -ForegroundColor Yellow
    $addToPath = Read-Host "Type 'yes' to add"
    if ($addToPath -eq "yes") {
        $env:Path += ";$flutterBinPath"
        Write-Host "`nFlutter added to PATH for this session!" -ForegroundColor Green
        Write-Host "Testing Flutter..." -ForegroundColor Yellow
        flutter --version
    }
} else {
    Write-Host "`nFlutter SDK not found on this system." -ForegroundColor Red
    Write-Host "`nPlease install Flutter:" -ForegroundColor Yellow
    Write-Host "1. Visit: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Download and extract Flutter SDK" -ForegroundColor White
    Write-Host "3. Add Flutter's bin folder to your PATH" -ForegroundColor White
    Write-Host "4. Run this script again`n" -ForegroundColor White
}




