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

local function getPlayers(pOwner)
    local oRecipientFilter = RecipientFilter()
    oRecipientFilter:AddAllPlayers()
    oRecipientFilter:RemovePlayer(pOwner)
    return oRecipientFilter
end

local function RecursiveSetPreventTransmit(ent, filter, stopTransmitting)
    if not IsValid(ent) or not filter then return end

    ent:SetPreventTransmit(filter, stopTransmitting)
    local children = ent:GetChildren()
    for i = 1, #children do
        RecursiveSetPreventTransmit(children[i], filter, stopTransmitting)
    end
end

function DSKCloak.SetCloakState(target, cloaked, actor)
    DSKCloak.CloakedPlayers[target] = cloaked or nil

    local oRecipientFilter = getPlayers(target)
    RecursiveSetPreventTransmit(target, oRecipientFilter, cloaked)

    net.Start("dskcloak_status")
    net.WriteBool(cloaked)
    net.Send(target)

    local hookName = cloaked and "DSKCloak_PlayerCloaked" or "DSKCloak_PlayerUncloaked"
    hook.Run(hookName, target, actor)
end

function DSKCloak.IsCloaked(ply)
    return DSKCloak.CloakedPlayers[ply] or false
end

function DSKCloak.ToggleCloak(target, actor)
    DSKCloak.SetCloakState(target, not DSKCloak.IsCloaked(target), actor)
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

    local oRecipientFilter = getPlayers(owner)
    wep:SetPreventTransmit(oRecipientFilter, true)
end)

hook.Add("InitPostEntity", "DSKCloak::CAMI", function()
    if not CAMI or not CAMI.RegisterPrivilege then return end
    if SAM or ulx then return end

    CAMI.RegisterPrivilege({
        Name = "DSKCloak::Cloak",
        MinAccess = "admin"
    })
end)

hook.Add("InitPostEntity", "DSKCloak::Concommand", function()
    if SAM or ulx then return end

    local tRanks = {
        ["superadmin"] = true,
        ["admin"] = true,
    }

    local function hasAccess(ply)
        if tRanks[ply:GetUserGroup()] then return true end
        if CAMI and CAMI.PlayerHasAccess then
            return CAMI.PlayerHasAccess(ply, "DSKCloak::Cloak")
        end
        return false
    end

    local function findPlayers(sValue, pLocal)
        if sValue == "^" then return pLocal end
        if sValue == "@" then return pLocal:GetEyeTrace().Entity end

        for _, pTarget in player.Iterator() do
            local sNick = pTarget:Nick():lower()
            local sSteamID = pTarget:SteamID():lower()
            local sSteamID64 = pTarget:SteamID64():lower()
            local sSearch = sValue:lower()

            if sNick:find(sSearch) or sSteamID:find(sSearch) or sSteamID64:find(sSearch) then
                return pTarget
            end
        end
        return nil
    end

    concommand.Add("dskcloak", function(ply, _, tArgs)
        if not IsValid(ply) or not hasAccess(ply) then return end

        local sTarget = tArgs[1]
        if not sTarget then return end

        local pCloak = findPlayers(sTarget, ply)
        if not IsValid(pCloak) then
            ply:ChatPrint("[DSKCloak] Target player not found.")
            return
        end

        local bCloak = not DSKCloak.IsCloaked(pCloak)
        DSKCloak.SetCloakState(pCloak, bCloak, ply)
        ply:ChatPrint(("[DSKCloak] %s has been %scloaked."):format(pCloak:Nick(), bCloak and "" or "un"))
    end)
end)
