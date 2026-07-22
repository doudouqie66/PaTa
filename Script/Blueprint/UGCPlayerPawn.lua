---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
-- Edit Below--
---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
-- Edit Below--
local UGCPlayerPawn = {}

--[[----------------------初始化玩家Pawn------------------------]]
function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
    self:TestLua()

    if not UGCGameSystem.IsServer() and UGCGameSystem.GetLocalPlayerPawn() == self then
        self.Local_Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(self) -- 本地玩家控制器
        self.Move_Right_Input_Handle = UGCInputSystem.BindInputMapping(self, "Input.Move.MoveRight",
            ETriggerEvent.Triggered, self.ReverseMoveRightInput) -- 左右移动输入绑定
        self.Move_Forward_Input_Handle = UGCInputSystem.BindInputMapping(self, "Input.Move.MoveForward",
            ETriggerEvent.Triggered, self.ReverseMoveForwardInput) -- 前后移动输入绑定
        self:SetReverseMoveEnabled(false)
    end
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

--[[----------------------设置反向移动状态------------------------]]
function UGCPlayerPawn:SetReverseMoveEnabled(Is_Enabled)
    self.Is_Reverse_Move_Enabled = Is_Enabled -- 是否启用反向移动
    UGCInputSystem.SetBindingConsumeInput(self, self.Move_Right_Input_Handle, Is_Enabled)
    UGCInputSystem.SetBindingConsumeInput(self, self.Move_Forward_Input_Handle, Is_Enabled)
end

--[[----------------------反转左右移动输入------------------------]]
function UGCPlayerPawn:ReverseMoveRightInput(Input_Value)
    if not self.Is_Reverse_Move_Enabled then
        return
    end

    local Control_Rotation = self.Local_Player_Controller:GetControlRotation() -- 镜头控制旋转
    local Move_Rotation = KismetMathLibrary.MakeRotator(0, 0, Control_Rotation.Yaw) -- 水平移动旋转
    local Move_Direction = KismetMathLibrary.GetRightVector(Move_Rotation) -- 镜头右方向
    self:AddMovementInput(Move_Direction, -Input_Value, false)
end

--[[----------------------反转前后移动输入------------------------]]
function UGCPlayerPawn:ReverseMoveForwardInput(Input_Value)
    if not self.Is_Reverse_Move_Enabled then
        return
    end

    local Control_Rotation = self.Local_Player_Controller:GetControlRotation() -- 镜头控制旋转
    local Move_Rotation = KismetMathLibrary.MakeRotator(0, 0, Control_Rotation.Yaw) -- 水平移动旋转
    local Move_Direction = KismetMathLibrary.GetForwardVector(Move_Rotation) -- 镜头前方向
    self:AddMovementInput(Move_Direction, -Input_Value, false)
end
return UGCPlayerPawn
