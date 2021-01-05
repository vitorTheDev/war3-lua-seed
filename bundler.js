console.log(`bundling started: ${new Date().toLocaleString()}`);
console.time('bundling');

const isProduction = ((process.env.BUNDLING_ENV || '').trim() == 'release');
console.log(`bundling mode: ${isProduction ? 'release' : 'debug'}`)

const fs = require('fs');// import * as fs from 'fs';
const path = require('path');// import * as path from 'path';
const glob = require('glob');// import glob from 'glob';
const luabundle = require('luabundle');// import luabundle from 'luabundle';

const dirs = glob.sync('src/**/*.lua').map(luaFile => path.dirname(luaFile) + '/?.lua');
const paths = Array.from(new Set(dirs));
const bundleScript = luabundle.bundle('./src/main.lua', {
  force: process.env.LUABUNDLE_FORCE !== false,
  luaVersion: process.env.LUABUNDLE_LUAVERSION || '5.3',
  isolate: process.env.LUABUNDLE_LUAVERSION !== false,
  metadata: (!!process.env.LUABUNDLE_METADATA) || (!isProduction),
  paths,
});

const mapScriptFile = './map.w3x/war3map.lua';
const mapScript = fs.readFileSync(mapScriptFile, { encoding: 'utf-8' });

const identifiers = {
  file: '--__inline_bundle__',
  hooks: '--__inline_hooks__',
  begin: '--__inline_begin__',
  end: '--__inline_end__',
};

function prepareScript(script) {
  return script.split('\n')
    .map(l => isProduction
      ? l.trim()
      : l)
    .filter(l => {
      if (!isProduction) { return true; }
      const isComment = l.startsWith('--');
      const isIdentifier = Object.values(identifiers).includes(l.trim());
      // console.log(
      //   'isComment', isComment,
      //   'isIdentifier', isIdentifier,
      //   l,
      // );
      return isIdentifier || !isComment;
    })
    .map(l => (!!l.trim())
      ? l
      : (isProduction ? null : '\n'))
    .filter(l => l !== null)
    .join(isProduction
      ? '\n'
      : '\n    ');
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

clearMapScript = isProduction ? prepareScript(clearMapScript) : clearMapScript;
// console.log(clearMapScript);

const wrappedBundle =
  `${process.env.BUNDLE_WRAP !== false ? 'function loadBundle()' : ''}
    ${bundleScript}
  ${process.env.BUNDLE_WRAP !== false ? 'end' : ''}
  ${process.env.BUNDLE_REQUIRE !== false ? 'require = loadBundle()' : ''}`;
const preparedScript =
  `${identifiers.file}\n${identifiers.begin}\n${prepareScript(wrappedBundle)}\n${identifiers.end}`;
const bundledMapScript = positions.file.found
  ? clearMapScript.replace(identifiers.file, preparedScript)
  : `${preparedScript}\n${clearMapScript}`;


let finalMapScript = bundledMapScript;
// todo: use Lua Initialization? https://www.hiveworkshop.com/threads/lua-global-initialization.317099/
if (process.env.HOOKS_ALL) {
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
console.timeEnd('bundling');
console.log(`bundling sucessful: ${new Date().toLocaleString()}`);
console.log(`war3map.lua: ${sizeInKB.toFixed(2)}KB`);
if (sizeInKB > 100) {
  console.error(`WARNING! MAP SIZE IS LARGER THAN 100KB AND MAY CAUSE ERRORS!`)
}