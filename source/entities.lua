local neatRequesterChest = deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
neatRequesterChest.name = "neat-logistic-chest-requester"
neatRequesterChest.minable.result = "neat-logistic-chest-requester"
data:extend({	neatRequesterChest })

local neatSmartInserter = deepcopy(data.raw["inserter"]["smart-inserter"])
neatSmartInserter.name = "neat-smart-inserter"
neatSmartInserter.minable.result = "neat-smart-inserter"
data:extend({	neatSmartInserter })