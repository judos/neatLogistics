local neatRequesterChest = deepcopy(data.raw["item"]["logistic-chest-requester"])
neatRequesterChest["name"]="neat-logistic-chest-requester"
neatRequesterChest["order"]=neatRequesterChest["order"].."z"
neatRequesterChest["place_result"]="neat-logistic-chest-requester"
data:extend({	neatRequesterChest })

local neatSmartInserter = deepcopy(data.raw["item"]["smart-inserter"])
neatSmartInserter["name"]="neat-smart-inserter"
neatSmartInserter["order"]=neatSmartInserter["order"].."z"
neatSmartInserter["place_result"]="neat-smart-inserter"
data:extend({	neatSmartInserter })