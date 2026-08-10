---@class UI13_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_3 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_69 UButton
---@field Button_147 UButton
---@field Button_194 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_70 UImage
---@field Image_95 UImage
---@field Image_103 UImage
---@field Image_104 UImage
---@field Image_105 UImage
---@field Image_106 UImage
---@field Image_107 UImage
---@field Image_108 UImage
---@field Image_109 UImage
---@field Image_110 UImage
---@field Image_111 UImage
---@field Image_112 UImage
---@field Image_113 UImage
---@field Image_114 UImage
---@field Image_115 UImage
---@field Image_116 UImage
---@field Image_117 UImage
---@field Image_118 UImage
---@field Image_119 UImage
---@field Image_120 UImage
---@field Image_121 UImage
---@field Image_122 UImage
---@field Image_123 UImage
---@field Image_124 UImage
---@field Image_145 UImage
---@field Image_170 UImage
---@field Image_265 UImage
---@field UIParticleEmitter_283 UUIParticleEmitter
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
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, false, false)

end

-- [Editor Generated Lua] function define End;

return UI13
