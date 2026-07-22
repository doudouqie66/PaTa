---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
-- Edit Below--
---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
-- Edit Below--
local UGCPlayerPawn = {}

--[[----------------------初始化玩家Pawn------------------------]]
function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
    self:TestLua()

end
--[[--------------------测试代码--------------------------]] --

--[[----------------------初始化测试属性------------------------]]
function UGCPlayerPawn:TestLua()

    --[[--------------------开启滑铲--------------------------]] --
    -- self.bIsOpenShovelAbility = true

    -- if self:HasAuthority() then
    --     UGCAttributeSystem.SetGameAttributeValue(self, "UGCGeneralMoveSpeedScale", 6)
    -- end

end

--[[----------------------返回复制属性------------------------]]
function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn
