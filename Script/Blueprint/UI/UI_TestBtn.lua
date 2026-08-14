---@class UI_TestBtn_C:UUserWidget
---@field Button_6 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    Is_Initialized = false -- 是否已完成按钮监听初始化
}

--[[----------------------构造按钮界面------------------------]]
function UI_TestBtn:Construct()
    self:LuaInit()
end

--[[----------------------初始化按钮点击监听------------------------]]
function UI_TestBtn:LuaInit()
    if self.Is_Initialized then
        return
    end
    self.Is_Initialized = true
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self)
end

--[[----------------------响应按钮点击------------------------]]
function UI_TestBtn:Button_6_OnClicked()
end

return UI_TestBtn
