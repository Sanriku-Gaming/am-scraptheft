local QBCore = exports['qb-core']:GetCoreObject()
local securityToken = math.random(1,99999999)
local scrappedObj = {123456789}
local removedObj = {}
local InteractingScraps = {}

--======================================--
------------------------------------------
--                CALLBACKS             --
------------------------------------------
--======================================--
QBCore.Functions.CreateCallback('am-scraptheft:server:GetCops', function(source, cb)
	local amount = 0
  local players = QBCore.Functions.GetQBPlayers()
  for _, v in pairs(players) do
    if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
      amount += 1
    end
  end
	cb(amount)
end)

QBCore.Functions.CreateCallback('am-scraptheft:server:GetObjects', function(source, cb)
  cb(removedObj)
end)

QBCore.Functions.CreateCallback('am-scraptheft:server:checkInteract', function(source, cb, coords, model)
  local key = coords.x .. coords.y .. coords.z .. model
  if InteractingScraps[key] ~= nil then
    cb(true) 
  else
    InteractingScraps[key] = {coords = coords, model = model}
    cb(false)
  end
end)

--======================================--
------------------------------------------
--                EVENTS            --
------------------------------------------
--======================================--
RegisterNetEvent('am-scraptheft:server:removescrap', function(entity, object)
	table.insert(scrappedObj, entity)
  removedObj[#removedObj+1] = {coords = object.coords, model = object.model}
  if Config.DeleteObj then
    TriggerClientEvent('am-scraptheft:client:delete', -1, object)
  end
end)

RegisterNetEvent('am-scraptheft:server:itemhealth', function()
  local Player = QBCore.Functions.GetPlayer(source)
  if not Player then print('[ERROR] Player not found') return end
  for _, itemData in pairs(Player.PlayerData.items) do
		if itemData and (itemData.name == Config.ItemNeeded) then
			if Config.Debug then print('Item: '..itemData.name, itemData.slot, itemData.info.health) end
      if itemData.info.health == nil then
        itemData.info.health = 900
        Player.Functions.SetInventory(Player.PlayerData.items)
      elseif itemData.info.health == 100 then
        Player.Functions.RemoveItem(itemData.name, itemData.amount, itemData.slot)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[itemData.name], "remove", 1)
      else
        itemData.info.health -= 100
        Player.Functions.SetInventory(Player.PlayerData.items)
      end
      break
		end
	end
end)

RegisterNetEvent('am-scraptheft:server:checkifscrapped', function(scrapObj, entity)
	local src = source
	local isScrapped = false

	--Loop through scrapped object list, if scrapped object found return true and break
	for i=1, #scrappedObj do
		if scrappedObj[i] == entity then
			isScrapped = true
			break
		end
	end

	if isScrapped then
		TriggerClientEvent('QBCore:Notify', src, 'Thieves have stolen all of the valuable materials from this!', 'error', 5000)
	else
		TriggerClientEvent('am-scraptheft:client:steal', src, scrapObj, entity, securityToken)
	end
end)

RegisterNetEvent('am-scraptheft:server:stopInteracting', function(eventData)
  local coords = eventData.coords 
  local model = eventData.model
  local key = coords.x .. coords.y .. coords.z .. model
  InteractingScraps[key] = nil
end)

RegisterNetEvent('am-scraptheft:server:reward', function(scrapObj, clientToken)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if clientToken == securityToken then
    local minRewards = scrapObj.minRewards
    local maxRewards = scrapObj.maxRewards
    local rewardAmount = math.random(minRewards, maxRewards)
    if Config.Debug then print('Total Items: '..rewardAmount) end

    -- Give random reward items
    for i = 1, rewardAmount do
      local rewardIndex = math.random(1, #scrapObj.rewards)
      local rewardItem = scrapObj.rewards[rewardIndex]
      local rewardItemMin = rewardItem.min
      local rewardItemMax = rewardItem.max
      local rewardItemAmount = math.random(rewardItemMin, rewardItemMax)

      Player.Functions.AddItem(rewardItem.item, rewardItemAmount)
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[rewardItem.item], 'add', rewardItemAmount)

      table.remove(scrapObj.rewards, rewardIndex) -- Remove the rewarded item from the table
    end
	else
		print('^1[WARNING]^0 - ID: '..src..' just attempted to receive a reward without a valid security token, possible lua injector')
	end
end)