--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]


local isCloaked = false

local cRed = Color(255, 50, 50)
local cYellow = Color(255, 200, 50)

local function enablehook()
    hook.Add("HUDPaint", "dskcloak_hudpaint", function()
        if not isCloaked then return end
        local bIsSpeaking = LocalPlayer():IsSpeaking()

        cRed.a = 200 + math.sin(CurTime() * 3) * 55
        draw.SimpleText("[ CLOAKED ]", "DermaLarge", ScrW() / 2, ScrH() - 60, cRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if bIsSpeaking then
            cYellow.a = 200 + math.sin(CurTime() * 5) * 55
            draw.SimpleText("Cheaters can see you while talking!", "DermaDefault", ScrW() * 0.01, ScrH() * 0.02, cYellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        end
    end)
end

local function disablehook()
    hook.Remove("HUDPaint", "dskcloak_hudpaint")
end

net.Receive("dskcloak_status", function()
    isCloaked = net.ReadBool()
    if isCloaked then
        enablehook()
    else
        disablehook()
    end
end)
