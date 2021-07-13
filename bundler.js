'use strict';

console.time('bundling');

require('dotenv').config();
const fs = require('fs');
const path = require('path');
const glob = require('glob');
const luabundle = require('luabundle');
const luamin = require('luamin');
const ncp = require('ncp');

console.log(`bundling started: ${new Date().toLocaleString()}`);
const isRelease = ((process.env.BUNDLING_ENV || '').trim() === 'release');
const isProduction = ((process.env.BUNDLING_ENV || '').trim() === 'production');
const minifyModules = isProduction;
const minifyBundle = isRelease;

console.log(`bundling mode: ${isRelease ? 'release' : (isProduction ? 'production' : 'debug')}`);

let globs;
try {
  globs = (!!process.env.INCLUDE_GLOBS) ? JSON.parse(process.env.INCLUDE_GLOBS) : null;
  if (typeof globs === 'string') {
    globs = [globs];
  }
}
catch (e) {
  globs = null;
}
if (!globs) {
  globs = null;
}
const dirs = ['src/**/*.lua', 'lib/**/*.lua', 'lua_modules/**/*.lua', ...(globs || [])]
  .map(gl => glob.sync(gl).map(luaFile => path.dirname(luaFile) + '/?.lua'))
  .reduce((prev, curr) => prev.concat(curr), []);
const paths = Array.from(new Set(dirs));

function prepareScript(script, minify) {
  return (minify) ? luamin.minify(script) : script;
}
function prepareModules(script) {
  return prepareScript(script, minifyModules);
}
function prepareBundle(script) {
  return prepareScript(script, minifyBundle);
}

const bundleScript = luabundle.bundle('./src/main.lua', {
  force: process.env.LUABUNDLE_FORCE !== false,
  luaVersion: process.env.LUABUNDLE_LUAVERSION || '5.3',
  isolate: process.env.LUABUNDLE_ISOLATE !== false,
  metadata: (!!process.env.LUABUNDLE_METADATA) || (!isProduction),
  paths,
});

const sourceMapDir = './map.w3x';
const sourceMapFile = `${sourceMapDir}/war3map.lua`;
const sourceScript = fs.readFileSync(sourceMapFile, { encoding: 'utf-8' });

const identifiers = {
  bundle: process.env.IDENTIFIERS_BUNDLE || '--!__inline_bundle__',
  hooks: process.env.IDENTIFIERS_HOOKS || '--!__inline_hooks__',
  begin: process.env.IDENTIFIERS_BEGIN || '--!__inline_begin__',
  end: process.env.IDENTIFIERS_END || '--!__inline_end__',
};


let clearMapScript = sourceScript;
let positions;
do {
  positions = Object.entries(identifiers)
    .map(([key, identifier]) => ({ key, identifier, index: clearMapScript.indexOf(identifier) }))
    .map(identifierObj => ({
      ...identifierObj,
      found: (!isNaN(identifierObj.index)) && identifierObj.index !== -1,
    }))
    .reduce((prev, curr) => ({ ...prev, [curr.key]: curr, }), {});
  const oldScript = clearMapScript.slice(positions.begin.index - 1, positions.end.index + identifiers.end.length);
  clearMapScript = clearMapScript.replace(oldScript, '');
} while (positions.begin.found && positions.end.found);

const bundledModules = clearMapScript;
if (isRelease) {
  clearMapScript = bundledModules;
} else {
  clearMapScript = `${positions.bundle.found
    ? `${identifiers.bundle}\n`
    : ''
    } ${bundledModules
    } ${positions.hooks.found
      ? `\n${identifiers.hooks}`
      : ''
    } `;
}

const wrappedBundle =
  `${process.env.BUNDLE_WRAP !== false ? 'function loadBundle()' : ''}
  ${bundleScript}
  ${process.env.BUNDLE_WRAP !== false ? 'end' : ''}
  ${process.env.BUNDLE_REQUIRE !== false ? 'require = loadBundle()' : ''} `;
const preparedScript =
  `${identifiers.bundle} \n${identifiers.begin} \n${prepareModules(wrappedBundle)} \n${identifiers.end} `;
const bundledMapScript = positions.bundle.found
  ? clearMapScript.replace(identifiers.bundle, preparedScript)
  : `${preparedScript} \n${clearMapScript} `;

let finalMapScript = bundledMapScript;
if (process.env.HOOKS_ALL !== false) {
  const hooksScript =
    `  mapMain = main
  main = function ()
      ${process.env.HOOKS_BUNDLE_CHECK !== false ? 'if (loadBundle == nil) then print("ERROR: bundle loader not found!") end' : ''}
  ${process.env.HOOKS_BUNDLE_CHECK !== false ? 'if (require == nil) then print("ERROR: require not found!") end' : ''}
  ${process.env.HOOKS_PRE_MAIN !== false ? 'if mainPreHook ~= nil then runMapMain = mainPreHook() end' : ''}
  if runMapMain ~= false then mapMain() end
  ${process.env.HOOKS_POST_MAIN !== false ? 'if mainPostHook ~= nil then mainPostHook() end' : ''}
  end
  mapConfig = config
  config = function ()
      ${process.env.HOOKS_PRE_CONFIG !== false ? 'if configPreHook ~= nil then runMapConfig = configPreHook() end' : ''}
  if runMapConfig ~= false then mapConfig() end
  ${process.env.HOOKS_POST_CONFIG !== false ? 'if configPostHook ~= nil then configPostHook() end' : ''}
  end`;
  const preparedHooksScript =
    `${identifiers.hooks} \n${identifiers.begin} \n${prepareModules(hooksScript)} \n${identifiers.end} `;
  const hookedMapScript = (positions.hooks.found)
    ? bundledMapScript.replace(identifiers.hooks, preparedHooksScript)
    : `${bundledMapScript} \n${preparedHooksScript} `;
  finalMapScript = prepareBundle(hookedMapScript);
}

const targetMapDir = `./${isProduction ? 'prod' : (isRelease ? 'release' : 'map')}.w3x`;
const targetMapScriptFile = `${targetMapDir}/war3map.lua`;
try {
  if (!fs.statSync(targetMapDir)?.isDirectory()) {
    throw new Error();
  }
} catch {
  fs.mkdirSync(targetMapDir);
}

function finalizeBundling() {
  fs.writeFileSync(targetMapScriptFile, finalMapScript, { encoding: 'utf-8' });
  const stats = fs.statSync(targetMapScriptFile);
  const sizeInKB = stats.size / 1024;
  // disclaimer: the perf below does NOT account for:
  // map save time, file change detection, nodemon delay or node.js startup time
  console.timeEnd('bundling');
  console.log(`bundling sucessful: ${new Date().toLocaleString()}`);
  console.log(`${targetMapScriptFile}: ${sizeInKB.toFixed(2)}KB`);
  if (sizeInKB > 100) {
    console.error(`WARNING! MAP SIZE IS LARGER THAN 100KB AND MAY CAUSE ERRORS!`)
  }
}

if (isProduction || isRelease) {
  ncp(sourceMapDir, targetMapDir, (_err) => {
    finalizeBundling();
  });
} else {
  finalizeBundling();
}
