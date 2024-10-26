require('esbuild').build({
  entryPoints: ['./app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  loader: { '.js': 'jsx' },
  format: 'esm',
}).catch(() => process.exit(1));
