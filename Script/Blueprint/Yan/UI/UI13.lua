---@class UI13_C:UUserWidget
---@field Button_0 UButton
---@field Button_5 UButton
---@field Button_69 UButton
---@field Button_147 UButton
---@field Button_194 UButton
---@field Image_1 UImage
---@field Image_5 UImage
---@field Image_6 UImage
---@field Image_265 UImage
--Edit Below--
local UI13 = {
    bInitDoOnce = false
}

function UI13:Construct()
    self:LuaInit();

end

-- function UI13:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI13:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI13:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_147.OnClicked:Add(self.Button_147_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI13:Button_147_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, false, false)

end

-- [Editor Generated Lua] function define End;

return UI13
