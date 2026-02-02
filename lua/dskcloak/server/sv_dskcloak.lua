--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]

util.AddNetworkString("dskcloak_status")

DSKCloak = DSKCloak or {}
DSKCloak.CloakedPlayers = DSKCloak.CloakedPlayers or {}

local function RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent == ply or not IsValid(ent) or not IsValid(ply) then return end

    ent:SetPreventTransmit(ply, stopTransmitting)
    local children = ent:GetChildren()
    for i = 1, #children do
        RecursiveSetPreventTransmit(children[i], ply, stopTransmitting)
    end
end

function DSKCloak.SetCloakState(target, cloaked, actor)
    DSKCloak.CloakedPlayers[target] = cloaked or nil

    for _, ply in player.Iterator() do
        if ply ~= target then
            RecursiveSetPreventTransmit(target, ply, cloaked)
        end
    end

    net.Start("dskcloak_status")
    net.WriteBool(cloaked)
    net.Send(target)

    local hookName = cloaked and "DSKCloak_PlayerCloaked" or "DSKCloak_PlayerUncloaked"
    hook.Run(hookName, target, actor)
end

function DSKCloak.IsCloaked(ply)
    return DSKCloak.CloakedPlayers[ply] or false
end

hook.Add("PlayerInitialSpawn", "dskcloak_hide_from_new", function(newPly)
    timer.Simple(1, function()
        if not IsValid(newPly) then return end
        for cloaked, _ in pairs(DSKCloak.CloakedPlayers) do
            if IsValid(cloaked) then
                RecursiveSetPreventTransmit(cloaked, newPly, true)
            end
        end
    end)
end)

hook.Add("PlayerDisconnected", "dskcloak_cleanup", function(ply)
    DSKCloak.CloakedPlayers[ply] = nil
end)

hook.Add("WeaponEquip", "dskcloak_hide_new_weapon", function(wep, owner)
    if not DSKCloak.CloakedPlayers[owner] then return end

    for _, ply in player.Iterator() do
        if ply ~= owner then
            wep:SetPreventTransmit(ply, true)
        end
    end
end)
