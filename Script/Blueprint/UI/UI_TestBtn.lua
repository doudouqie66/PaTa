---@class UI_TestBtn_C:UUserWidget
---@field Button_6 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end

function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
end

function UI_TestBtn:Button_6_OnClicked()
end

return UI_TestBtn
