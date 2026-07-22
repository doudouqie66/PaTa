---@class Aire01_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
--Edit Below--
---@class Aire01_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
local Aire01 = {}

--[[
function Aire01:ReceiveBeginPlay()
    Aire01.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Aire01:ReceiveTick(DeltaTime)
    Aire01.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Aire01:ReceiveEndPlay()
    Aire01.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Aire01:GetReplicatedProperties()
    return
end
--]]

--[[
function Aire01:GetAvailableServerRPCs()
    return
end
--]]

return Aire01
