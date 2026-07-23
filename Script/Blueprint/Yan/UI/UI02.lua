---@class UI02_C:UUserWidget
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_86 UButton
---@field Button_108 UButton
---@field Button_109 UButton
---@field Button_111 UButton
---@field Button_112 UButton
---@field Button_113 UButton
---@field Button_115 UButton
---@field Image_37 UImage
---@field Image_38 UImage
-- Edit Below--
---@class UI02_C:UUserWidget
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_86 UButton
---@field Button_108 UButton
---@field Button_109 UButton
---@field Button_111 UButton
---@field Button_112 UButton
---@field Button_113 UButton
---@field Button_115 UButton
---@field Image_37 UImage
---@field Image_38 UImage
-- Edit Below--
local UI02 = {
    bInitDoOnce = false
}

function UI02:Construct()
    self:LuaInit();

end

-- function UI02:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI02:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI02:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_86.OnClicked:Add(self.Button_86_OnClicked, self);
    self.Button_111.OnClicked:Add(self.Button_111_OnClicked, self);
    self.Button_112.OnClicked:Add(self.Button_112_OnClicked, self);
    self.Button_113.OnClicked:Add(self.Button_113_OnClicked, self);
    self.Button_115.OnClicked:Add(self.Button_115_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

function UI02:Button_86_OnClicked()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Switch_View)
end
--[[--------------------超值周卡--------------------------]] --
function UI02:Button_111_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, true)
end
--[[--------------------金币商店--------------------------]] --

function UI02:Button_112_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI04, true)

end
--[[--------------------七天签到--------------------------]] --

function UI02:Button_113_OnClicked()
end
--[[--------------------全服排行--------------------------]] --

function UI02:Button_115_OnClicked()
end

-- [Editor Generated Lua] function define End;

return UI02
