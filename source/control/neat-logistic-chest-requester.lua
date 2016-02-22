local request_material_minimal_items_amount = 5
local request_material_maximal_items_amount = 200
local request_materials_for_next_seconds = 30
-- requester chest search fields
local requester_search = {{2,0},{3,0},{0,2},{0,3},{-2,0},{-3,0},{0,-2},{0,-3}}


function buildNeatLogisticChestRequester(entity,player)
	local surface = entity.surface
	local x = entity.position.x
	local y = entity.position.y
	local assemblers = {}
	for _,coordinatePair in ipairs(requester_search) do
		local position = {x + coordinatePair[1], y + coordinatePair[2]}
		local entities = surface.find_entities_filtered{area = {position,position},type="assembling-machine"}
		if entities ~= nil then
			for _,entity in ipairs(entities) do
				debug(entity.position.x.."|"..entity.position.y)
				table.insert(assemblers,entity)
			end
		end
	end
	local filterForChest = {}
	--check all assemblers and add up ingredients to use as filter in the chest
	for _,assembler in ipairs(assemblers) do
		if assembler.recipe ~= nil then
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
		amount = math.max(amount,request_material_minimal_items_amount)
		amount = math.min(amount,request_material_maximal_items_amount)
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