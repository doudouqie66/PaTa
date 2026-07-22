---@class Buff08_C:PersistEffectBuff
--Edit Below--
local Buff08 = {}

local Fly_Movement_Mode = 5 -- 飞行移动模式
local Falling_Movement_Mode = 3 -- 下落移动模式
local Fly_State_Tag = "PawnState.Movement.Flying" -- 飞行状态标签
local Fly_Max_Speed = 450 -- 飞行最大速度
 
-- buff启动条件
--[[
function Buff08:CanApply_BP(OwnerActor)
-- return true
end
--]]

--[[----------------------Buff挂载时开启飞行------------------------]]
function Buff08:OnApply_BP(OwnerActor)
    self.Original_Fly_Max_Speed = OwnerActor.CharacterMovement.MaxFlySpeed -- 原始飞行最大速度
    OwnerActor.CharacterMovement.MaxFlySpeed = Fly_Max_Speed
    if self:HasAuthority() then
        self.Has_Entered_Fly_State = UGCPersistEffectSystem.EnterDynamicState(OwnerActor, Fly_State_Tag) -- 是否成功进入飞行状态
        OwnerActor.CharacterMovement:SetMovementMode(Fly_Movement_Mode, 0)
        ugcprint("Buff08服务端开启飞行，状态结果=" .. tostring(self.Has_Entered_Fly_State) ..
            "，移动模式=" .. tostring(OwnerActor.CharacterMovement.MovementMode))
    elseif self:IsAutonomous(true) then
        local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
        if Player_Controller.MainUI_BP then
            Player_Controller.MainUI_BP:SetFlyControlsEnabled(true)
        end
    end
end

--[[----------------------Buff移除时关闭飞行------------------------]]
function Buff08:OnUnApply_BP(OwnerActor, Reason)
    OwnerActor.CharacterMovement.MaxFlySpeed = self.Original_Fly_Max_Speed
    if self:HasAuthority() then
        if self.Has_Entered_Fly_State then
            UGCPersistEffectSystem.LeaveDynamicState(OwnerActor, Fly_State_Tag)
        end
        if OwnerActor.CharacterMovement.MovementMode == Fly_Movement_Mode then
            OwnerActor.CharacterMovement:SetMovementMode(Falling_Movement_Mode, 0)
        end
    elseif self:IsAutonomous(true) then
        local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
        if Player_Controller.MainUI_BP then
            Player_Controller.MainUI_BP:SetFlyControlsEnabled(false)
        end
    end
end

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff08:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff08:OnMerge_BP(PersistEffect)

end
--]]

--[[
function Buff08:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff08:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff08:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff08:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff08:OnTrigger_BP(Delta)

end
--]]

return Buff08
