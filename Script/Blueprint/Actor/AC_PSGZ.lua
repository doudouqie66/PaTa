---@class AC_PSGZ_C:AActor
---@field CustomParticleSystem UCustomParticleSystemComponent
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local AC_PSGZ = {}
 
--[[
function AC_PSGZ:ReceiveBeginPlay()
    AC_PSGZ.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function AC_PSGZ:ReceiveTick(DeltaTime)
    AC_PSGZ.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function AC_PSGZ:ReceiveEndPlay()
    AC_PSGZ.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function AC_PSGZ:GetReplicatedProperties()
    return
end
--]]

--[[
function AC_PSGZ:GetAvailableServerRPCs()
    return
end
--]]

return AC_PSGZ