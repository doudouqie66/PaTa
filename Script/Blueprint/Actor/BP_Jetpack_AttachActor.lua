---@class BP_Jetpack_AttachActor_C:AActor
---@field CustomParticleSystem UCustomParticleSystemComponent
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local BP_Jetpack_AttachActor = {}
 
--[[
function BP_Jetpack_AttachActor:ReceiveBeginPlay()
    BP_Jetpack_AttachActor.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_Jetpack_AttachActor:ReceiveTick(DeltaTime)
    BP_Jetpack_AttachActor.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_Jetpack_AttachActor:ReceiveEndPlay()
    BP_Jetpack_AttachActor.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_Jetpack_AttachActor:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_Jetpack_AttachActor:GetAvailableServerRPCs()
    return
end
--]]

return BP_Jetpack_AttachActor