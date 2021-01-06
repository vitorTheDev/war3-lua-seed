local function registerTrigger()
  local trigger = CreateTrigger()
  local mapArea = GetPlayableMapRect()
  local group = GetUnitsInRectOfPlayer(mapArea, Player(1))
  local unit = FirstOfGroup(group)
  DestroyGroup(group)
  TriggerRegisterUnitEvent(trigger, unit, EVENT_UNIT_DAMAGED)
  TriggerAddAction(trigger, function()
    print('Oof!')
  end)
  return trigger
end

return registerTrigger
