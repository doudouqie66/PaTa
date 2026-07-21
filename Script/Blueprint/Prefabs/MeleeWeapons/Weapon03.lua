---@class Weapon03_C:BP_UGC_MeleeWeap_TangDao_C
--Edit Below--
local Weapon03 = {}
 
--[[
function Weapon03:ReceiveBeginPlay()
    Weapon03.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Weapon03:ReceiveTick(DeltaTime)
    Weapon03.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Weapon03:ReceiveEndPlay()
    Weapon03.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Weapon03:GetReplicatedProperties()
    return
end
--]]

--[[
function Weapon03:GetAvailableServerRPCs()
    return
end
--]]

return Weapon03