require "defines"
require "basic-lua-extensions"

require "control.neat-logistic-chest-requester"
require "control.neat-smart-inserter"


script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	local player = game.players[event.player_index]
	if entity.name == "neat-smart-inserter" then
		buildNeatSmartInserter(entity,player)
	elseif entity.name == "neat-logistic-chest-requester" then
		buildNeatLogisticChestRequester(entity,player)
	end
end
)