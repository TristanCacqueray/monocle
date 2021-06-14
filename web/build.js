#!/usr/bin/env node
// A minimal build script using only esbuild

const fs = require('fs')
const isProd = process.env.NODE_ENV === '"production"'

// Build time options:
const optionDefault = (option, defaultValue) => typeof option !== 'undefined' ? ('"' + option + '"') : defaultValue
const title = optionDefault(process.env.REACT_APP_TITLE, '"Monocle"')

const isDesigner = process.env.NODE_ENV === '"designer"'

const esbuildOptions = {
  entryPoints: [isDesigner ? './src/Designer.bs.js' : './src/index.jsx'],
  outfile: './build/dist/bundle.js',
  bundle: true,
  sourcemap: true,
  minify: isProd,
  watch: process.argv.slice(2)[0] == 'watch',
  target: ['firefox87'],
  define: {
    'process.env.NODE_ENV': isProd ? '"production"' : '"development"',
    'process.env.REACT_APP_TITLE': title,
    global: 'window'
  },
  loader: {
    '.png': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file',
    '.svg': 'file',
    '.jpg': 'file'
  },
  logLevel: 'info'
};

// Ensure public asset are in sync:
['index.html', 'favicon.ico', 'robots.txt'].map((fn) => {
  fs.copyFile('public/' + fn, 'build/' + fn, (err) =>
    err ? console.log(err) : null
  )
})
require('esbuild')
  .build(esbuildOptions)
  .catch((err) => {
    console.error('Build failed:', err)
    process.exit(1)
  })
