# 🌑 Warcraft 3 Map Project Seed With Lua

A Wc3 map project template using Lua scripting language that allows code splitting and editing code while the World Editor is open.

* [Features](#features)
* [Installation](#Installation)
* [Usage](#Usage)
* [Caveats](#caveats)

## Features
* Bundling and code splitting
(via [luabundle](https://github.com/Benjamin-Dobell/luabundle))
* File watcher (via [nodemon](https://github.com/remy/nodemon))
* Bundle contents of the `src/` folder and inject them in the `map.w3x/war3map.lua` file
  * Thus enabling editing the map using the World Editor whilist editing lua with code editors like  [VSCode](https://code.visualstudio.com) without having to neither copy/paste code in the editor nor create a clone project
  * See [Caveats](#caveats)
* Soft minification (trim all lines, remove empty lines and comment only lines)
* File final bundle size check (max: 100KB)

## Installation
* Install [Node.js](https://nodejs.org/en/download/)
* Clone or download this repository, or click `Use Template`
* run `npm install` inside the directory
* Put your map in `map.w3x/` directory (already comes with an example map)

## Usage
### Development
* run `npm start` to bundle and watch for changes
* run `npm run bundle` to bundle only
### Release
* run `npm run bundle.prod` to bundle with soft code minification enabled
* run `npm run watch.prod` to watch for changes  with soft code minification enabled

## Caveats

* Map bundle injection or loading may fail if:
  * **Run Map immediatly after save**: World Editor saving takes a small amount of time, and change detection / bundling also has a small execution time. So if you test the map before bundling is done it won't work. Wait 2-5 seconds after save or wait for the `bundling complete` message in the console
  * **TestMap used istead of `map.w3x/`**: Unsaved changes in the World Editor cause it to create and run a temporary map TestMap. Since the path to TestMap is not known, it's not injected with lua bundle. Workaround: If you change anything in the World Editor (an asterisk appears on the World Editor window label `map.w3x*`), then you need to first SAVE and wait for change detection + compilation (~ 1 second) to test the map
  * **Map save detection fails**: watcher (nodemon) not runnig / watcher didn't wait before map save was complete (thus bundle was overwritten)
  * **Write was denied**: `map.w3x/war3map.lua` file is in use by another process or has read only permissions
* Files not required by the `src/main.lua` (`__root`) module or it's submodules are not included in the bundle, thus not acessible anywhere

## Enhancements to consider:
* Use lua [Global Initialization](https://www.hiveworkshop.com/threads/lua-global-initialization.317099/) instead of hooks
* `.env` or equivalent
* Make into npm package
* Fix TestMap caveat
* Make it easier to include external lua libraries
* Typescript to lua