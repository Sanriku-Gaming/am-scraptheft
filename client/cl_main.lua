local QBCore = exports['qb-core']:GetCoreObject()
local removedObj = {}

--======================================--
------------------------------------------
--               Functions              --
------------------------------------------
--======================================--
--Used for debugging tables
local function printTable(tbl)
  for key, value in pairs(tbl) do
      if type(value) == "table" then
          print(key .. " (table):")
          printTable(value)
      else
          print(key .. ":", value)
      end
  end
end

local function deleteObject(entity)
  pcall(SetEntityAsMissionEntity, entity, true, true)
  pcall(DeleteObject, entity)
  pcall(SetEntityAsNoLongerNeeded, entity)
end

--Police Notification
local function PoliceAlert(nearby)
  local pos = GetEntityCoords(PlayerPedId())
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
  local playerPed = PlayerPedId()
  local clientToken = securityToken
  local objHash = GetHashKey(scrapObj.name)
  local size = scrapObj.size
  local objCoords = GetEntityCoords(entity)
  local objModel = GetEntityModel(entity)

  QBCore.Functions.TriggerCallback('am-scraptheft:server:GetCops', function(copCount)
    if copCount >= Config.MinCops or Config.Debug then
      QBCore.Functions.TriggerCallback('am-scraptheft:server:checkInteract', function(isInteracting)
        if not isInteracting then
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
            local coords = GetEntityCoords(playerPed)
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
              if Config.DeleteObj then
                local coords = GetEntityCoords(entity)
                local object = {coords = coords, model = objHash}
                local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.1, objHash, false, false, false)
                TriggerServerEvent('am-scraptheft:server:removescrap', entity, object)
                SetEntityAsMissionEntity(obj, true, true)
                DeleteEntity(obj)
              end
              TriggerServerEvent('am-scraptheft:server:reward', scrapObj, clientToken)
              TriggerServerEvent('am-scraptheft:server:itemhealth')
              ClearPedTasks(playerPed)
            end, function()
              -- This code runs if the progress bar gets cancelled
              ClearPedTasks(playerPed)
              TriggerServerEvent('am-scraptheft:server:stopInteracting', {
                coords = objCoords,
                model = objModel
              })
          end)
        else
          QBCore.Functions.Notify('Someone is already scrapping this unit', 'error', 5000)
        end
      end, objCoords, objModel)
    else
      QBCore.Functions.Notify('Not enough cops online', 'error', 5000)
    end
  end)
end)

RegisterNetEvent('am-scraptheft:client:delete', function(object)
  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed)
  removedObj[#removedObj+1] = {coords = object.coords, model = object.model}
  local ent = GetClosestObjectOfType(object.coords.x, object.coords.y, object.coords.z, 0.1, object.model, false, false, false)
  if DoesEntityExist(ent) then
    local objectVec = vec3(object.coords.x, object.coords.y, object.coords.z)
    if #(playerPos - objectVec) <= Config.DeleteDistance then
      SetEntityAsMissionEntity(ent, 1, 1)
      DeleteObject(ent)
      SetEntityAsNoLongerNeeded(ent)
    end
  end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  if Config.DeleteObj then
    QBCore.Functions.TriggerCallback('am-scraptheft:server:GetObjects', function(incObjects)
      removedObj = incObjects
    end)
  end
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
  if Config.DeleteObj then
    local playerPed = PlayerPedId()
    while true do
      local playerPos = GetEntityCoords(playerPed)
      if Config.Debug then printTable(removedObj) end
      for i, data in ipairs(removedObj) do
        local model = data.model
        local coords = vector3(data.coords.x, data.coords.y, data.coords.z)
        local obj = GetClosestObjectOfType(coords, 0.1, model, false)
        if obj ~= 0 then
          if Config.Debug then print("Found object: ", obj, coords, model) end
          local status, err = pcall(deleteObject, obj)
          if not status then
            print("Error deleting object: ", err)
          end
        end
      end
      Wait(10000)
    end
  end
end)