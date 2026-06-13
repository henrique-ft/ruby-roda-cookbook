const esbuild = require('esbuild');
const manifestPlugin = require('esbuild-plugin-manifest');
const isWatchMode = process.argv.includes('--watch');
const isProduction = process.env.RACK_ENV === 'production';

const assetsEntryPoints = [
  'js/app.js',
  'css/app.css',
]

function config() {
  return {
    entryPoints: assetsEntryPoints.map((name) => `app/assets/${name}`),
    bundle: true,
    minify: isProduction,
    outdir: "public",
    entryNames: isProduction ? '[name]-[hash]' : '[name]',
    plugins: isProduction ? [
      manifestPlugin({ shortNames: true })
    ] : [],
  }
}

async function build() {
  try {
    if (isWatchMode) {
      const ctx = await esbuild.context(config());
      await ctx.watch();

      console.log(`Watching for css and js changes in '${entrypoints.join(', ')}'...`);
    } else {
      await esbuild.build(config());

      console.log(`Build complete.`);
    }
  } catch (error) {
    console.error('Build failed:', error);
    process.exit(1);
  }
}

build();
