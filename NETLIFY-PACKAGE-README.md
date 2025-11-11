# 📦 NETLIFY DEPLOYMENT PACKAGE
# Copy all files in this package into a single folder
# Then follow the deployment instructions

## REQUIRED FILES FOR NETLIFY

### File 1: package.json
```json
{
  "name": "pyramid-platform",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "setup": "npm install"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "three": "^r150",
    "babylonjs": "^6.30.0",
    "babylonjs-gui": "^6.30.0",
    "@anthropic-ai/sdk": "latest",
    "express": "^4.18.0",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.2.0",
    "typescript": "^5.3.0"
  }
}
```

### File 2: netlify.toml
```toml
[build]
  command = "npm run build"
  functions = "netlify/functions"
  publish = "dist"

[build.environment]
  NODE_VERSION = "20"
  NPM_VERSION = "10"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/:splat"
  status = 200

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[functions]
  directory = "netlify/functions"
  node_bundler = "esbuild"

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
```

### File 3: vite.config.js
```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    sourcemap: false,
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
      },
    },
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8888',
        changeOrigin: true,
      },
    },
  },
})
```

### File 4: .gitignore
```
node_modules/
dist/
build/
.env
.env.local
.env.*.local
*.log
.DS_Store
.netlify
coverage/
.cache/
.vite/
```

### File 5: Directory Structure
```
pyramid-platform/
├── netlify/
│   └── functions/
│       ├── generate-model.js
│       ├── calculate-constraints.js
│       └── export-model.js
├── src/
│   ├── components/
│   │   ├── PyramidEditor.jsx
│   │   ├── AIGenerator.jsx
│   │   └── FirmamentViewer.jsx
│   ├── services/
│   │   └── 3d-lgm-ai.js
│   ├── App.jsx
│   ├── main.jsx
│   └── index.css
├── public/
│   └── index.html
├── package.json
├── netlify.toml
├── vite.config.js
└── .gitignore
```

## DEPLOYMENT STEPS

1. Create GitHub repo: https://github.com/new
2. Clone repo locally
3. Copy all files from this package
4. Run: npm install
5. Run: npm run build
6. Commit & push to GitHub
7. Go to https://app.netlify.com
8. Connect GitHub repository
9. Netlify auto-deploys!

## FILES YOU HAVE

You already have these files created (need to copy/organize):
- pyramid-editor-fixed.jsx → src/components/PyramidEditor.jsx
- 3d-lgm-ai.js → src/services/3d-lgm-ai.js
- generate-model.js → netlify/functions/generate-model.js
- App.jsx → src/App.jsx

## MISSING FILES TO CREATE

Copy the content below into these new files:
- src/main.jsx
- src/index.css
- src/components/AIGenerator.jsx
- src/components/FirmamentViewer.jsx
- public/index.html
- vite.config.js
- .gitignore
