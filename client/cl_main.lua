local QBCore = exports['qb-core']:GetCoreObject()
local removedObj = {}

--======================================--
------------------------------------------
--               Functions              --
------------------------------------------
--======================================--
--Police Notification
local function PoliceAlert(nearby)
	local chance = nil
	local day = false
	local hours = GetClockHours()

	-- Alert Chance
	if Config.NearbyPed and nearby then
		chance = 100
	elseif Config.NearbyPed and not nearby then
		chance = 0
	else
		if hours > 6 and hours < 23 then day = true end -- Between 6 and 23
		if day then chance = Config.DayChance else chance = Day.NightChance end
	end

  if math.random(1, 100) <= chance then
    if Config.Dispatch == 'ps-dispatch' then
      exports["ps-dispatch"]:CustomAlert({
        coords = {
          x = pos.x,
          y = pos.y,
          z = pos.z
        },
        message = "Scrap Material Theft",
        dispatchCode = "000",
        priority = 2,
        description = "Scrap Material Theft",
        recipientList = 'police',
        gender = true,
        name = 'Caller: '..Config.DispatchCaller[math.random(1,#Config.DispatchCaller)]..' - '..Config.DispatchMsg[math.random(1,#Config.DispatchMsg)],
        radius = 0,
        sprite = 60,
        color = 3,
        scale = 1.0,
        length = 3,
      })
    elseif Config.Dispatch == 'cd_dispatch' then
      local data = exports['cd_dispatch']:GetPlayerInfo()
      TriggerServerEvent('cd_dispatch:AddNotification', {
          job_table = {'police'},
          coords = data.coords,
          title = '10-42 Vandalism',
          message = 'Caller: '..Config.DispatchCaller[math.random(1,#Config.DispatchCaller)]..' - '..Config.DispatchMsg[math.random(1,#Config.DispatchMsg)]..' - Location: '..data.street_1,
          flash = 0,
          unique_id = tostring(math.random(0000000,9999999)),
          blip = {
            sprite = 458,
            scale = 0.85,
            colour = 3,
            flashes = false,
            text = '911 - Vandalism',
            time = (5*60000),
            sound = 1,
          }
        }
      )
      QBCore.Functions.Notify('Looks like a local saw you stealing and called the cops!', 'primary', 5000)
    end
  end
end

--======================================--
------------------------------------------
--                Events                --
------------------------------------------
--======================================--
RegisterNetEvent('am-scraptheft:client:steal',function(scrapObj, entity, securityToken)
  local pos = GetEntityCoords(PlayerId())
  local clientToken = securityToken
  local objHash = GetHashKey(scrapObj.name)
  local size = scrapObj.size

  QBCore.Functions.TriggerCallback('am-scraptheft:server:GetCops', function(copCount)
    if copCount >= Config.MinCops or Config.Debug then
      if Config.NearbyPed then
        local PlayerPeds = {}
        if next(PlayerPeds) == nil then
          for _, activePlayer in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(activePlayer)
            if not IsPedDeadOrDying(ped) then
              PlayerPeds[#PlayerPeds + 1] = ped
            end
          end
        end
        local coords = GetEntityCoords(PlayerPedId())
        local closestPed, distance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
        if Config.Debug then print(closestPed, distance) end
        if closestPed ~= nil and distance <= Config.PedDistance then
          PoliceAlert(true)
        else
          PoliceAlert(false)
        end
      else
        PoliceAlert(false)
      end

      --Progress Bar
      QBCore.Functions.Progressbar('stealingscraps', 'Stealing Scraps', Config.ScrapTime[size] * 1000, false, true,
        {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true
        },
        {
          task = 'WORLD_HUMAN_WELDING',
        },
        {}, {}, function()
          -- This code runs if the progress bar completes successfully
          local coords = GetEntityCoords(entity)
          local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.1, objHash, false, false, false)
          SetEntityAsMissionEntity(obj, true, true)
          DeleteEntity(obj)
          local object = {coords = coords, model = objHash}
          TriggerServerEvent('am-scraptheft:server:removescrap', entity, object)
          TriggerServerEvent('am-scraptheft:server:reward', scrapObj, clientToken)
          TriggerServerEvent('am-scraptheft:server:itemhealth')
          ClearPedTasks(PlayerPedId())
        end, function()
          -- This code runs if the progress bar gets cancelled
          ClearPedTasks(PlayerPedId())
      end)
    else
      QBCore.Functions.Notify('Not enough cops online', 'error', 5000)
    end
  end)
end)

RegisterNetEvent('am-scraptheft:client:delete', function(object)
  removedObj[#removedObj+1] = {coords = object.coords, model = object.model}
  local ent = GetClosestObjectOfType(object.coords.x, object.coords.y, object.coords.z, 0.1, object.model, false, false, false)
  if DoesEntityExist(ent) then
      SetEntityAsMissionEntity(ent, 1, 1)
      DeleteObject(ent)
      SetEntityAsNoLongerNeeded(ent)
  end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  QBCore.Functions.TriggerCallback('am-scraptheft:server:GetObjects', function(incObjects)
    removedObj = incObjects
  end)
end)

--======================================--
------------------------------------------
--                Threads             --
------------------------------------------
--======================================--
--Target Exports: Get all the objects from the config and add them to qb-target
CreateThread(function()
  for i=1, #Config.ScrapObjects do
    local scrapObj = Config.ScrapObjects[i]
    exports['qb-target']:AddTargetModel(scrapObj.name, {
      options = {
        {
          icon = 'fa fa-print',
          label = 'Steal Scraps',
          item = Config.ItemNeeded,
          action = function(entity)
            TriggerServerEvent('am-scraptheft:server:checkifscrapped', scrapObj, entity)
          end
        },
      },
      distance = 1.5,
    })
  end
end)

CreateThread(function()
  while true do
    for k = 1, #removedObj, 1 do
      v = removedObj[k]
      local ent = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 0.1, v.model, false, false, false)
      if DoesEntityExist(ent) then
          SetEntityAsMissionEntity(ent, 1, 1)
          DeleteObject(ent)
          SetEntityAsNoLongerNeeded(ent)
          if Config.Debug then print('Entity Deleted:', ent, v.coords, v.model) end
      end
    end
    Wait(5000)
  end
end)