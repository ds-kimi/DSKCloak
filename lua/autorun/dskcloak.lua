if SERVER then
    include("dskcloak/server/sv_dskcloak.lua")
    AddCSLuaFile("dskcloak/client/cl_dskcloak.lua")
else
    include("dskcloak/client/cl_dskcloak.lua")
end