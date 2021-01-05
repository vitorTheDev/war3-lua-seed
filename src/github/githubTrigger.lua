local function registerTrigger()
  local trigger = CreateTrigger()
  TriggerAddAction(trigger, function()
    TriggerSleepAction(5.00)
    local github = require("github")
    github()
    TriggerSleepAction(1.00)
    local luabundle = require("luabundle")
    luabundle()
  end)
  ConditionalTriggerExecute(trigger)
  return trigger
end

return registerTrigger
