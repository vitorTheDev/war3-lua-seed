# 🌑 Warcraft 3 Map Project Seed With Lua

A Wc3 map project template using Lua scripting language that allows code splitting and editing code while the World Editor is open.

* [Features](#features)
* [Instalation](#Instalation)
* [Usage](#Usage)
* [Caveats](#caveats)

## Features
* Bundling and code splitting
(via [luabundle](https://github.com/Benjamin-Dobell/luabundle))
* File watcher (via [nodemon](https://github.com/remy/nodemon))
* Bundle contents of the `src/` folder and inject them in the `map.w3x/war3map.lua` file enables editing the map using the World Editor) whilist editing lua with code editors (e.g. [VSCode](https://code.visualstudio.com)) without having to neither copy/paste code in the editor nor create a clone project. See [Caveats](#caveats)
* Soft minification (trim all lines, remove empty lines and comment only lines)
* File final bundle size check (max: 100KB)

## Instalation
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
* run `npm run watch.prod` to watch for changles  with soft code minification enabled

## Caveats

* Unsaved changes in the World Editor cause it to create and run a temporary map TestMap. Sinde the path to TestMap is not known, it's not injected with lua bundle. Workaround: If you change anything in the World Editor (an asterisk appears on the World Editor window label `map.w3x*`), then you need to first SAVE and wait for change detection + compilation (~ 1 second) to test the map.
* Files not required by the `src/main.lua` (`__root`) module or it's submodules are not included in the bundle, thus not acessible anywhere

## Enhancements to consider:
* Use lua [Global Initialization](https://www.hiveworkshop.com/threads/lua-global-initialization.317099/) instead of hooks
* Make into npm package
* Fix TestMap caveat
* Make it easier to include external lua libraries
* Typescript to lua