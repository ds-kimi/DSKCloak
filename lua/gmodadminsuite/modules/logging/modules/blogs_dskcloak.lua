--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DSKCloak"
MODULE.Name = "Cloaked Players"
MODULE.Colour = Color(255, 0, 0)

MODULE:Setup(function()
	MODULE:Hook("DSKCloak_PlayerCloaked", "cloaked", function(target, actor)
		if actor then
			MODULE:Log("{1} cloaked {2}", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(target))
		else
			MODULE:Log("{1} became cloaked", GAS.Logging:FormatPlayer(target))
		end
	end)

	MODULE:Hook("DSKCloak_PlayerUncloaked", "uncloaked", function(target, actor)
		if actor then
			MODULE:Log("{1} uncloaked {2}", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(target))
		else
			MODULE:Log("{1} became visible", GAS.Logging:FormatPlayer(target))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)