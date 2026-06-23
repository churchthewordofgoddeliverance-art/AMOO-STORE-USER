const fs = require('fs');
const path = require('path');
function walk(dir, files=[]) {
  fs.readdirSync(dir).forEach(f => {
    const fp = path.join(dir,f);
    if (fs.statSync(fp).isDirectory()) {
      if (f === 'node_modules') return;
      walk(fp, files);
    } else if (fp.endsWith('.js')) files.push(fp);
  });
  return files;
}
const files = walk(process.cwd());
let ok = true;
for (const f of files) {
  try {
    const src = fs.readFileSync(f,'utf8');
    new Function(src);
  } catch (e) {
    console.error('SYNTAX ERROR in', f + ':', e.message);
    ok = false;
  }
}
if (ok) console.log('ALL_OK'); else process.exit(1);
