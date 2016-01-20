-- checks whether relative position is a neighbor of the belt-sorter
local function isValidBeltDirection(x,y)
	return math.abs(x)+math.abs(y) == 1
end

-- returns the direction on which side the belt is located relative to x,y, assuming they are neighbors
local function beltSide(x,y,belt)
	local dx = belt.position.x-x
	local dy = belt.position.y-y
	if dx==-1 then
		return defines.direction.west
	elseif dx==1 then
		return defines.direction.east
	elseif dy==-1 then
		return defines.direction.north
	elseif dy==1 then
		return defines.direction.south
	end
end

local function isInputBelt(x,y,belt)
	local direction = belt.direction
	local side = beltSide(x,y,belt)
	debug("direction "..direction.." side "..side)
	return side == (direction + 4)%8 -- must be 180°
end

function updateBeltSorter(event)
	-- update every 10 ticks
	if game.tick % 10 ~= 0 then return end
	
	for k,beltSorter in pairs(global.neatLogistics.beltSorter) do
		if not beltSorter.valid then
			global.neatLogistics.beltSorter[k] = nil
		else
			local surface = beltSorter.surface
			local x = beltSorter.position.x
			local y = beltSorter.position.y
			
			-- search for input / output belts
			local beltCandidates = surface.find_entities_filtered{area = {{x-1, y-1}, {x+1, y+1}}, type= "transport-belt"}
			local input = {}
			local output = {}
			for _,belt in ipairs(beltCandidates) do
				if isValidBeltDirection(belt.position.x-x,belt.position.y-y) then
					--debug("found belt at: "..(belt.position.x-x) .." "..(belt.position.y-y))
					if isInputBelt(x,y,belt) then
						table.insert(input,belt)
					else
						table.insert(output,belt)
					end
				end
			end
			
			--debug("input belts: "..#input)
			--debug(output)
			
			-- Build filter table from inventory
			local filter = {} -- direction = {itemName, ..} filter
			local slotIndexToDirection = {[0]=defines.direction.north, [1]=defines.direction.west,
																		[2]=defines.direction.east, [3]=defines.direction.south}
			local inventory = beltSorter.get_inventory(defines.inventory.chest)
			for i = 1,40 do
				if inventory[i]~=nil and inventory[i].valid_for_read then
					local slotRow = slotIndexToDirection[math.floor((i-1)/10)]
					if filter[slotRow] == nil then filter[slotRow]={} end
					table.insert(filter[slotRow],inventory[i].name)
				end
			end
			
			-- Distribute items on output belts
			for _,belt in pairs(output) do
				local beltSide = beltSide(x,y,belt)
				for line=1,2 do
					local beltLine = belt.get_transport_line(line)
					if beltLine.can_insert_at_back() and filter[beltSide]~=nil then
						local canInsert = true
						for _,itemName in pairs(filter[beltSide]) do
							debug("checking item: "..itemName)
							
							for _,inputBelt in pairs(input) do
								for line=1,2 do
									local beltLineInput = inputBelt.get_transport_line(line)
									local content = beltLineInput.get_contents()
									if content[itemName]~=nil then
										local itemStack = {name=itemName,count=1}
										if beltLineInput.remove_item(itemStack) then
											beltLine.insert_at_back(itemStack)
											canInsert = beltLine.can_insert_at_back()
										end
									end
									if not canInsert then break end
								end
								if not canInsert then break end
							end
							if not canInsert then break end
						end
					end
				end
			end
		end
	end
end
