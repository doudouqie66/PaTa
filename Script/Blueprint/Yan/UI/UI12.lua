---@class UI12_C:UUserWidget
---@field Button_69 UButton
---@field Button_112 UButton
---@field Button_147 UButton
---@field Button_177 UButton
---@field Button_186 UButton
---@field Button_194 UButton
---@field Button_195 UButton
---@field Button_196 UButton
---@field Button_197 UButton
---@field Button_198 UButton
---@field Button_200 UButton
---@field Image_70 UImage
---@field Image_100 UImage
--Edit Below--
local UI12 = {
    bInitDoOnce = false
}

function UI12:Construct()
    self:LuaInit();

end

-- function UI12:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI12:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI12:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_147.OnClicked:Add(self.Button_147_OnClicked, self);
    self.Button_177.OnClicked:Add(self.Button_177_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI12:Button_147_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, false)
end

function UI12:Button_177_OnClicked()
    local bOK = UGCWidgetManagerSystem.Share(function()
        L_TipsTool.ShowTips_01("分享界面已关闭")
    end)
    if not bOK then
        PopUpNoticeUI.ShowFastNoticeQueue("当前无法分享")
        L_TipsTool.ShowTips_01("当前无法分享")
    end
end

-- [Editor Generated Lua] function define End;

return UI12
