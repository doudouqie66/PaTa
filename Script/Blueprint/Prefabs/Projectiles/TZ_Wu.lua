---@class TZ_Wu_C:PESkillProjectileBase
---@field ywmox1 UStaticMeshComponent
---@field Box UBoxComponent
--Edit Below--
local TZ_Wu = {}
 
--[[
function TZ_Wu:ReceiveBeginPlay()
    TZ_Wu.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function TZ_Wu:ReceiveTick(DeltaTime)
    TZ_Wu.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function TZ_Wu:ReceiveEndPlay()
    TZ_Wu.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function TZ_Wu:GetReplicatedProperties()
    return
end
--]]

--[[
function TZ_Wu:GetAvailableServerRPCs()
    return
end
--]]

return TZ_Wu