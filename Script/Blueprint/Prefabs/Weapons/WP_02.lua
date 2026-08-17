---@class WP_02_C:BP_UGC_Pistol_DesertEagle_C
--Edit Below--
local WP_02 = {}
 
--[[
function WP_02:ReceiveBeginPlay()
    WP_02.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function WP_02:ReceiveTick(DeltaTime)
    WP_02.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function WP_02:ReceiveEndPlay()
    WP_02.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function WP_02:GetReplicatedProperties()
    return
end
--]]

--[[
function WP_02:GetAvailableServerRPCs()
    return
end
--]]

return WP_02