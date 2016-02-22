
-- Item
local beltSorter = deepcopy(data.raw["item"]["wooden-chest"])
beltSorter["name"]="belt-sorter"
beltSorter["order"]=beltSorter["order"].."z"
beltSorter["place_result"]="belt-sorter"
beltSorter.icon = "__neatLogistics__/graphics/icons/belt-sorter.png"
data:extend({	beltSorter })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "belt-sorter",
		enabled = false,
		ingredients = {
			{"smart-chest", 1},
			{"steel-plate", 10},
			{"electronic-circuit", 5}
		},
		result = "belt-sorter"
	}
})

-- Entity
local beltSorter = deepcopy(data.raw["container"]["wooden-chest"])
beltSorter.name = "belt-sorter"
beltSorter.minable.result = "belt-sorter"
beltSorter.inventory_size = 40
beltSorter.icon = "__neatLogistics__/graphics/icons/belt-sorter.png"
beltSorter.picture.filename="__neatLogistics__/graphics/entity/belt-sorter.png"
data:extend({	beltSorter })

-- Technology
addTechnologyUnlocksRecipe("circuit-network","belt-sorter")
