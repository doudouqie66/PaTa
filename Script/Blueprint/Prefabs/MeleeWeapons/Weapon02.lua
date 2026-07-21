---@class Weapon02_C:BP_UGC_WEP_BoxingGloves_C
--Edit Below--
local Weapon02 = {}
 
--[[
function Weapon02:ReceiveBeginPlay()
    Weapon02.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Weapon02:ReceiveTick(DeltaTime)
    Weapon02.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Weapon02:ReceiveEndPlay()
    Weapon02.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Weapon02:GetReplicatedProperties()
    return
end
--]]

--[[
function Weapon02:GetAvailableServerRPCs()
    return
end
--]]

return Weapon02