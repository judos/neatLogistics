require "defines"
require "basic-lua-extensions"

local request_materials_for_next_seconds = 30
local produce_output_x_seconds_ahead = 30 -- e.g. gears use 0.5s -> produce 60 items for the system
local produce_output_minimal_items_amount = 5

--range of search for assembling machines
local ros = 3


script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	local player = game.players[event.player_index]
	if entity.name == "neat-smart-inserter" then
		local x = entity.position.x
		local y = entity.position.y
		-- get correct position of inventory before inserter
		if entity.direction == defines.direction.north then
			y=y-1
		elseif entity.direction == defines.direction.east then
			x=x+1
		elseif entity.direction == defines.direction.south then
			y=y+1
		elseif entity.direction == defines.direction.west then
			x=x-1
		end
		local foundEntities = entity.surface.find_entities({{x,y},{x,y}})
		for _,found in ipairs(foundEntities) do
			if found.type == "assembling-machine" and found.recipe~=nil then
				for _,product in ipairs(found.recipe.products) do
					if product.type =="item" or product.type==0 then
						local timeForRecipe = found.recipe.energy
						local itemAmount = product.amount * produce_output_x_seconds_ahead / timeForRecipe
						itemAmount = math.max(itemAmount, produce_output_minimal_items_amount)
						
						local conditionTable = { condition = {
							comparator="<",
							first_signal={name=product.name,type="item"},
							constant = itemAmount
						}}
						entity.set_circuit_condition(defines.circuitconnector.logistic,conditionTable)
						break
					end
				end
			end
		end
	end
	if entity.name == "neat-logistic-chest-requester" then
		local surface = entity.surface
		local x = entity.position.x
		local y = entity.position.y
		local assemblers = surface.find_entities_filtered{area = {{x-ros,y-ros},{x+ros,y+ros}},type="assembling-machine"}
		local filterForChest = {}
		--check all assemblers and add up ingredients to use as filter in the chest
		for _,assembler in ipairs(assemblers) do
			-- check that the assembler is really only $ros tiles away
			local dist = math.abs(assembler.position.x - x) + math.abs(assembler.position.y - y)
			if dist <= ros and assembler.recipe ~= nil then
				local items = assembler.recipe.ingredients
				for _,itemDescription in ipairs(items) do
					if itemDescription["type"]=="item" then
						local itemName = itemDescription["name"]
						if not filterForChest[itemName] then
							filterForChest[itemName] = 0
						end
						local multiplier = request_materials_for_next_seconds / assembler.recipe.energy
						filterForChest[itemName] = filterForChest[itemName] + itemDescription["amount"]*multiplier
					end
				end
			end
		end
		
		--set the filter slots on the requester chest:
		local slot = 1
		for itemName,amount in pairs(filterForChest) do
			local itemStack = {name = itemName, count = amount}
			function setRequestSlot()
				entity.set_request_slot(itemStack, slot)
			end
			local status,err = pcall( setRequestSlot )
			if err ~=nil then --catch "Passed index out of range" exception if too many items should be set as filter
				player.print("Too few filter slots for (Item: "..amount.."x "..itemName..")")
				break
			end
			slot = slot + 1
		end
	end
end
)