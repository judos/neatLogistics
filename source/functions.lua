-- adds a recipe which is unlocked when the given technology is researched
function addTechnologyUnlocksRecipe(technologyName, recipeName)
	table.insert(data.raw["technology"][technologyName].effects,
		{ type = "unlock-recipe", recipe = recipeName })
end