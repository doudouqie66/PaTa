---@class UI14_C:UUserWidget
---@field Button_69 UButton
---@field Button_71 UButton
---@field Button_88 UButton
---@field Button_159 UButton
---@field EditorUtilityEditableTextBox_216 UEditorUtilityEditableTextBox
---@field Image_0 UImage
---@field Image_18 UImage
---@field Image_34 UImage
---@field Image_97 UImage
---@field Image_111 UImage
---@field Image_112 UImage
---@field Image_113 UImage
---@field Image_210 UImage
--Edit Below--
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
--Edit Below--
local UI14 = {
    bInitDoOnce = false
}

function UI14:Construct()
    self:LuaInit();

end

-- function UI14:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI14:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI14:LuaInit()
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

function UI14:Button_159_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI14, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true)

    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Notice)
end

-- [Editor Generated Lua] function define End;

return UI14
