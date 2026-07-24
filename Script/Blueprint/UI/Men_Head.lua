---@class Men_Head_C:AActor
---@field Widget UWidgetComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local Men_Head = {}

--[[----------------------初始化门上方倒计时------------------------]]
function Men_Head:ReceiveBeginPlay()
    Men_Head.SuperClass.ReceiveBeginPlay(self)
    self.Widget:SetVisibility(false, true, false)
end

--[[----------------------开启门上方倒计时------------------------]]
function Men_Head:StartCountdown()
    self.Widget:SetVisibility(true, true, false)
    local Count_Down_UI = self.Widget:GetUserWidgetObject() -- 倒计时界面实例
    if Count_Down_UI then
        Count_Down_UI:StartCountdown(self.Widget)
    end
end

--[[----------------------停止门上方倒计时------------------------]]
function Men_Head:StopCountdown()
    local Count_Down_UI = self.Widget:GetUserWidgetObject() -- 倒计时界面实例
    if Count_Down_UI then
        Count_Down_UI:StopCountdown()
    end
    self.Widget:SetVisibility(false, true, false)
end

return Men_Head
