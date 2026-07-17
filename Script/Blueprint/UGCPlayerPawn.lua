local UGCPlayerPawn = {}

function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
    --[[--------------------测试用加速度--------------------------]] --

    -- local MoveComp = self:GetMovementComponent()
    -- if MoveComp then
    --     MoveComp.GravityScale = 0
    -- end

    if self:HasAuthority() then
        UGCAttributeSystem.SetGameAttributeValue(self, "UGCGeneralMoveSpeedScale", 6)
    end
end

--[[
function UGCPlayerPawn:ReceiveTick(DeltaTime)
    UGCPlayerPawn.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function UGCPlayerPawn:ReceiveEndPlay()
    UGCPlayerPawn.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function UGCPlayerPawn:GetAvailableServerRPCs()
    return
end
--]]

function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn
