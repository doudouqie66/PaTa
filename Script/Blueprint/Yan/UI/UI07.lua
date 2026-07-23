---@class UI07_C:UUserWidget
---@field Button_60 UButton
---@field Button_66 UButton
---@field Button_67 UButton
---@field Button_68 UButton
---@field Button_69 UButton
---@field Button_70 UButton
---@field Button_71 UButton
---@field Button_72 UButton
---@field Button_73 UButton
---@field Button_74 UButton
---@field Button_75 UButton
---@field Button_76 UButton
---@field Button_159 UButton
---@field Image_0 UImage
---@field Image_18 UImage
---@field Image_99 UImage
-- Edit Below--
local UI07 = {
    bInitDoOnce = false
}

function UI07:Construct()
    self:LuaInit();

end

-- function UI07:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI07:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI07:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_159.OnClicked:Add(self.Button_159_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI07:Button_159_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, false)

end

-- [Editor Generated Lua] function define End;

return UI07
