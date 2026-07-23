---@class UI01_C:UUserWidget
---@field Button_75 UButton
---@field Image_0 UImage
---@field Image_42 UImage
---@field Image_43 UImage
---@field Image_44 UImage
---@field Image_45 UImage
---@field Image_98 UImage
---@field Image_246 UImage
---@field ProgressBar_76 UProgressBar
-- Edit Below--
---@class UI01_C:UUserWidget
---@field Button_75 UButton
---@field Image_0 UImage
---@field Image_42 UImage
---@field Image_43 UImage
---@field Image_44 UImage
---@field Image_45 UImage
---@field Image_98 UImage
---@field Image_246 UImage
---@field ProgressBar_76 UProgressBar
-- Edit Below--
local UI01 = {
    bInitDoOnce = false
}

function UI01:Construct()
    self:LuaInit();

end

-- function UI01:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI01:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI01:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_75.OnClicked:Add(self.Button_75_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI01:Button_75_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI01, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true)

end

-- [Editor Generated Lua] function define End;

return UI01
