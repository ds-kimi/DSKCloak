--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]

DSKCloak = DSKCloak or {}
local isCloaked = false

local cloakedColor = Color(50, 122, 255, 200)
local voiceWarningColor = Color(255, 200, 50, 200)

local tLanguage = {
    ["fr"] = {
        CLOAKED_INDICATOR = "[ INVISIBLE ]",
        VOICE_WARNING = "Les tricheurs peuvent vous voir en parlant !"
    },
    ["en"] = {
        CLOAKED_INDICATOR = "[ CLOAKED ]",
        VOICE_WARNING = "Cheaters can see you while talking!"
    }
}

local function getLanguage()
    local sLang = GetConVar("gmod_language"):GetString():lower()
    return tLanguage[sLang] and sLang or "en"
end

local function L(key)
    return tLanguage[getLanguage()][key]
end

function DSKCloak.IsCloaked()
    return isCloaked
end

local function DrawCloakedIndicator()
    local text = L("CLOAKED_INDICATOR")
    surface.SetFont("DermaLarge")
    local w = surface.GetTextSize(text)
    cloakedColor.a = 200 + math.sin(CurTime() * 3) * 55
    surface.SetTextColor(cloakedColor)
    surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() - 60)
    surface.DrawText(text)
end

local function DrawVoiceWarning()
    if not LocalPlayer():IsSpeaking() then return end
    local text = L("VOICE_WARNING")
    surface.SetFont("DermaDefault")
    local w = surface.GetTextSize(text)
    voiceWarningColor.a = 200 + math.sin(CurTime() * 5) * 55
    surface.SetTextColor(voiceWarningColor)
    surface.SetTextPos(ScrW() - w - ScrW() * 0.01, ScrH() * 0.02)
    surface.DrawText(text)
end

local overlay

local function UpdateCloakOverlay()
    if isCloaked and not IsValid(overlay) then
        overlay = vgui.Create("DPanel")
        overlay:SetPos(0, 0)
        overlay:SetSize(ScrW(), ScrH())
        overlay:SetMouseInputEnabled(false)
        overlay:SetKeyboardInputEnabled(false)
        overlay.Paint = function()
            DrawCloakedIndicator()
            DrawVoiceWarning()
        end
    elseif not isCloaked and IsValid(overlay) then
        overlay:Remove()
        overlay = nil
    end
end

net.Receive("dskcloak_status", function()
    isCloaked = net.ReadBool()
    UpdateCloakOverlay()
end)
