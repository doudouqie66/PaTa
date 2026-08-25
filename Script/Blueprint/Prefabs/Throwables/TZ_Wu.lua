---@class TZ_Wu_C:BP_UGCSmoke_Projectile_Template_C
--Edit Below--
local TZ_Wu = {}

--[[
function TZ_Wu:ReceiveLaunchBullet()
    TZ_Wu.SuperClass.ReceiveLaunchBullet(self)
end
--]]

--[[
function TZ_Wu:ReceiveOnImpact(HitResult)
    TZ_Wu.SuperClass.ReceiveOnImpact(self,HitResult)
end
--]]

--[[
function TZ_Wu:ReceiveOnBounce(HitResult, ImpactVelocity)
    TZ_Wu.SuperClass.ReceiveOnBounce(self,HitResult, ImpactVelocity)
end
--]]

--[[
function TZ_Wu:ReceivePlayExplosionEffect(ExplosionTarget)
    TZ_Wu.SuperClass.ReceivePlayExplosionEffect(self,ExplosionTarget)
end
--]]

--[[
function TZ_Wu:TickMovementPath(DeltaTime)
    TZ_Wu.SuperClass.TickMovementPath(self,DeltaTime)
end
--]]

return TZ_Wu