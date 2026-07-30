---@class Name_UI_C:AActor
---@field Widget UWidgetComponent
---@field DefaultSceneRoot USceneComponent
---@field Name FString
--Edit Below--
local Name_UI = {}

--[[----------------------设置广告牌显示文字------------------------]]
function Name_UI:ReceiveBeginPlay()
    Name_UI.SuperClass.ReceiveBeginPlay(self)

    local Ad_Widget = self.Widget:GetUserWidgetObject()  -- 获取广告牌控件
    if Ad_Widget then
        Ad_Widget.TextBlock_0:SetText(self.Name)
    end
end

--[[
function Name_UI:ReceiveTick(DeltaTime)
    Name_UI.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Name_UI:ReceiveEndPlay()
    Name_UI.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Name_UI:GetReplicatedProperties()
    return
end
--]]

--[[
function Name_UI:GetAvailableServerRPCs()
    return
end
--]]

return Name_UI
