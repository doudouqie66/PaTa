---@class BP_Projectile_Grapple_C:PESkillProjectileBase
---@field ParticleSystem UParticleSystemComponent
---@field Sphere USphereComponent
--Edit Below--
local BP_Projectile_Grapple = {}
 
--[[
function BP_Projectile_Grapple:ReceiveBeginPlay()
    BP_Projectile_Grapple.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_Projectile_Grapple:ReceiveTick(DeltaTime)
    BP_Projectile_Grapple.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_Projectile_Grapple:ReceiveEndPlay()
    BP_Projectile_Grapple.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_Projectile_Grapple:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_Projectile_Grapple:GetAvailableServerRPCs()
    return
end
--]]

return BP_Projectile_Grapple