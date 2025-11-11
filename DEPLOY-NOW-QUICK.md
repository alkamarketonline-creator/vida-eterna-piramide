# 🚀 NETLIFY DEPLOYMENT - QUICK REFERENCE

## ALL FILES YOU NEED (13 Total)

### ✅ READY TO USE (Already Created)
```
[43]  package.json
[41]  netlify.toml
[87]  3d-lgm-ai.js
[90]  generate-model.js
[103] pyramid-editor-fixed.jsx
[110] App.jsx
[114] main.jsx
[115] index.css
[92]  index.html
```

### ⚠️ COPY THESE FILES

Go to the file references above and copy the content into these locations:

```
✅ Copy [43]  → pyramid-platform/package.json
✅ Copy [41]  → pyramid-platform/netlify.toml
✅ Copy [92]  → pyramid-platform/public/index.html
✅ Copy [114] → pyramid-platform/src/main.jsx
✅ Copy [110] → pyramid-platform/src/App.jsx
✅ Copy [115] → pyramid-platform/src/index.css
✅ Copy [87]  → pyramid-platform/src/services/3d-lgm-ai.js
✅ Copy [103] → pyramid-platform/src/components/PyramidEditor.jsx
✅ Copy [90]  → pyramid-platform/netlify/functions/generate-model.js
```

### 📝 CREATE THESE ADDITIONAL FILES

#### src/components/AIGenerator.jsx
```jsx
import React, { useState } from 'react';
import { generatePyramidModel, exportModel } from '../services/3d-lgm-ai';

const AIGenerator = () => {
  const [prompt, setPrompt] = useState('Pirámide 25m base, 33Hz');
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState(null);

  const generate = async () => {
    setLoading(true);
    try {
      const result = await generatePyramidModel(prompt);
      setData(result);
    } catch (error) {
      console.error('Generation failed:', error);
    }
    setLoading(false);
  };

  return (
    <div className="ai-generator">
      <h2>🤖 AI Pyramid Generator</h2>
      <textarea
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        placeholder="Describe your pyramid..."
        rows="4"
      />
      <button onClick={generate} disabled={loading}>
        {loading ? 'Generating...' : 'Generate Pyramid'}
      </button>
      {data && (
        <div className="specs">
          <p>Base: {data.baseWidth}m × {data.baseDepth}m</p>
          <p>Height: {data.height}m</p>
          <p>Material: {data.material}</p>
          <p>Frequency: {data.polarFrequency}Hz</p>
        </div>
      )}
    </div>
  );
};

export default AIGenerator;
```

#### src/components/FirmamentViewer.jsx
```jsx
import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';

const FirmamentViewer = () => {
  const containerRef = useRef(null);

  useEffect(() => {
    if (!containerRef.current) return;

    // Initialize Three.js scene for firmament
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(
      75,
      containerRef.current.clientWidth / containerRef.current.clientHeight,
      0.1,
      10000
    );
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    
    renderer.setSize(containerRef.current.clientWidth, containerRef.current.clientHeight);
    containerRef.current.appendChild(renderer.domElement);

    // Add stars
    const starGeometry = new THREE.BufferGeometry();
    const starCount = 5000;
    const positions = new Float32Array(starCount * 3);
    
    for (let i = 0; i < starCount * 3; i++) {
      positions[i] = (Math.random() - 0.5) * 5000;
    }
    
    starGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    const starMaterial = new THREE.PointsMaterial({ color: 0xffffff, size: 2 });
    const stars = new THREE.Points(starGeometry, starMaterial);
    scene.add(stars);

    camera.position.z = 100;

    const animate = () => {
      requestAnimationFrame(animate);
      stars.rotation.x += 0.0001;
      stars.rotation.y += 0.0001;
      renderer.render(scene, camera);
    };
    animate();

    return () => {
      containerRef.current?.removeChild(renderer.domElement);
    };
  }, []);

  return (
    <div className="firmament-viewer">
      <h2>🌌 Firmament 3D Viewer</h2>
      <div ref={containerRef} style={{ width: '100%', height: '600px' }} />
    </div>
  );
};

export default FirmamentViewer;
```

#### vite.config.js
```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    sourcemap: false,
    minify: 'terser',
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

#### .gitignore
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

---

## 📁 FOLDER STRUCTURE

```
pyramid-platform/
├── public/
│   └── index.html
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
├── netlify/
│   └── functions/
│       └── generate-model.js
├── package.json
├── netlify.toml
├── vite.config.js
└── .gitignore
```

---

## 🚀 DEPLOYMENT IN 3 STEPS

### Step 1: Setup Locally
```bash
mkdir pyramid-platform && cd pyramid-platform
# Copy all files from above into correct locations
npm install
```

### Step 2: Test
```bash
npm run build
# Should create dist/ folder with no errors
```

### Step 3: Deploy
```bash
git init
git add .
git commit -m "Deploy pyramid platform"
git remote add origin https://github.com/YOUR_USERNAME/pyramid-platform.git
git push -u origin main

# Then go to https://app.netlify.com
# Connect GitHub → Select repository
# Netlify auto-deploys!
```

---

## ✅ ENVIRONMENT VARIABLES (Netlify Dashboard)

```
ANTHROPIC_API_KEY = sk-ant-xxxxxxxx
DATABASE_URL = postgresql://... (optional)
```

---

## 🎯 RESULT

Your live site:
```
https://pyramid-platform.netlify.app
```

---

## 📞 REFERENCE DOCS

- Full guide: [116] NETLIFY-DEPLOYMENT-COMPLETE.md
- Export fixes: [104] EXPORT-FIX-GUIDE.md
- Build help: [106] REBUILD-REDEPLOY.md

---

**You have everything needed to deploy on Netlify! 🚀**
