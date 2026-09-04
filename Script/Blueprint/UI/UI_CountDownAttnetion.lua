---@class UI_CountDownAttnetion_C:UUserWidget
---@field Image_1 UImage
---@field Image_53 UImage
---@field ScaleBox_1 UScaleBox
---@field ScaleBox_48 UScaleBox
---@field TextBlock_0 UTextBlock
---@field TextBlock_1 UTextBlock
---@field TextBlock_4 UTextBlock
---@field TextBlock_5 UTextBlock
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
    self.ScaleBox_48:SetVisibility(ESlateVisibility.Collapsed)
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Collapsed)
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

--[[----------------------开始事件预警倒计时------------------------]]
function UI_CountDownAttnetion:StartEventCountdown(Countdown_Duration, Event_Name, Event_Duration)
    if Countdown_Duration <= 0 then
        self:StartActiveEventCountdown(Event_Duration, Event_Name)
        return
    end

    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
    end

    self.ScaleBox_48:SetVisibility(ESlateVisibility.Visible)
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Collapsed)
    self.Event_Countdown_Remaining = math.floor(Countdown_Duration) -- 事件预警剩余秒数
    self.TextBlock_1:SetText("距离【" .. (Event_Name or "事件") .. "】生效还有：")
    self:PlayEventCountdownNumber()
    self.Event_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self.Event_Countdown_Remaining = self.Event_Countdown_Remaining - 1

        if self.Event_Countdown_Remaining <= 0 then
            UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
            self.Event_Countdown_Timer = nil
            self:StartActiveEventCountdown(Event_Duration, Event_Name)
            return
        end
        self:PlayEventCountdownNumber()
    end, true)
end

--[[----------------------开始事件生效倒计时------------------------]]
function UI_CountDownAttnetion:StartActiveEventCountdown(Event_Duration, Event_Name)
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
    end
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
        self.Event_Countdown_Tween = nil
    end

    self.ScaleBox_48:SetVisibility(ESlateVisibility.Collapsed)
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Visible)
    self.Event_Countdown_Remaining = math.floor(Event_Duration) -- 事件生效剩余秒数
    self.TextBlock_5:SetText("【" .. (Event_Name or "事件") .. "】剩余：")
    self.TextBlock_4:SetText(tostring(self.Event_Countdown_Remaining))
    self.Event_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self.Event_Countdown_Remaining = self.Event_Countdown_Remaining - 1

        if self.Event_Countdown_Remaining <= 0 then
            self:StopEventCountdown()
            return
        end
        self.TextBlock_4:SetText(tostring(self.Event_Countdown_Remaining))
    end, true)
end

--[[----------------------停止并隐藏事件倒计时------------------------]]
function UI_CountDownAttnetion:StopEventCountdown()
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
        self.Event_Countdown_Timer = nil
    end
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
        self.Event_Countdown_Tween = nil
    end
    self.ScaleBox_48:SetVisibility(ESlateVisibility.Collapsed)
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Collapsed)
    self:SetVisibility(ESlateVisibility.Collapsed)
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
