'use strict';

console.time('bundling');

const fs = require('fs');
const path = require('path');
const glob = require('glob');
const luabundle = require('luabundle');
const luamin = require('luamin');

console.log(`bundling started: ${new Date().toLocaleString()}`);
const isRelease = ((process.env.BUNDLING_ENV || '').trim() === 'release');
const isProduction = isRelease || ((process.env.BUNDLING_ENV || '').trim() === 'production');
const minifyModules = process.env.MINIFY_MODULES === true;
const minifyBundle = process.env.MINIFY_BUNDLE !== false;

console.log(`bundling mode: ${isProduction ? 'release' : 'debug'}`)

let globs;
try {
  globs = (!!process.env.BUNDLING_GLOBS) ? JSON.parse(process.env.BUNDLING_GLOBS) : null;
  if (typeof globs === 'string') {
    globs = [globs];
  }
}
catch (e) {
  globs = null;
}
const dirs = (globs || ['src/**/*.lua', 'lib/**/*.lua'])
  .map(gl => glob.sync(gl).map(luaFile => path.dirname(luaFile) + '/?.lua'))
  .reduce((prev, curr) => prev.concat(curr), []);
const paths = Array.from(new Set(dirs));
const bundleScript = luabundle.bundle('./src/main.lua', {
  force: process.env.LUABUNDLE_FORCE !== false,
  luaVersion: process.env.LUABUNDLE_LUAVERSION || '5.3',
  isolate: process.env.LUABUNDLE_ISOLATE !== false,
  preprocess: (module, options) => {
    return (minifyModules && isProduction)
      ? luamin.minify(module.content)
      : module.content;
  },
  metadata: (!!process.env.LUABUNDLE_METADATA) || (!isProduction),
  paths,
});

const mapScriptFile = './map.w3x/war3map.lua';
const mapScript = fs.readFileSync(mapScriptFile, { encoding: 'utf-8' });

const identifiers = {
  bundle: process.env.IDENTIFIERS_BUNDLE || '--!__inline_bundle__',
  hooks: process.env.IDENTIFIERS_HOOKS || '--!__inline_hooks__',
  begin: process.env.IDENTIFIERS_BEGIN || '--!__inline_begin__',
  end: process.env.IDENTIFIERS_END || '--!__inline_end__',
};

function prepareScript(script) {
  return (isProduction)
    ? luamin.minify(script)
    : script;
}

let clearMapScript = mapScript;
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
if (isRelease) {
  clearMapScript = `${positions.bundle.found
    ? `${identifiers.bundle}\n`
    : ''}${prepareScript(clearMapScript)
    }${positions.hooks.found
      ? `\n${identifiers.hooks}`
      : ''}`;
}

const wrappedBundle =
  `${process.env.BUNDLE_WRAP !== false ? 'function loadBundle()' : ''}
  ${bundleScript}
  ${process.env.BUNDLE_WRAP !== false ? 'end' : ''}
  ${process.env.BUNDLE_REQUIRE !== false ? 'require = loadBundle()' : ''}`;
const preparedScript =
  `${identifiers.bundle}\n${identifiers.begin}\n${(minifyBundle && isProduction)
    ? prepareScript(wrappedBundle)
    : wrappedBundle
  }\n${identifiers.end}`;
const bundledMapScript = positions.bundle.found
  ? clearMapScript.replace(identifiers.bundle, preparedScript)
  : `${preparedScript}\n${clearMapScript}`;


let finalMapScript = bundledMapScript;
if (process.env.HOOKS_ALL !== false) {
  const hooksScript =
    `mapMain = main
    main = function()
      ${process.env.HOOKS_BUNDLE_CHECK !== false ? 'if (loadBundle == nil) then print("ERROR: bundle loader not found!") end' : ''}
      ${process.env.HOOKS_BUNDLE_CHECK !== false ? 'if (require == nil) then print("ERROR: require not found!") end' : ''}
      ${process.env.HOOKS_PRE_MAIN !== false ? 'if mainPreHook ~= nil then runMapMain = mainPreHook() end' : ''}
      if runMapMain ~= false then mapMain() end
      ${process.env.HOOKS_POST_MAIN !== false ? 'if mainPostHook ~= nil then mainPostHook() end' : ''}
    end
    mapConfig = config
    config = function()
      ${process.env.HOOKS_PRE_CONFIG !== false ? 'if configPreHook ~= nil then runMapConfig = configPreHook() end' : ''}
      if runMapConfig ~= false then mapConfig() end
      ${process.env.HOOKS_POST_CONFIG !== false ? 'if configPostHook ~= nil then configPostHook() end' : ''}
    end`;
  const preparedHooksScript =
    `${identifiers.hooks}\n${identifiers.begin}\n${prepareScript(hooksScript)}\n${identifiers.end}`;
  const hookedMapScript = (positions.hooks.found)
    ? bundledMapScript.replace(identifiers.hooks, preparedHooksScript)
    : `${bundledMapScript}\n${preparedHooksScript}`;
  finalMapScript = hookedMapScript;
}


fs.writeFileSync(mapScriptFile, finalMapScript, { encoding: 'utf-8' });

const stats = fs.statSync(mapScriptFile);
const sizeInKB = stats.size / 1024;
// disclaimer: the perf below does NOT account for:
// map save time, file change detection, nodemon.json->delay or node.js startup time
console.timeEnd('bundling');
console.log(`bundling sucessful: ${new Date().toLocaleString()}`);
console.log(`war3map.lua: ${sizeInKB.toFixed(2)}KB`);
if (sizeInKB > 100) {
  console.error(`WARNING! MAP SIZE IS LARGER THAN 100KB AND MAY CAUSE ERRORS!`)
}