---@class UI_CountDownAttnetion_C:UUserWidget
---@field Image_53 UImage
---@field TextBlock_0 UTextBlock
---@field TextBlock_1 UTextBlock
--Edit Below--
local Event_Countdown_Start_Scale = 1.5 -- 事件倒计时起始缩放
local Event_Countdown_End_Scale = 1.0 -- 事件倒计时结束缩放
local Event_Countdown_Animation_Duration = 0.45 -- 单个数字缩放时长

local UI_CountDownAttnetion = {
    bInitDoOnce = false,
    Event_Countdown_Timer = nil, -- 事件倒计时计时器
    Event_Countdown_Tween = nil -- 事件倒计时动画
}

--[[----------------------构造事件倒计时界面------------------------]]
function UI_CountDownAttnetion:Construct()
    self.TextBlock_1:SetText("事件倒计时：")
    self.TextBlock_0:SetRenderTransformPivot(UGCMathUtility.MakeVector2D(0.5, 0.5))
end

-- function UI_CountDownAttnetion:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------播放当前事件倒计时数字动画------------------------]]
function UI_CountDownAttnetion:PlayEventCountdownNumber()
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
    end

    self.TextBlock_0:SetText(tostring(self.Event_Countdown_Remaining))
    self.TextBlock_0:SetRenderScale(UGCMathUtility.MakeVector2D(Event_Countdown_Start_Scale,
        Event_Countdown_Start_Scale))
    self.Event_Countdown_Tween = UGCTweenSystem.TweenFloatValue(
        Event_Countdown_Start_Scale,
        Event_Countdown_End_Scale,
        Event_Countdown_Animation_Duration,
        EEasingType.QuadOut,
        function(_, Scale)
            self.TextBlock_0:SetRenderScale(UGCMathUtility.MakeVector2D(Scale, Scale))
        end,
        UGCTweenSystem.MakeConfig(0, 0, false, 0)
    )
end

--[[----------------------开始事件倒计时------------------------]]
function UI_CountDownAttnetion:StartEventCountdown(Countdown_Duration, Event_Name)
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
    end

    self.Event_Countdown_Remaining = math.floor(Countdown_Duration) -- 事件倒计时剩余秒数
    self.TextBlock_1:SetText("距离" .. (Event_Name or "事件") .. "倒计时：")
    self:PlayEventCountdownNumber()
    self.Event_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self.Event_Countdown_Remaining = self.Event_Countdown_Remaining - 1

        if self.Event_Countdown_Remaining <= 0 then
            UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
            self.Event_Countdown_Timer = nil
            self:SetVisibility(ESlateVisibility.Collapsed)
            return
        end
        self:PlayEventCountdownNumber()
    end, true)
end

--[[----------------------销毁事件倒计时界面------------------------]]
function UI_CountDownAttnetion:Destruct()
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
        self.Event_Countdown_Timer = nil
    end
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
        self.Event_Countdown_Tween = nil
    end
end

return UI_CountDownAttnetion
