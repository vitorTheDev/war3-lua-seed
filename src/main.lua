-- ? modules not required in main or any file required by main (__root module or submodules) are not included in the bundle
require("reporter");
require("luabundle");
require("global");
local githubTrigger = require("githubTrigger");

-- function mainPreHook()
-- end
function mainPostHook()
  githubTrigger()
end

-- function configPreHook()
-- end
-- function configPostHook()
-- end

-- ? if you don't return require, it won't be acessible outside bundle
return require
