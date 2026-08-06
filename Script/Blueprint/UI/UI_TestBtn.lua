---@class UI_TestBtn_C:UUserWidget
---@field Button_6 UButton
---@field Button_11 UButton
---@field Button_12 UButton
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end

-- function UI_TestBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI_TestBtn:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
    self.Button_11.OnClicked:Add(self.Button_11_OnClicked, self);
    self.Button_12.OnClicked:Add(self.Button_12_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI_TestBtn:Button_6_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, true)

end

--[[----------------------隐藏整个主UI------------------------]]
function UI_TestBtn:Button_11_OnClicked()
    L_GloTools.Change_SysUI(false)
end

--[[----------------------恢复主UI显示------------------------]]
function UI_TestBtn:Button_12_OnClicked()

    L_GloTools.Change_SysUI(true)

end
-- [Editor Generated Lua] function define End;

return UI_TestBtn
