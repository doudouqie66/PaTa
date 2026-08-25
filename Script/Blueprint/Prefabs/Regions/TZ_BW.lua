---@class TZ_BW_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field ParticleSystem UParticleSystemComponent
--Edit Below--
local TZ_BW = {}
 
--[[
function TZ_BW:ReceiveBeginPlay()
    TZ_BW.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function TZ_BW:ReceiveTick(DeltaTime)
    TZ_BW.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function TZ_BW:ReceiveEndPlay()
    TZ_BW.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function TZ_BW:GetReplicatedProperties()
    return
end
--]]

--[[
function TZ_BW:GetAvailableServerRPCs()
    return
end
--]]

return TZ_BW