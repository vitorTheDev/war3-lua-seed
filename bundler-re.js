'use strict';

console.time('bundling');

require('dotenv').config();
const { readFile } = require('fs/promises');

const mapFile = await readFile('./map.w3x/war3map.lua', {encoding: 'utf-8'});

const identifiers = {
  bundle: process.env.IDENTIFIERS_BUNDLE || '--!__inline_bundle__',
  hooks: process.env.IDENTIFIERS_HOOKS || '--!__inline_hooks__',
  begin: process.env.IDENTIFIERS_BEGIN || '--!__inline_begin__',
  end: process.env.IDENTIFIERS_END || '--!__inline_end__',
};

if (!mapFile.includes(identifiers.bundle)) {
  new Worker('./bundler.js');
}