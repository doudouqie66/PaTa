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
---@field TextBlock_61 UTextBlock
---@field TextBlock_62 UTextBlock
--Edit Below--
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
    if self.Tower_Reward_UI_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Tower_Reward_UI_Timer)
        self.Tower_Reward_UI_Timer = nil
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
    self:RefreshTowerRewards()
    self.Tower_Reward_UI_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self:RefreshTowerRewards()
    end, true)
end

--[[----------------------刷新塔内计时奖励界面------------------------]]
function UI02:RefreshTowerRewards()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Elapsed_Time = Player_Controller:GetTowerRewardElapsedTime() -- 已累计停留秒数
    local Reward_Buttons = {self.Button_5, self.Button_6, self.Button_7, self.Button_8, self.Button_9} -- 五档奖励按钮
    local Reward_Texts = {self.TextBlock_5, self.TextBlock_6, self.TextBlock_7, self.TextBlock_8, self.TextBlock_9} -- 五档倒计时文本
    local Reward_Images = {self.Image_276, self.Image_277, self.Image_279, self.Image_281, self.Image_283} -- 五档奖励图片
    local Reward_Red_Dots = {self.Image_188, self.Image_278, self.Image_280, self.Image_282, self.Image_284} -- 五档奖励红点

    for Reward_Index, Reward_Time in ipairs(L_Enum.Tower_Reward.Reward_Times) do
        local Reward_Flag = 2 ^ (Reward_Index - 1) -- 当前档位领取状态位
        local Has_Claimed = math.floor(Player_Controller.Tower_Reward_Claim_Mask / Reward_Flag) % 2 == 1 -- 是否已领取

        if Has_Claimed then
            Reward_Buttons[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Texts[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Images[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Red_Dots[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
        else
            local Is_Available = Elapsed_Time >= Reward_Time -- 当前档位是否可以领取
            local Remaining_Time = math.max(0, Reward_Time - Elapsed_Time) -- 当前档位剩余秒数
            Reward_Buttons[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Texts[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Images[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Buttons[Reward_Index]:SetIsEnabled(Is_Available)
            Reward_Red_Dots[Reward_Index]:SetVisibility(
                Is_Available and ESlateVisibility.Visible or ESlateVisibility.Collapsed)

            if Is_Available then
                Reward_Texts[Reward_Index]:SetText("可领取")
            else
                Reward_Texts[Reward_Index]:SetText(tostring(Remaining_Time) .. "秒领取")
            end
        end
    end
end

--[[----------------------申请领取塔内计时奖励------------------------]]
function UI02:ClaimTowerReward(Reward_Index)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Claim_Tower_Reward,
        Reward_Index)
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
    self:ClaimTowerReward(1)
end
--[[---------------------第二个物品-------------------------]] --

function UI02:Button_6_OnClicked()
    self:ClaimTowerReward(2)
end
--[[---------------------第三个物品-------------------------]] --

function UI02:Button_7_OnClicked()
    self:ClaimTowerReward(3)
end
--[[---------------------第四个物品-------------------------]] --

function UI02:Button_8_OnClicked()
    self:ClaimTowerReward(4)
end
--[[---------------------第五个物品-------------------------]] --

function UI02:Button_9_OnClicked()
    self:ClaimTowerReward(5)
end

-- [Editor Generated Lua] function define End;
--[[--------------------奖杯商店--------------------------]] --

function UI02:Button_113_OnClicked()
    -- 打开奖杯商店
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI05)

end
return UI02
