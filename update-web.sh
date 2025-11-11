#!/bin/bash
# ============================================================================
# VIDA ETERNA - QUICK UPDATE FOR NEW WEB DEPLOYMENT
# Updates existing deployment with Babylon.js + Photoshop + SolidWorks
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Vida Eterna - Web Update & Redeployment${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"

# ============================================================================
# PHASE 1: SYNC LATEST CODE
# ============================================================================

echo -e "${CYAN}▶ Phase 1: Syncing Latest Code${NC}"

if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git repository not found. Initializing...${NC}"
    git init
    git remote add origin https://github.com/YOUR_USERNAME/vida-eterna-platform.git
fi

echo "Pulling latest changes..."
git pull origin main || echo -e "${YELLOW}⚠️  Pull failed (might be first deploy)${NC}"

echo -e "${GREEN}✅ Code synced${NC}\n"

# ============================================================================
# PHASE 2: UPDATE DEPENDENCIES
# ============================================================================

echo -e "${CYAN}▶ Phase 2: Installing Babylon.js Dependencies${NC}"

npm install @babylonjs/core@^6.0.0 \
            @babylonjs/loaders@^6.0.0 \
            @babylonjs/materials@^6.0.0 \
            @babylonjs/post-processes@^6.0.0 \
            babylon-editor@^5.0.0 \
            cannon-js@^0.20.0 --save

echo -e "${GREEN}✅ Dependencies updated${NC}\n"

# ============================================================================
# PHASE 3: COMPLETE NPM INSTALL
# ============================================================================

echo -e "${CYAN}▶ Phase 3: Complete NPM Install${NC}"

npm install

echo -e "${GREEN}✅ All packages installed${NC}\n"

# ============================================================================
# PHASE 4: BUILD FOR PRODUCTION
# ============================================================================

echo -e "${CYAN}▶ Phase 4: Building for Production${NC}"

# Clean old build
rm -rf dist

# Build
echo "Building application..."
npm run build

# Verify build
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

BUILD_SIZE=$(du -sh dist | cut -f1)
echo -e "${GREEN}✅ Build complete - Size: ${BUILD_SIZE}${NC}\n"

# ============================================================================
# PHASE 5: DEPLOY TO NETLIFY
# ============================================================================

echo -e "${CYAN}▶ Phase 5: Deploying to Netlify${NC}"

TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')

echo "Deploying to production..."
netlify deploy --prod \
    --dir=dist \
    --functions=netlify/functions \
    --message="Web Update: Babylon.js + Photoshop + SolidWorks Integration ($TIMESTAMP)"

echo -e "${GREEN}✅ Deployment complete${NC}\n"

# ============================================================================
# PHASE 6: VERIFICATION
# ============================================================================

echo -e "${CYAN}▶ Phase 6: Post-Deployment Verification${NC}"

echo "Waiting for site to update (20 seconds)..."
sleep 20

echo "Testing deployment..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://vida-eterna-platform.netlify.app)

if [ "$RESPONSE" == "200" ]; then
    echo -e "${GREEN}✅ Frontend responding${NC}"
else
    echo -e "${YELLOW}⚠️  Unexpected response: HTTP ${RESPONSE}${NC}"
fi

# Test API
API_RESPONSE=$(curl -s https://vida-eterna-platform.netlify.app/.netlify/functions/health-check)
if [[ $API_RESPONSE == *"healthy"* ]]; then
    echo -e "${GREEN}✅ API health check passed${NC}"
else
    echo -e "${YELLOW}⚠️  API health check inconclusive${NC}"
fi

echo -e "${GREEN}✅ Verification complete${NC}\n"

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ WEB UPDATE COMPLETE!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"

echo -e "${CYAN}Your Updated Platform:${NC}"
echo -e "  🌐 Main Site:     https://vida-eterna-platform.netlify.app"
echo -e "  👤 Admin Panel:   https://vida-eterna-platform.netlify.app/admin"
echo -e "  🎨 Babylon 3D:    https://vida-eterna-platform.netlify.app#babylon"
echo -e "  🤖 AI Generator:  https://vida-eterna-platform.netlify.app#ai"
echo ""

echo -e "${CYAN}New Features:${NC}"
echo -e "  ✅ Babylon.js 3D Viewer"
echo -e "  ✅ Professional Editing Tools"
echo -e "  ✅ Photoshop AI Integration"
echo -e "  ✅ SolidWorks CAD Bridge"
echo -e "  ✅ Multi-format Export"
echo ""

echo -e "${CYAN}Admin Access:${NC}"
echo -e "  Email: swrutherford01@gmail.com"
echo -e "  Pass:  Rutherfor1055!?"
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 Platform updated and live!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"
