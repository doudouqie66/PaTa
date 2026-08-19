---@class UI_Black_C:UUserWidget
---@field Image_0 UImage
---@field Image_1 UImage
---@field ScaleBox_1 UScaleBox
---@field TextBlock_4 UTextBlock
---@field TextBlock_5 UTextBlock
--Edit Below--
local UI_Black = {
    bInitDoOnce = false,
    Night_Countdown_Timer = nil -- 黑夜剩余时间计时器
}

--[[----------------------构造黑夜界面------------------------]]
function UI_Black:Construct()
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Collapsed)
end

-- function UI_Black:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------开始显示黑夜剩余时间------------------------]]
function UI_Black:StartNightCountdown(Night_Buff, Event_Name)
    self:StopNightCountdown()
    self.Night_Buff = Night_Buff -- 当前黑夜Buff
    self.TextBlock_5:SetText("【" .. (Event_Name or "黑夜") .. "】剩余：")
    self.TextBlock_4:SetText(tostring(math.max(0, math.ceil(Night_Buff:GetRemainingTime()))))
    self.ScaleBox_1:SetVisibility(ESlateVisibility.HitTestInvisible)

    self.Night_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        if not self.Night_Buff or not UE.IsValid(self.Night_Buff) then
            self:StopNightCountdown()
            return
        end

        local Remaining_Seconds = math.max(0, math.ceil(self.Night_Buff:GetRemainingTime())) -- 黑夜剩余秒数
        self.TextBlock_4:SetText(tostring(Remaining_Seconds))
        if Remaining_Seconds <= 0 then
            self:StopNightCountdown()
        end
    end, true)
end

--[[----------------------停止显示黑夜剩余时间------------------------]]
function UI_Black:StopNightCountdown()
    if self.Night_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Night_Countdown_Timer)
        self.Night_Countdown_Timer = nil
    end
    self.Night_Buff = nil
    self.ScaleBox_1:SetVisibility(ESlateVisibility.Collapsed)
end

--[[----------------------销毁黑夜界面------------------------]]
function UI_Black:Destruct()
    self:StopNightCountdown()
end

return UI_Black
