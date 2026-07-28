---@class UI02_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
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
---@field Button_151 UButton
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
---@field ScaleBox_43 UScaleBox
---@field TextBlock_5 UTextBlock
---@field TextBlock_6 UTextBlock
---@field TextBlock_7 UTextBlock
---@field TextBlock_8 UTextBlock
---@field TextBlock_9 UTextBlock
---@field TextBlock_61 UTextBlock
---@field TextBlock_62 UTextBlock
---@field TextBlock_287 UTextBlock
--Edit Below--
---@class UI02_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
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
---@field Button_151 UButton
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
---@field ScaleBox_43 UScaleBox
---@field TextBlock_5 UTextBlock
---@field TextBlock_6 UTextBlock
---@field TextBlock_7 UTextBlock
---@field TextBlock_8 UTextBlock
---@field TextBlock_9 UTextBlock
---@field TextBlock_61 UTextBlock
---@field TextBlock_62 UTextBlock
---@field TextBlock_287 UTextBlock
-- Edit Below--
local Gold_Item_ID = 8310003 -- 金币物品ID
local Win_Cup_Item_ID = 8310012 -- 奖杯物品ID
local Event_Countdown_Start_Scale = 1.5 -- 事件倒计时起始缩放
local Event_Countdown_End_Scale = 1.0 -- 事件倒计时结束缩放
local Event_Countdown_Animation_Duration = 0.45 -- 单个数字缩放时长

local UI02 = {
    bInitDoOnce = false,
    Reward_Available_State = {} -- 奖励上次可领取状态
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
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Remove(self.OnBuyStarterGiftResult, self)
    UGCCommoditySystem.UGCProductsChangedDelegate:Remove(self.RefreshStarterGiftButton, self)
    if self.Tower_Reward_UI_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Tower_Reward_UI_Timer)
        self.Tower_Reward_UI_Timer = nil
    end
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
        self.Event_Countdown_Timer = nil
    end
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
        self.Event_Countdown_Tween = nil
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
    self.Button_1.OnClicked:Add(self.Button_1_OnClicked, self);
    self.Button_2.OnClicked:Add(self.Button_2_OnClicked, self);
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Add(self.OnBuyStarterGiftResult, self)
    UGCCommoditySystem.UGCProductsChangedDelegate:Add(self.RefreshStarterGiftButton, self)
    -- [Editor Generated Lua] BindingEvent End;
    self:RefreshCurrency()
    self:RefreshTowerRewards()
    self:RefreshStarterGiftButton()
    self.ScaleBox_43:SetRenderTransformPivot(UGCMathUtility.MakeVector2D(0.5, 0.5))
    self.ScaleBox_43:SetVisibility(ESlateVisibility.Collapsed)
    self.Tower_Reward_UI_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self:RefreshTowerRewards()
    end, true)
end

--[[----------------------播放当前事件倒计时数字动画------------------------]]
function UI02:PlayEventCountdownNumber()
    if self.Event_Countdown_Tween and UGCTweenSystem.IsTweenValid(self.Event_Countdown_Tween) then
        UGCTweenSystem.KillTween(self.Event_Countdown_Tween)
    end

    self.TextBlock_287:SetText(tostring(self.Event_Countdown_Remaining))
    self.ScaleBox_43:SetRenderScale(UGCMathUtility.MakeVector2D(Event_Countdown_Start_Scale,
        Event_Countdown_Start_Scale))
    self.Event_Countdown_Tween = UGCTweenSystem.TweenFloatValue(
        Event_Countdown_Start_Scale,
        Event_Countdown_End_Scale,
        Event_Countdown_Animation_Duration,
        EEasingType.QuadOut,
        function(_, Scale)
            self.ScaleBox_43:SetRenderScale(UGCMathUtility.MakeVector2D(Scale, Scale))
        end,
        UGCTweenSystem.MakeConfig(0, 0, false, 0)
    )
end

