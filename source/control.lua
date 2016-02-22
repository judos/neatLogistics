require "defines"
require "basic-lua-extensions"

require "control.neat-logistic-chest-requester"
require "control.neat-smart-inserter"
require "control.belt-sorter"

require "control.signalRequester"
require "control.signalReceiver"

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	init()
end)

function init()
	if global.neatLogistics == nil then global.neatLogistics = {} end
	local d = global.neatLogistics
	if d.beltSorter == nil then d.beltSorter = {} end
	if d.signalReceiver == nil then d.signalReceiver = {} end
	if d.signalRequester == nil then d.signalRequester = {} end
end

-- Setup and destroy --
script.on_event(defines.events.on_built_entity, function(event)
	onBuiltEntity(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	onBuiltEntity(event)
end)

function onBuiltEntity(event)
	local entity = event.created_entity
	local player = game.players[event.player_index]
	if entity.name == "neat-smart-inserter" then
		buildNeatSmartInserter(entity,player)
	elseif entity.name == "neat-logistic-chest-requester" then
		buildNeatLogisticChestRequester(entity,player)
	elseif entity.name == "belt-sorter" then
		table.insert(global.neatLogistics.beltSorter, entity)
	elseif entity.name == "signal-receiver" then
		table.insert(global.hardCrafting.signalReceiver, entity)
		entity.operable = false -- no gui needed
	elseif entity.name == "circuit-signal-requester" then
		table.insert(global.hardCrafting.signalRequester, entity)
		entity.operable = false -- no gui needed
	end
end

-- Update tick --
script.on_event(defines.events.on_tick, function(event)
	updateBeltSorter(event)
	updateSignalReceiver(event)
	updateSignalRequester(event)
end)