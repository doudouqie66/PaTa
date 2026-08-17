---@class WP_01_C:BP_UGC_Other_RPG7_C
--Edit Below--
local WP_01 = {}
 
--[[
function WP_01:ReceiveBeginPlay()
    WP_01.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function WP_01:ReceiveTick(DeltaTime)
    WP_01.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function WP_01:ReceiveEndPlay()
    WP_01.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function WP_01:GetReplicatedProperties()
    return
end
--]]

--[[
function WP_01:GetAvailableServerRPCs()
    return
end
--]]

return WP_01