local function registerTrigger()
  local trigger = CreateTrigger()
  TriggerAddAction(trigger, function()
    TriggerSleepAction(5.00)
    local github = require("github")
    github()
    TriggerSleepAction(1.00)
    local luabundle = require("luabundle")
    luabundle()
    TriggerSleepAction(1.00)
    local luamin = require("luamin")
    luamin()
  end)
  TriggerExecute(trigger)
  return trigger
end

return registerTrigger
