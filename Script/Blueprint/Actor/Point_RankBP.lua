---@class Point_RankBP_C:AActor
---@field Arrow UArrowComponent
---@field DefaultSceneRoot USceneComponent
---@field ID_PointSpawn int32
--Edit Below--
local Point_RankBP = {}
 
--[[
function Point_RankBP:ReceiveBeginPlay()
    Point_RankBP.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Point_RankBP:ReceiveTick(DeltaTime)
    Point_RankBP.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Point_RankBP:ReceiveEndPlay()
    Point_RankBP.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Point_RankBP:GetReplicatedProperties()
    return
end
--]]

--[[
function Point_RankBP:GetAvailableServerRPCs()
    return
end
--]]

return Point_RankBP