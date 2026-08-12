---@class AC_RankPawn_C:AActor
---@field Widget UWidgetComponent
---@field SK_NewWorld_NPC_Hong USkeletalMeshComponent
---@field DefaultSceneRoot USceneComponent
---@field Index_Rank int32
--Edit Below--
local AC_RankPawn = {}
 
--[[
function AC_RankPawn:ReceiveBeginPlay()
    AC_RankPawn.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function AC_RankPawn:ReceiveTick(DeltaTime)
    AC_RankPawn.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function AC_RankPawn:ReceiveEndPlay()
    AC_RankPawn.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function AC_RankPawn:GetReplicatedProperties()
    return
end
--]]

--[[
function AC_RankPawn:GetAvailableServerRPCs()
    return
end
--]]

return AC_RankPawn