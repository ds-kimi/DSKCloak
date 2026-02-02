sam.permissions.add("dskcloak", "superadmin")

sam.command.set_category("Utility")

sam.command.new("dskcloak")
    :SetPermission("dskcloak", "superadmin")
    :Help("Toggle invisibility cloak on a player")
    :AddArg("player", {optional = true, single_target = true})
    :OnExecute(function(calling_ply, targets)
        local target = targets[1]
        local wasCloaked = DSKCloak.IsCloaked(target)
        DSKCloak.SetCloakState(target, not wasCloaked, calling_ply)

        local status = DSKCloak.IsCloaked(target) and "cloaked" or "uncloaked"
        sam.player.send_message(calling_ply, "{A} " .. status .. " {T}", {
            A = calling_ply, T = {target}
        })
    end)
:End()
