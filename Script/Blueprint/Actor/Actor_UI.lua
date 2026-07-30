---@class Actor_UI_C:AActor
---@field Widget UWidgetComponent
---@field DefaultSceneRoot USceneComponent
---@field Name FString
--Edit Below--
local Actor_UI = {}

--[[----------------------设置广告牌显示文字------------------------]]
function Actor_UI:ReceiveBeginPlay()
    Actor_UI.SuperClass.ReceiveBeginPlay(self)

    local Ad_Widget = self.Widget:GetUserWidgetObject()  -- 获取广告牌控件
    if Ad_Widget then
        Ad_Widget.TextBlock_0:SetText(self.Name)
    end
end

--[[
function Actor_UI:ReceiveTick(DeltaTime)
    Actor_UI.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Actor_UI:ReceiveEndPlay()
    Actor_UI.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Actor_UI:GetReplicatedProperties()
    return
end
--]]

--[[
function Actor_UI:GetAvailableServerRPCs()
    return
end
--]]

return Actor_UI
