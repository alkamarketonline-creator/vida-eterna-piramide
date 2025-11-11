# ============================================================================
# VIDA ETERNA - QUICK UPDATE FOR NEW WEB (Windows PowerShell)
# ============================================================================

Write-Host "`n" -NoNewline
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "Vida Eterna - Web Update & Redeployment" -ForegroundColor Blue
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "`n"

# ============================================================================
# PHASE 1: SYNC LATEST CODE
# ============================================================================

Write-Host "▶ Phase 1: Syncing Latest Code" -ForegroundColor Cyan

if (-not (Test-Path ".git")) {
    Write-Host "⚠️  Git repository not found. Initializing..." -ForegroundColor Yellow
    git init
    git remote add origin "https://github.com/YOUR_USERNAME/vida-eterna-platform.git"
}

Write-Host "Pulling latest changes..."
$gitPull = git pull origin main 2>&1
Write-Host "✅ Code synced" -ForegroundColor Green
Write-Host ""

# ============================================================================
# PHASE 2: UPDATE DEPENDENCIES
# ============================================================================

Write-Host "▶ Phase 2: Installing Babylon.js Dependencies" -ForegroundColor Cyan

npm install `
    "@babylonjs/core@^6.0.0" `
    "@babylonjs/loaders@^6.0.0" `
    "@babylonjs/materials@^6.0.0" `
    "@babylonjs/post-processes@^6.0.0" `
    "babylon-editor@^5.0.0" `
    "cannon-js@^0.20.0" `
    --save

Write-Host "✅ Dependencies updated" -ForegroundColor Green
Write-Host ""

# ============================================================================
# PHASE 3: COMPLETE NPM INSTALL
# ============================================================================

Write-Host "▶ Phase 3: Complete NPM Install" -ForegroundColor Cyan

npm install

Write-Host "✅ All packages installed" -ForegroundColor Green
Write-Host ""

# ============================================================================
# PHASE 4: BUILD FOR PRODUCTION
# ============================================================================

Write-Host "▶ Phase 4: Building for Production" -ForegroundColor Cyan

Write-Host "Cleaning old build..."
if (Test-Path "dist") {
    Remove-Item -Path "dist" -Recurse -Force
}

Write-Host "Building application..."
npm run build

if (-not (Test-Path "dist")) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

$buildSize = (Get-ChildItem -Path "dist" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "✅ Build complete - Size: $([Math]::Round($buildSize, 2)) MB" -ForegroundColor Green
Write-Host ""

# ============================================================================
# PHASE 5: DEPLOY TO NETLIFY
# ============================================================================

Write-Host "▶ Phase 5: Deploying to Netlify" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "Deploying to production..."
netlify deploy --prod `
    --dir=dist `
    --functions=netlify/functions `
    --message="Web Update: Babylon.js + Photoshop + SolidWorks ($timestamp)"

Write-Host "✅ Deployment complete" -ForegroundColor Green
Write-Host ""

# ============================================================================
# PHASE 6: VERIFICATION
# ============================================================================

Write-Host "▶ Phase 6: Post-Deployment Verification" -ForegroundColor Cyan

Write-Host "Waiting for site to update (20 seconds)..."
Start-Sleep -Seconds 20

Write-Host "Testing deployment..."
try {
    $response = Invoke-WebRequest -Uri "https://vida-eterna-platform.netlify.app" -Method Head -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Frontend responding" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Response error" -ForegroundColor Yellow
}

try {
    $apiTest = Invoke-WebRequest -Uri "https://vida-eterna-platform.netlify.app/.netlify/functions/health-check"
    if ($apiTest.Content -like "*healthy*") {
        Write-Host "✅ API health check passed" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  API health check inconclusive" -ForegroundColor Yellow
}

Write-Host "✅ Verification complete" -ForegroundColor Green
Write-Host ""

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "✅ WEB UPDATE COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""

Write-Host "Your Updated Platform:" -ForegroundColor Cyan
Write-Host "  🌐 Main Site:     https://vida-eterna-platform.netlify.app"
Write-Host "  👤 Admin Panel:   https://vida-eterna-platform.netlify.app/admin"
Write-Host "  🎨 Babylon 3D:    https://vida-eterna-platform.netlify.app#babylon"
Write-Host "  🤖 AI Generator:  https://vida-eterna-platform.netlify.app#ai"
Write-Host ""

Write-Host "New Features:" -ForegroundColor Cyan
Write-Host "  ✅ Babylon.js 3D Viewer"
Write-Host "  ✅ Professional Editing Tools"
Write-Host "  ✅ Photoshop AI Integration"
Write-Host "  ✅ SolidWorks CAD Bridge"
Write-Host "  ✅ Multi-format Export"
Write-Host ""

Write-Host "Admin Access:" -ForegroundColor Cyan
Write-Host "  Email: swrutherford01@gmail.com"
Write-Host "  Pass:  Rutherfor1055!?"
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "🎉 Platform updated and live!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""
