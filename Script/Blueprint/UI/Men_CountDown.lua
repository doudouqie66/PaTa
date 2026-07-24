---@class Men_CountDown_C:UUserWidget
---@field TextBlock_0 UTextBlock
--Edit Below--
---@class Men_CountDown_C:UUserWidget
---@field TextBlock_0 UTextBlock
-- Edit Below--
---@class HeadTop_UI_C:UUserWidget
---@field TextBlock_0 UTextBlock
-- Edit Below--
local Men_CountDown = {
    Count_Down_Timer = nil, -- 倒计时计时器
    Count_Down_Duration = 20 -- 倒计时持续秒数
}

--[[----------------------开启倒计时------------------------]]
function Men_CountDown:StartCountdown(Widget_Component)
    self:StopCountdown()
    self.Remaining_Seconds = self.Count_Down_Duration -- 剩余倒计时秒数
    self.TextBlock_0:SetText(tostring(self.Remaining_Seconds))
    Widget_Component:RequestRedraw()

    self.Count_Down_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self.Remaining_Seconds = self.Remaining_Seconds - 1
        self.TextBlock_0:SetText(tostring(self.Remaining_Seconds))
        Widget_Component:RequestRedraw()

        if self.Remaining_Seconds <= 0 then
            self:StopCountdown()
        end
    end, true)
end

--[[----------------------停止倒计时------------------------]]
function Men_CountDown:StopCountdown()
    if self.Count_Down_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Count_Down_Timer)
        self.Count_Down_Timer = nil
    end
end

--[[----------------------销毁时清理倒计时------------------------]]
function Men_CountDown:Destruct()
    self:StopCountdown()
end

return Men_CountDown
