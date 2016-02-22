require "defines"

function updateSignalReceiver(event)
	-- update every 5 seconds
	if game.tick % 300 ~= 0 then return end
	
	for k,signalReceiver in pairs(global.neatLogistics.signalReceiver) do
		if signalReceiver.valid then
			local force = signalReceiver.force
			local logisticsSystem = force.find_logistic_network_by_position(signalReceiver.position,signalReceiver.surface)
			if logisticsSystem ~= nil then
				local stored = logisticsSystem.get_contents()
				local signal = {parameters = {}}
				local i = 1
				for k,v in pairs(stored) do
					signal.parameters[i]={signal={type = "item", name = k}, count = v, index = i}
					i = i + 1
				end
				signalReceiver.set_circuit_condition(defines.circuitconnector.red,signal)
			end
		else
			global.neatLogistics.signalReceiver[k] = nil
		end
	end
end