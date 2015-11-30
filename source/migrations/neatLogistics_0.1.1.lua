for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	-- technology unlocking migration:
	if force.technologies["logistic-system"].researched then
		force.recipes["neat-smart-inserter"].enabled = true
		force.recipes["neat-logistic-chest-requester"].enabled = true
	end
end