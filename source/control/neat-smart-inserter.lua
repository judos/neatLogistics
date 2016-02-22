local produce_output_x_seconds_ahead = 30 -- e.g. gears use 0.5s -> produce 60 items for the system
local produce_output_minimal_items_amount = 5

function buildNeatSmartInserter(entity,player)
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