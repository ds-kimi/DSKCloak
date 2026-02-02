--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]


local isCloaked = false

local function DrawCloakedIndicator()
    local text = "[ CLOAKED ]"
    surface.SetFont("DermaLarge")
    local w = surface.GetTextSize(text)
    surface.SetTextColor(255, 50, 50, 200 + math.sin(CurTime() * 3) * 55)
    surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() - 60)
    surface.DrawText(text)
end

local function DrawVoiceWarning()
    if not LocalPlayer():IsSpeaking() then return end
    local text = "Cheaters can see you while talking!"
    surface.SetFont("DermaDefault")
    local w = surface.GetTextSize(text)
    surface.SetTextColor(255, 200, 50, 200 + math.sin(CurTime() * 5) * 55)
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
