---@class TZ_BW_C:BP_UGCSmoke_Projectile_Template_C
--Edit Below--
local TZ_BW = {}

--[[
function TZ_BW:ReceiveLaunchBullet()
    TZ_BW.SuperClass.ReceiveLaunchBullet(self)
end
--]]

--[[
function TZ_BW:ReceiveOnImpact(HitResult)
    TZ_BW.SuperClass.ReceiveOnImpact(self,HitResult)
end
--]]

--[[
function TZ_BW:ReceiveOnBounce(HitResult, ImpactVelocity)
    TZ_BW.SuperClass.ReceiveOnBounce(self,HitResult, ImpactVelocity)
end
--]]

--[[
function TZ_BW:ReceivePlayExplosionEffect(ExplosionTarget)
    TZ_BW.SuperClass.ReceivePlayExplosionEffect(self,ExplosionTarget)
end
--]]

--[[
function TZ_BW:TickMovementPath(DeltaTime)
    TZ_BW.SuperClass.TickMovementPath(self,DeltaTime)
end
--]]

return TZ_BW