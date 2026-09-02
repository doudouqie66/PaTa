---@class TZ_Bw_2_C:PESkillProjectileBase
---@field ywmox1 UStaticMeshComponent
---@field Box UBoxComponent
--Edit Below--
local TZ_RS = {}
 
--[[
function TZ_RS:ReceiveBeginPlay()
    TZ_RS.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function TZ_RS:ReceiveTick(DeltaTime)
    TZ_RS.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function TZ_RS:ReceiveEndPlay()
    TZ_RS.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function TZ_RS:GetReplicatedProperties()
    return
end
--]]

--[[
function TZ_RS:GetAvailableServerRPCs()
    return
end
--]]

return TZ_RS