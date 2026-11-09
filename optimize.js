const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

// Parsear argumentos de línea de comandos
function parseArgs() {
  const args = process.argv.slice(2);
  const options = {
    input: null,
    output: null,
    recursive: false,
    quality: 82,
    webp: true
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '-i' || arg === '--input') {
      options.input = args[++i];
    } else if (arg === '-o' || arg === '--output') {
      options.output = args[++i];
    } else if (arg === '-r' || arg === '--recursive') {
      options.recursive = true;
    } else if (arg === '-q' || arg === '--quality') {
      options.quality = parseInt(args[++i], 10);
    } else if (arg === '--no-webp') {
      options.webp = false;
    }
  }

  return options;
}

// Función recursiva para obtener todas las imágenes manteniendo la ruta relativa
function getFiles(dir, recursive, baseDir = dir) {
  let results = [];
  const list = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of list) {
    const fullPath = path.join(dir, entry.name);
    const relativePath = path.relative(baseDir, fullPath);

    if (entry.isDirectory()) {
      if (recursive) {
        results = results.concat(getFiles(fullPath, recursive, baseDir));
      }
    } else {
      const ext = path.extname(entry.name).toLowerCase();
      if (['.jpg', '.jpeg', '.png', '.webp', '.tiff', '.avif'].includes(ext)) {
        results.push({ fullPath, relativePath });
      }
    }
  }

  return results;
}

async function processImages() {
  const config = parseArgs();

  if (!config.input || !config.output) {
    console.error('❌ Error: Debes especificar el directorio de entrada (-i) y salida (-o).');
    console.log('\nUso:');
    console.log('  node optimize.js -i <carpeta_origen> -o <carpeta_destino> [-r] [-q 82] [--no-webp]\n');
    console.log('Opciones:');
    console.log('  -i, --input      Carpeta de entrada (Requerido)');
    console.log('  -o, --output     Carpeta de salida (Requerido)');
    console.log('  -r, --recursive  Procesar subcarpetas manteniendo la jerarquía (Opcional)');
    console.log('  -q, --quality    Calidad de compresión de 1 a 100 (Por defecto: 82)');
    console.log('  --no-webp        Mantiene el formato original en vez de convertir a WebP\n');
    process.exit(1);
  }

  const inputDir = path.resolve(config.input);
  const outputDir = path.resolve(config.output);

  if (!fs.existsSync(inputDir)) {
    console.error(`❌ El directorio de entrada no existe: ${inputDir}`);
    process.exit(1);
  }

  const files = getFiles(inputDir, config.recursive);
  console.log(`📁 Procesando ${files.length} imagen(es) [Modo recursivo: ${config.recursive ? 'SÍ' : 'NO'}]...\n`);

  let totalSavedBytes = 0;

  for (const file of files) {
    const parsedPath = path.parse(file.relativePath);
    
    // Determinar nombre y extensión de salida
    const newExt = config.webp ? '.webp' : parsedPath.ext;
    const outputSubdir = path.join(outputDir, parsedPath.dir);
    const outputPath = path.join(outputSubdir, `${parsedPath.name}${newExt}`);

    // Crear la estructura de carpetas si no existe
    if (!fs.existsSync(outputSubdir)) {
      fs.mkdirSync(outputSubdir, { recursive: true });
    }

let pipeline = sharp(file.fullPath).rotate();
    const extOriginal = parsedPath.ext.toLowerCase();

    if (config.webp) {
      pipeline = pipeline.webp({ quality: config.quality, lossless: false });
    } else if (extOriginal === '.jpg' || extOriginal === '.jpeg') {
      pipeline = pipeline.jpeg({ quality: config.quality, mozjpeg: true });
    } else if (extOriginal === '.png') {
      pipeline = pipeline.png({ compressionLevel: 9, palette: true });
    }

    try {
      await pipeline.toFile(outputPath);
      
      const origSizeBytes = fs.statSync(file.fullPath).size;
      const newSizeBytes = fs.statSync(outputPath).size;
      totalSavedBytes += (origSizeBytes - newSizeBytes);

      const origSize = (origSizeBytes / 1024).toFixed(1);
      const newSize = (newSizeBytes / 1024).toFixed(1);
      const percent = (((origSizeBytes - newSizeBytes) / origSizeBytes) * 100).toFixed(0);

      console.log(`✔ ${file.relativePath} → ${parsedPath.name}${newExt} [${origSize} KB → ${newSize} KB] (-${percent}%)`);
    } catch (err) {
      console.error(`✖ Error en ${file.relativePath}:`, err.message);
    }
  }

  const totalSavedMB = (totalSavedBytes / (1024 * 1024)).toFixed(2);
  console.log(`\n✨ ¡Proceso completado! Ahorro total: ${totalSavedMB} MB`);
}

processImages();