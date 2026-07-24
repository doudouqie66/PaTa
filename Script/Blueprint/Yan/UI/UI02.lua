---@class UI02_C:UUserWidget
---@field Button_0 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_86 UButton
---@field Button_108 UButton
---@field Button_109 UButton
---@field Button_111 UButton
---@field Button_112 UButton
---@field Button_113 UButton
---@field Button_115 UButton
---@field Image_187 UImage
---@field Image_188 UImage
---@field Image_276 UImage
---@field Image_277 UImage
---@field Image_278 UImage
---@field Image_279 UImage
---@field Image_280 UImage
---@field Image_281 UImage
---@field Image_282 UImage
---@field Image_283 UImage
---@field Image_284 UImage
---@field TextBlock_5 UTextBlock
---@field TextBlock_6 UTextBlock
---@field TextBlock_7 UTextBlock
---@field TextBlock_8 UTextBlock
---@field TextBlock_9 UTextBlock
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
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
    self.Button_5.OnClicked:Add(self.Button_5_OnClicked, self);
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
    self.Button_7.OnClicked:Add(self.Button_7_OnClicked, self);
    self.Button_8.OnClicked:Add(self.Button_8_OnClicked, self);
    self.Button_9.OnClicked:Add(self.Button_9_OnClicked, self);
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
-- 
--[[--------------------全服排行--------------------------]] --

function UI02:Button_115_OnClicked()
    -- 打开排行榜界面
    RankingListManager:OpenRankingList()
end

--[[---------------------首充-------------------------]] --
function UI02:Button_0_OnClicked()

    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI06)
end

--[[---------------------第一个物品-------------------------]] --
function UI02:Button_5_OnClicked()
    return nil;
end
--[[---------------------第二个物品-------------------------]] --

function UI02:Button_6_OnClicked()
    return nil;
end
--[[---------------------第三个物品-------------------------]] --

function UI02:Button_7_OnClicked()
    return nil;
end
--[[---------------------第四个物品-------------------------]] --

function UI02:Button_8_OnClicked()
    return nil;
end
--[[---------------------第五个物品-------------------------]] --

function UI02:Button_9_OnClicked()
    return nil;
end

-- [Editor Generated Lua] function define End;
--[[--------------------奖杯商店--------------------------]] --

function UI02:Button_113_OnClicked()
    -- 打开奖杯商店
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI05)

end
return UI02
