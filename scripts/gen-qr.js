#!/usr/bin/env node
// QRコード生成スクリプト
// 使用例: node scripts/gen-qr.js <URL> [output.png]

import QRCode from 'qrcode';
import { resolve, dirname } from 'path';
import { mkdirSync } from 'fs';
import { fileURLToPath } from 'url';

const args = process.argv.slice(2);
if (args.length === 0 || args[0] === '--help' || args[0] === '-h') {
  console.error('Usage: node scripts/gen-qr.js <URL> [output.png]');
  console.error('');
  console.error('  URL         公開URL（必須）');
  console.error('  output.png  出力先パス（省略時: assets/qr.png）');
  process.exit(args.length === 0 ? 1 : 0);
}

const url = args[0];
const outputPath = args[1] ? resolve(args[1]) : resolve('assets/qr.png');

mkdirSync(dirname(outputPath), { recursive: true });

await QRCode.toFile(outputPath, url, {
  type: 'png',
  width: 512,
  margin: 2,
  color: {
    dark: '#000000',
    light: '#ffffff',
  },
});

console.log(`[gen-qr] ${url} → ${outputPath}`);
