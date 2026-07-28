---@class BP_MoTan_AttachActor_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local BP_MoTan_AttachActor = {}
 
--[[
function BP_MoTan_AttachActor:ReceiveBeginPlay()
    BP_MoTan_AttachActor.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_MoTan_AttachActor:ReceiveTick(DeltaTime)
    BP_MoTan_AttachActor.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_MoTan_AttachActor:ReceiveEndPlay()
    BP_MoTan_AttachActor.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_MoTan_AttachActor:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_MoTan_AttachActor:GetAvailableServerRPCs()
    return
end
--]]

return BP_MoTan_AttachActor