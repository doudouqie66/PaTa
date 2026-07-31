---@class Reward_Colli_C:AActor
---@field Widget UWidgetComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local L_Enum = UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')
local L_GloTools = UGCGameSystem.UGCRequire('Script.L_Com.L_GloTools')
local Reward_Colli = {
    Reward_Wait_Time = 200, -- 礼包每次领取后的等待时间
    Reward_Drop_ID = 3 -- 礼包使用的掉落表编号
}

--[[----------------------初始化礼包碰撞与计时------------------------]]
function Reward_Colli:ReceiveBeginPlay()
    Reward_Colli.SuperClass.ReceiveBeginPlay(self)
    self:StartRewardCountdown(self.Reward_Wait_Time)
    if not self:HasAuthority() then
        return
    end

    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    self:StartRewardTimer(true)
end

--[[----------------------清理礼包计时器------------------------]]
function Reward_Colli:ReceiveEndPlay()
    if self.Reward_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Reward_Timer)
        self.Reward_Timer = nil
    end
    if self.Reward_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Reward_Countdown_Timer)
        self.Reward_Countdown_Timer = nil
    end
    Reward_Colli.SuperClass.ReceiveEndPlay(self)
end

--[[----------------------初始化编辑器生成属性------------------------]]
function Reward_Colli:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
end

--[[----------------------开始礼包等待计时------------------------]]
function Reward_Colli:StartRewardTimer(Is_Begin_Play)
    self.Reward_Is_Available = false
    local Game_State = UGCGameSystem.GameState -- 当前游戏状态
    Game_State.Reward_End_Time = Game_State:GetServerWorldTimeSeconds() + self.Reward_Wait_Time
    self.Reward_Timer = UGCTimerUtility.CreateLuaTimer(self.Reward_Wait_Time, function()
        self.Reward_Timer = nil
        self.Reward_Is_Available = true
    end, false)

    if not Is_Begin_Play then
        UnrealNetwork.CallUnrealRPC_Multicast(self, "StartRewardCountdown", self.Reward_Wait_Time)
    end
end

--[[----------------------刷新礼包等待倒计时------------------------]]
function Reward_Colli:StartRewardCountdown(Countdown_Seconds)
    if self.Reward_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Reward_Countdown_Timer)
        self.Reward_Countdown_Timer = nil
    end

    local Reward_Countdown_UI = self.Widget:GetUserWidgetObject() -- 礼包倒计时界面实例
    if not Reward_Countdown_UI then
        return
    end

    local Game_State = UGCGameSystem.GameState -- 当前游戏状态
    self.Reward_Remaining_Seconds = Countdown_Seconds -- 礼包剩余等待秒数
    if Game_State.Reward_End_Time > 0 then
        self.Reward_Remaining_Seconds = math.max(0,
            math.ceil(Game_State.Reward_End_Time - Game_State:GetServerWorldTimeSeconds()))
    end
    if self.Reward_Remaining_Seconds > 0 then
        Reward_Countdown_UI.TextBlock_3:SetText(
            string.format("距离奖励还有%d秒", self.Reward_Remaining_Seconds))
    else
        Reward_Countdown_UI.TextBlock_3:SetText("可以领奖")
    end
    self.Widget:RequestRedraw()

    self.Reward_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        local Previous_Remaining_Seconds = self.Reward_Remaining_Seconds -- 刷新前的剩余秒数
        if Game_State.Reward_End_Time > 0 then
            self.Reward_Remaining_Seconds = math.max(0,
                math.ceil(Game_State.Reward_End_Time - Game_State:GetServerWorldTimeSeconds()))
        else
            self.Reward_Remaining_Seconds = self.Reward_Remaining_Seconds - 1
        end
        if self.Reward_Remaining_Seconds > 0 then
            Reward_Countdown_UI.TextBlock_3:SetText(
                string.format("距离奖励还有%d秒", self.Reward_Remaining_Seconds))
        else
            Reward_Countdown_UI.TextBlock_3:SetText("可以领奖")
        end
        self.Widget:RequestRedraw()

        if self.Reward_Remaining_Seconds <= 0 then
            if Previous_Remaining_Seconds > 0 then
                L_GloTools.PlayParticleAtLocation(self, L_Enum.Name_Particle.P_Fireworks_01,
                    self:K2_GetActorLocation(), self:K2_GetActorRotation())
            end
            UGCTimerUtility.RemoveLuaTimer(self.Reward_Countdown_Timer)
            self.Reward_Countdown_Timer = nil
        end
    end, true)
end

--[[----------------------处理玩家碰撞领取礼包------------------------]]
function Reward_Colli:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self.Reward_Is_Available then
        return
    end

    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 碰撞玩家的控制器
    if not Player_Controller then
        return
    end

    self.Reward_Is_Available = false
    local Reward_Items = UGCDropSystem.DropItems(self.Reward_Drop_ID) -- 本次礼包的随机掉落结果
    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not Virtual_Item_Manager:AddVirtualItems(Player_Controller, Reward_Items) then
        self.Reward_Is_Available = true
        return
    end

    L_TipsTool.ShowTips_01("领取礼包成功", Player_Controller)
    self:StartRewardTimer()
end

return Reward_Colli
