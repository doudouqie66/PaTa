---@class Guide_Arrow_C:AActor
---@field Widget UWidgetComponent
---@field DefaultSceneRoot USceneComponent
---@field Name FString
--Edit Below--
local Guide_Arrow = {}

--[[----------------------设置广告牌显示文字------------------------]]
function Guide_Arrow:ReceiveBeginPlay()
    Guide_Arrow.SuperClass.ReceiveBeginPlay(self)

    local Ad_Widget = self.Widget:GetUserWidgetObject()  -- 获取广告牌控件
    if Ad_Widget then
        Ad_Widget.TextBlock_0:SetText(self.Name)
    end
end

--[[
function Guide_Arrow:ReceiveTick(DeltaTime)
    Guide_Arrow.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Guide_Arrow:ReceiveEndPlay()
    Guide_Arrow.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Guide_Arrow:GetReplicatedProperties()
    return
end
--]]

--[[
function Guide_Arrow:GetAvailableServerRPCs()
    return
end
--]]

return Guide_Arrow
