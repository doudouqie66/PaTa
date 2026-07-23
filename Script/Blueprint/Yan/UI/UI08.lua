---@class UI08_C:UUserWidget
---@field Button_88 UButton
---@field Button_159 UButton
---@field EditorUtilityEditableTextBox_216 UEditorUtilityEditableTextBox
---@field Image_0 UImage
---@field Image_16 UImage
---@field Image_18 UImage
---@field Image_34 UImage
---@field Image_97 UImage
---@field Image_209 UImage
---@field Image_210 UImage
---@field Image_286 UImage
-- Edit Below--
local UI08 = {
    bInitDoOnce = false
}

function UI08:Construct()
    self:LuaInit();

end

-- function UI08:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI08:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI08:LuaInit()
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

function UI08:Button_159_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI08, false)

end

-- [Editor Generated Lua] function define End;

return UI08
