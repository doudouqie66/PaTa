---@class EntertTower_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local EntertTower_Colli = {}
 
--[[
function EntertTower_Colli:ReceiveBeginPlay()
    EntertTower_Colli.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function EntertTower_Colli:ReceiveTick(DeltaTime)
    EntertTower_Colli.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function EntertTower_Colli:ReceiveEndPlay()
    EntertTower_Colli.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function EntertTower_Colli:GetReplicatedProperties()
    return
end
--]]

--[[
function EntertTower_Colli:GetAvailableServerRPCs()
    return
end
--]]

return EntertTower_Colli