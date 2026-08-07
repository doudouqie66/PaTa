---@class UI_TestBtn_C:UUserWidget
---@field Button_0 UButton
---@field Button_6 UButton
---@field Image_67 UImage
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
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI_TestBtn:Button_6_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, true)

end

function UI_TestBtn:Button_0_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, true)

end

-- [Editor Generated Lua] function define End;

return UI_TestBtn
