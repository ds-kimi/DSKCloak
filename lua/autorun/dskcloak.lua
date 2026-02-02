--[[
     _           _    _           _
  __| |___      | | _(_)_ __ ___ (_)
 / _` / __|_____| |/ / | '_ ` _ \| |
| (_| \__ \_____|   <| | | | | | | |
 \__,_|___/     |_|\_\_|_| |_| |_|_|
                                     --]]


if SERVER then
    include("dskcloak/server/sv_dskcloak.lua")
    AddCSLuaFile("dskcloak/client/cl_dskcloak.lua")
else
    include("dskcloak/client/cl_dskcloak.lua")
end