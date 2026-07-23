---@class UI06_C:UUserWidget
---@field Button_88 UButton
---@field Button_159 UButton
---@field Image_16 UImage
---@field Image_18 UImage
---@field Image_97 UImage
---@field Image_209 UImage
---@field Image_210 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field Image_286 UImage
-- Edit Below--
local UI06 = {
    bInitDoOnce = false
}

function UI06:Construct()
    self:LuaInit();

end

-- function UI06:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI06:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI06:LuaInit()
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

function UI06:Button_159_OnClicked()

    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI06, false)

end

-- [Editor Generated Lua] function define End;

return UI06
