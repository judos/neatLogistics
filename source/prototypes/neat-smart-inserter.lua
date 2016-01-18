
-- Item
local neatSmartInserter = deepcopy(data.raw["item"]["smart-inserter"])
neatSmartInserter["name"]="neat-smart-inserter"
neatSmartInserter["order"]=neatSmartInserter["order"].."z"
neatSmartInserter["place_result"]="neat-smart-inserter"
data:extend({	neatSmartInserter })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "neat-smart-inserter",
		enabled = false,
		ingredients = {
			{"smart-inserter", 1},
			{"advanced-circuit", 1}
		},
		result = "neat-smart-inserter"
	}
})

-- Entity
local neatSmartInserter = deepcopy(data.raw["inserter"]["smart-inserter"])
neatSmartInserter.name = "neat-smart-inserter"
neatSmartInserter.minable.result = "neat-smart-inserter"
data:extend({	neatSmartInserter })

-- Technology
addTechnologyUnlocksRecipe("logistic-system","neat-smart-inserter")
