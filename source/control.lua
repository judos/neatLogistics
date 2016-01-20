require "defines"
require "basic-lua-extensions"

require "control.neat-logistic-chest-requester"
require "control.neat-smart-inserter"
require "control.belt-sorter"

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
	end
end

-- Update tick --
script.on_event(defines.events.on_tick, function(event)
	updateBeltSorter(event)
end)