function ulx.dskcloak(calling_ply, target_plys)
    for i = 1, #target_plys do
        local target = target_plys[i]
        local wasCloaked = DSKCloak.IsCloaked(target)
        DSKCloak.SetCloakState(target, not wasCloaked, calling_ply)
    end

    local cloakedList, uncloakedList = {}, {}
    for i = 1, #target_plys do
        local target = target_plys[i]
        if DSKCloak.IsCloaked(target) then
            table.insert(cloakedList, target)
        else
            table.insert(uncloakedList, target)
        end
    end

    if #cloakedList > 0 then
        ulx.fancyLogAdmin(calling_ply, "#A cloaked #T", cloakedList)
    end
    if #uncloakedList > 0 then
        ulx.fancyLogAdmin(calling_ply, "#A uncloaked #T", uncloakedList)
    end
end

local dskcloak = ulx.command("Utility", "ulx dskcloak", ulx.dskcloak, "!cloak")
dskcloak:addParam{type = ULib.cmds.PlayersArg}
dskcloak:defaultAccess(ULib.ACCESS_SUPERADMIN)
dskcloak:help("Toggle invisibility cloak on target(s).")
