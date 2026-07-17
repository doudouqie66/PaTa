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

    if self:HasAuthority() then
        UGCAttributeSystem.SetGameAttributeValue(self, "UGCGeneralMoveSpeedScale", 6)
        -- 关闭攀爬和滑铲
        UGCPlayerPawnSystem.DisabledPawnState(self, EPawnState.Vault, true)
        UGCPlayerPawnSystem.DisabledPawnState(self, EPawnState.Shoveling, true)
    end

end

--[[----------------------返回复制属性------------------------]]
function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn
