
-- Item
local neatRequesterChest = deepcopy(data.raw["item"]["logistic-chest-requester"])
neatRequesterChest["name"]="neat-logistic-chest-requester"
neatRequesterChest["order"]=neatRequesterChest["order"].."z"
neatRequesterChest["place_result"]="neat-logistic-chest-requester"
data:extend({	neatRequesterChest })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "neat-logistic-chest-requester",
		enabled = false,
		ingredients = {
			{"logistic-chest-requester", 1},
			{"advanced-circuit", 1}
		},
		result = "neat-logistic-chest-requester"
	}
})

-- Entity
local neatRequesterChest = deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
neatRequesterChest.name = "neat-logistic-chest-requester"
neatRequesterChest.minable.result = "neat-logistic-chest-requester"
data:extend({	neatRequesterChest })

-- Technology
addTechnologyUnlocksRecipe("logistic-system","neat-logistic-chest-requester")
