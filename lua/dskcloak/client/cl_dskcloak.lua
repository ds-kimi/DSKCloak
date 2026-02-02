local isCloaked = false

net.Receive("dskcloak_status", function()
    isCloaked = net.ReadBool()
end)

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

hook.Add("HUDPaint", "dskcloak_indicator", function()
    if not isCloaked then return end
    DrawCloakedIndicator()
    DrawVoiceWarning()
end)