--[[----------------------开始事件倒计时------------------------]]
function UI02:StartEventCountdown(Countdown_Duration)
    if self.Event_Countdown_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
    end

    self.Event_Countdown_Remaining = math.floor(Countdown_Duration)
    self.ScaleBox_43:SetVisibility(ESlateVisibility.Visible)
    self:PlayEventCountdownNumber()
    self.Event_Countdown_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self.Event_Countdown_Remaining = self.Event_Countdown_Remaining - 1
        if self.Event_Countdown_Remaining <= 0 then
            UGCTimerUtility.RemoveLuaTimer(self.Event_Countdown_Timer)
            self.Event_Countdown_Timer = nil
            self.ScaleBox_43:SetVisibility(ESlateVisibility.Collapsed)
            return
        end
        self:PlayEventCountdownNumber()
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
            self.Reward_Available_State[Reward_Index] = false
            Reward_Buttons[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Texts[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Images[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Red_Dots[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
        else
            local Is_Available = Elapsed_Time >= Reward_Time -- 当前档位是否可以领取
            local Remaining_Time = math.max(0, Reward_Time - Elapsed_Time) -- 当前档位剩余秒数
            if self.Reward_Available_State[Reward_Index] == false and Is_Available then
                SoundMgr.PlaySound2D(SoundMgr.SoundName.Reward_Ready)
            end
            self.Reward_Available_State[Reward_Index] = Is_Available
            Reward_Buttons[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Texts[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Images[Reward_Index]:SetVisibility(ESlateVisibility.Visible)
            Reward_Buttons[Reward_Index]:SetIsEnabled(Is_Available)
            Reward_Red_Dots[Reward_Index]:SetVisibility(Is_Available and ESlateVisibility.Visible or
                                                            ESlateVisibility.Collapsed)

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
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Claim_Tower_Reward, Reward_Index)
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
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)
end
--[[--------------------超值周卡--------------------------]] --
function UI02:Button_111_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, true)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end
--[[--------------------金币商店--------------------------]] --

function UI02:Button_112_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI04, true)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end
-- 
--[[--------------------全服排行--------------------------]] --

function UI02:Button_115_OnClicked()
    -- 打开排行榜界面
    RankingListManager:OpenRankingList()
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

--[[----------------------根据永久限购记录刷新首充按钮------------------------]]
function UI02:RefreshStarterGiftButton()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Purchased_Times = ShopV2Manager:GetLimitPurchasedTimes(
        L_Enum.ID_ShopProduct.StarterGift,
        Player_Controller
    ) -- 首充商品已购买次数
    self.Button_0:SetVisibility(Purchased_Times > 0 and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
end

--[[----------------------首充购买成功后隐藏入口按钮------------------------]]
function UI02:OnBuyStarterGiftResult(bSuccess, PlayerKey, CommodityID, Count, UID, ProductID)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    if not bSuccess or PlayerKey ~= Player_Controller.PlayerKey or
        CommodityID ~= L_Enum.ID_Gift.StarterGift or ProductID ~= L_Enum.ID_ShopProduct.StarterGift then
        return
    end

    self.Button_0:SetVisibility(ESlateVisibility.Collapsed)
end

--[[---------------------首充-------------------------]] --
function UI02:Button_0_OnClicked()
    local UI_Path = L_Enum.Name_ClassPath.UI06 -- 首充界面路径
    local UI_BP = L_GloTools.UI_Map[UI_Path] -- 已创建的首充界面
    local Is_Opening = UI_BP == nil or not UI_BP:IsVisible() -- 本次是否打开界面
    L_GloTools.UIMgr(UI_Path)
    SoundMgr.PlaySound2D(Is_Opening and SoundMgr.SoundName.UI_Switch or SoundMgr.SoundName.Event_Notice)
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
--[[--------------------绿洲商店--------------------------]] --
function UI02:Button_1_OnClicked()
    ShopV2Manager:OpenMainUI(TabID)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

function UI02:Button_2_OnClicked()
    local PC = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Tele_To_Point, 2)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Fly_Start)
end

-- [Editor Generated Lua] function define End;
--[[--------------------奖杯商店--------------------------]] --

function UI02:Button_113_OnClicked()
    -- 打开奖杯商店
    local UI_Path = L_Enum.Name_ClassPath.UI05 -- 奖杯商店界面路径
    local UI_BP = L_GloTools.UI_Map[UI_Path] -- 已创建的奖杯商店界面
    local Is_Opening = UI_BP == nil or not UI_BP:IsVisible() -- 本次是否打开界面
    L_GloTools.UIMgr(UI_Path)
    SoundMgr.PlaySound2D(Is_Opening and SoundMgr.SoundName.UI_Switch or SoundMgr.SoundName.Event_Notice)
end
return UI02
