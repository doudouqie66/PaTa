---@class TZ_Bw_C:PESkillProjectileBase
---@field ywmox1 UStaticMeshComponent
---@field Box UBoxComponent
--Edit Below--
local TZ_Bw = {}
 
--[[
function TZ_Bw:ReceiveBeginPlay()
    TZ_Bw.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function TZ_Bw:ReceiveTick(DeltaTime)
    TZ_Bw.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function TZ_Bw:ReceiveEndPlay()
    TZ_Bw.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function TZ_Bw:GetReplicatedProperties()
    return
end
--]]

--[[
function TZ_Bw:GetAvailableServerRPCs()
    return
end
--]]

return TZ_Bw