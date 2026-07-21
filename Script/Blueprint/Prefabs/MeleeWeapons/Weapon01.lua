---@class Weapon01_C:BP_UGC_MeleeWeap_Pan_C
--Edit Below--
local Weapon01 = {}
 
--[[
function Weapon01:ReceiveBeginPlay()
    Weapon01.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Weapon01:ReceiveTick(DeltaTime)
    Weapon01.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Weapon01:ReceiveEndPlay()
    Weapon01.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Weapon01:GetReplicatedProperties()
    return
end
--]]

--[[
function Weapon01:GetAvailableServerRPCs()
    return
end
--]]

return Weapon01