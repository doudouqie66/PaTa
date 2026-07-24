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
---@field TextBlock_61 UTextBlock
---@field TextBlock_62 UTextBlock
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
---@field TextBlock_61 UTextBlock
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
local Gold_Item_ID = 8310003 -- 金币物品ID
local Win_Cup_Item_ID = 8310012 -- 奖杯物品ID

local UI02 = {
    bInitDoOnce = false
}

--[[----------------------构造主城界面------------------------]]
function UI02:Construct()
    self:LuaInit();

end

-- function UI02:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------销毁主城界面------------------------]]
function UI02:Destruct()
    if self.Virtual_Item_Manager then
        self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.RefreshCurrency, self)
    end
end

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化主城界面------------------------]]
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
    self.Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Add(self.RefreshCurrency, self)
    -- [Editor Generated Lua] BindingEvent End;
    self:RefreshCurrency()
end

--[[----------------------刷新金币和奖杯数量------------------------]]
function UI02:RefreshCurrency()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    self.TextBlock_61:SetText(tostring(UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Gold_Item_ID)))
    self.TextBlock_62:SetText(tostring(UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Win_Cup_Item_ID)))
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
    -- 打开七天签到界面
    SignInEventManager:OpenMainUI()
end
--[[--------------------全服排行--------------------------]] --

function UI02:Button_115_OnClicked()
    -- 打开排行榜界面
    RankingListManager:OpenRankingList()
end

-- [Editor Generated Lua] function define End;

return UI02
