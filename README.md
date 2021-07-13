# 🌑 Warcraft 3 Map Project Seed With Lua

A Warcraft 3 map project template using Lua scripting language that allows code splitting and editing code while the World Editor is open. Powered by [Node.js](https://nodejs.org).

* [Features](#features)
* [Installation](#Installation)
* [Usage](#Usage)
* [Caveats](#caveats)

## Features
* Bundling and code splitting
(via [Luabundle](https://github.com/Benjamin-Dobell/luabundle))
* File watcher (via [nodemon](https://github.com/remy/nodemon))
* Bundle contents of the `src/` (and `lib/` for external libraries like [damage-engine.lua](https://github.com/BribeFromTheHive/DamageEngine/blob/master/script.lua)) folder and inject them in the `map.w3x/war3map.lua` file
  * Thus enabling editing the map using the World Editor whilist editing lua with code editors like  [VSCode](https://code.visualstudio.com) without having to neither copy/paste code in the editor nor create a clone project
  * See [Caveats](#caveats)
* Code minification using [Luamin](https://www.npmjs.com/package/luamin)
* Bundle file size check (warning if > 100KB)

## Installation
* [Install Node.js](https://nodejs.org#download)
* Clone or download this repository, or click [https://github.com/rodolfoThePig/war3-lua-seed/generate](Use Template)
* run `npm install` inside the directory
* Put your map in `map.w3x/` directory (already comes with an example map)

## Usage
### Development
* run `npm start` to bundle and watch for changes
* run `npm run bundle` to bundle only
### Production
* run `npm run bundle.prod` to watch for changes with minification enabled
* run `npm run watch.prod` to watch for changes with minification enabled

## Caveats

* Map bundle injection or loading may fail if:
  * **Run Map immediatly after save**: World Editor saving takes a small amount of time, and change detection / bundling also has a small execution time. So if you test the map before bundling is done it won't work. Wait a few seconds after save or wait for the `bundling complete` message in the console
  * **TestMap used istead of `map.w3x/`**: Unsaved changes in the World Editor cause it to create and run a temporary map TestMap. Since the path to TestMap is not known, it's not injected with lua bundle. Workaround: If you change anything in the World Editor (an asterisk appears on the World Editor window label `map.w3x*`), then you need to first SAVE in the editor and wait for change detection + compilation (~ 1 second) before clicking Test Map 
  * **Map save detection fails**: watcher not runnig / watcher didn't wait before map save was complete (thus bundle was overwritten)
  * **Write was denied**: `map.w3x/war3map.lua` file is in use by another process or has read only permissions
* Files not required by the `src/main.lua` (`__root`) module or it's submodules are not included in the bundle, thus not acessible anywhere (including external libs at `lib/`)

## Enhancements to consider:
* Map source backup option
* Use lua [Global Initialization](https://www.hiveworkshop.com/threads/lua-global-initialization.317099/) instead of hooks
* ~~`.env` or equivalent~~
* Fix TestMap TempFolder caveat
* Make it easier to include external Lua libraries
  * [LuaRocks](https://luarocks.org)
  * [lua-loader](https://www.npmjs.com/package/lua-loader)
* [Typescript to Lua](https://www.npmjs.com/package/typescript-to-lua)
* Make into npm package
* Make into npm package
* ~~Create `release` mode that minifies the map completely (smaller) but is irreversible, and should instead create a new file in a `/dist` folder or create a backup file~~

----
## License
MIT
