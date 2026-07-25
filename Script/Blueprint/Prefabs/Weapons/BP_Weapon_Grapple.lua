---@class BP_Weapon_Grapple_C:BP_UGC_Rifle_M416_C
--Edit Below--
local BP_Weapon_Grapple = {}
 
--[[
function BP_Weapon_Grapple:ReceiveBeginPlay()
    BP_Weapon_Grapple.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_Weapon_Grapple:ReceiveTick(DeltaTime)
    BP_Weapon_Grapple.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_Weapon_Grapple:ReceiveEndPlay()
    BP_Weapon_Grapple.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_Weapon_Grapple:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_Weapon_Grapple:GetAvailableServerRPCs()
    return
end
--]]

return BP_Weapon_Grapple