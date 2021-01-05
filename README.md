# Warcraft 3 Map Project Seed With Lua

## Instalation
* Install [Node.js](https://nodejs.org/en/download/)
* Clone or download this repository
* run `npm install` inside the directory
----------------
## Usage
* Put your map in `/map.w3x` directory (already comes with an example map)
* run `npm run bundle` to bundle the contents of the `/src` folder and insert them in the `map.w3x`
* run `npm run watch` to bundle with soft code minification to reduce file size
  * run `npm run bundle.prod` to bundle with soft code minification to reduce file size
  * run `npm run watch.prod` watch for changles with minification to reduce file size
----------------
## Features
* Bundling and code splitting
(via [luabundle](https://github.com/Benjamin-Dobell/luabundle))
* File watcher (via [nodemon](https://github.com/remy/nodemon))
* File final bundle size check (max: 100KB)
* Soft minification (trim all lines, remove empty lines and comment only lines)
----------------
## Caveats

* Unsaved changes in the World Editor cause it to create and run a temporary map TestMap. Sinde the path to TestMap is not known, it's not injected with lua bundle. Workaround: If you change anything in the World Editor (an asterisk appears on the World Editor window label `map.w3x*`), then you need to first SAVE and wait for change detection + compilation (~ 1 second) to test the map.
* Files not required by the main (`__root`) module or it's submodules are not included in the bundle, thus not acessible anywhere
----------------
## TODO:
* Use lua [Global Initialization](https://www.hiveworkshop.com/threads/lua-global-initialization.317099/) instead of hooks
* Fix TestMap caveat (if possible)
* Include external lua libraries
* Typescript to lua