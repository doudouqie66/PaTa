---@class TZ_RS_C:BP_UGCBurn_Projectile_Template_C
--Edit Below--
local TZ_RS = {}

--[[
function TZ_RS:ReceiveLaunchBullet()
    TZ_RS.SuperClass.ReceiveLaunchBullet(self)
end
--]]

--[[
function TZ_RS:ReceiveOnImpact(HitResult)
    TZ_RS.SuperClass.ReceiveOnImpact(self,HitResult)
end
--]]

--[[
function TZ_RS:ReceiveOnBounce(HitResult, ImpactVelocity)
    TZ_RS.SuperClass.ReceiveOnBounce(self,HitResult, ImpactVelocity)
end
--]]

--[[
function TZ_RS:ReceivePlayExplosionEffect(ExplosionTarget)
    TZ_RS.SuperClass.ReceivePlayExplosionEffect(self,ExplosionTarget)
end
--]]

--[[
function TZ_RS:TickMovementPath(DeltaTime)
    TZ_RS.SuperClass.TickMovementPath(self,DeltaTime)
end
--]]

return TZ_RS