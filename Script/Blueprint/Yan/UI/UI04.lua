---@class UI04_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_11 UButton
---@field Button_54 UButton
---@field Button_203 UButton
---@field Button_330 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_10 UImage
---@field Image_11 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_15 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field Image_19 UImage
---@field Image_20 UImage
---@field Image_21 UImage
---@field Image_22 UImage
---@field Image_23 UImage
---@field Image_55 UImage
---@field Image_116 UImage
---@field Image_122 UImage
---@field Image_216 UImage
---@field Image_360 UImage
---@field Image_481 UImage
--Edit Below--
---@class UI04_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_11 UButton
---@field Button_54 UButton
---@field Button_203 UButton
---@field Button_330 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_10 UImage
---@field Image_11 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_15 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field Image_19 UImage
---@field Image_20 UImage
---@field Image_21 UImage
---@field Image_22 UImage
---@field Image_23 UImage
---@field Image_55 UImage
---@field Image_116 UImage
---@field Image_122 UImage
---@field Image_216 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
local UI04 = {
    bInitDoOnce = false
}

function UI04:Construct()
    self:LuaInit();

end

-- function UI04:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI04:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI04:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_330.OnClicked:Add(self.Button_330_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI04:Button_330_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI04, false)

end

-- [Editor Generated Lua] function define End;

return UI04
