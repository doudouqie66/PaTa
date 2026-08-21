---@class UI02_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_3 UButton
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
---@field Button_181 UButton
---@field Image_0 UImage
---@field Image_1 UImage
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
local Gold_Item_ID = 8310003 -- 金币物品ID
local Win_Cup_Item_ID = 8310012 -- 奖杯物品ID

local Countdown_Effect_Seconds = 3 -- 倒计时提醒秒数
local Countdown_Button_Scale = 1.12 -- 倒计时按钮放大倍率
local Countdown_Effect_Duration = 0.3 -- 倒计时单程动画时长

local UI02 = {
    bInitDoOnce = false,
    Reward_Available_State = {}, -- 奖励上次可领取状态
    Reward_Countdown_Effect_State = {}, -- 奖励倒计时特效状态
    Reward_Countdown_Scale_Tweens = {}, -- 奖励倒计时缩放动画
    Reward_Countdown_Color_Tweens = {} -- 奖励倒计时颜色动画
}

--[[----------------------构造主城界面------------------------]]
function UI02:Construct()
    self.First_Charge_Image_Hidden = false -- 首充图片本局隐藏状态
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
    for Reward_Index = 1, #L_Enum.Tower_Reward.Reward_Times do
        self:StopTowerRewardCountdownEffect(Reward_Index)
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
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Add(self.OnBuyStarterGiftResult, self)
    UGCCommoditySystem.UGCProductsChangedDelegate:Add(self.RefreshStarterGiftButton, self)
    self.Button_181.OnClicked:Add(self.Button_181_OnClicked, self);
    self.Button_2.OnClicked:Add(self.Button_2_OnClicked, self);
    self.Button_3.OnClicked:Add(self.Button_3_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
    self:RefreshCurrency()
    local Reward_Buttons = {self.Button_5, self.Button_6, self.Button_7, self.Button_8, self.Button_9} -- 五档奖励按钮
    for _, Reward_Button in ipairs(Reward_Buttons) do
        Reward_Button:SetRenderTransformPivot(UGCMathUtility.MakeVector2D(0.5, 0.5))
    end
    self:RefreshTowerRewards()
    self:RefreshStarterGiftButton()
    self.Tower_Reward_UI_Timer = UGCTimerUtility.CreateLuaTimer(1, function()
        self:RefreshTowerRewards()
    end, true)
end

--[[----------------------开始奖励最后三秒提醒------------------------]]
function UI02:StartTowerRewardCountdownEffect(Reward_Index, Reward_Button)
    if self.Reward_Countdown_Effect_State[Reward_Index] then
        return
    end

    self.Reward_Countdown_Effect_State[Reward_Index] = true
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Countdown)
    self.Reward_Countdown_Scale_Tweens[Reward_Index] = UGCTweenSystem.TweenFloatValue(1.0, Countdown_Button_Scale,
        Countdown_Effect_Duration, EEasingType.QuadInOut, function(_, Scale)
            Reward_Button:SetRenderScale(UGCMathUtility.MakeVector2D(Scale, Scale))
        end, UGCTweenSystem.MakeConfig(0, -1, true, 0))
    self.Reward_Countdown_Color_Tweens[Reward_Index] = UGCTweenSystem.TweenColorValue(
        KismetMathLibrary.MakeColor(1, 1, 1, 1), KismetMathLibrary.MakeColor(1, 0, 0, 1), Countdown_Effect_Duration,
        EEasingType.Linear, function(_, Color)
            Reward_Button:SetBackgroundColor(Color)
        end, UGCTweenSystem.MakeConfig(0, -1, true, 0))
end

--[[----------------------停止奖励最后三秒提醒------------------------]]
function UI02:StopTowerRewardCountdownEffect(Reward_Index)
    local Scale_Tween = self.Reward_Countdown_Scale_Tweens[Reward_Index] -- 当前奖励缩放动画
    local Color_Tween = self.Reward_Countdown_Color_Tweens[Reward_Index] -- 当前奖励颜色动画
    if Scale_Tween and UGCTweenSystem.IsTweenValid(Scale_Tween) then
        UGCTweenSystem.KillTween(Scale_Tween)
    end
    if Color_Tween and UGCTweenSystem.IsTweenValid(Color_Tween) then
        UGCTweenSystem.KillTween(Color_Tween)
    end
    self.Reward_Countdown_Effect_State[Reward_Index] = false
    self.Reward_Countdown_Scale_Tweens[Reward_Index] = nil
    self.Reward_Countdown_Color_Tweens[Reward_Index] = nil
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
            self:StopTowerRewardCountdownEffect(Reward_Index)
            self.Reward_Available_State[Reward_Index] = false
            Reward_Buttons[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Texts[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Images[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
            Reward_Red_Dots[Reward_Index]:SetVisibility(ESlateVisibility.Collapsed)
        else
            local Is_Available = Elapsed_Time >= Reward_Time -- 当前档位是否可以领取
            local Remaining_Time = math.max(0, Reward_Time - Elapsed_Time) -- 当前档位剩余秒数
            if not Is_Available and Remaining_Time <= Countdown_Effect_Seconds then
                self:StartTowerRewardCountdownEffect(Reward_Index, Reward_Buttons[Reward_Index])
            else
                self:StopTowerRewardCountdownEffect(Reward_Index)
            end
            if self.Reward_Available_State[Reward_Index] == false and Is_Available then
                SoundMgr.PlaySound2D(SoundMgr.SoundName.Ding)
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
    self.Image_0:SetVisibility(ESlateVisibility.Collapsed)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, true)
    local Week_Card_UI = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI03] -- 周卡页面
    Week_Card_UI:RefreshWeekGiftPurchased(UGCGameSystem.GetLocalPlayerController())
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end
--[[--------------------金币商店--------------------------]] --

function UI02:Button_112_OnClicked()
    self.Image_1:SetVisibility(ESlateVisibility.Collapsed)
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

--[[----------------------根据累计购买记录刷新首充按钮------------------------]]
function UI02:RefreshStarterGiftButton()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Purchased_Times = ShopV2Manager:GetPurchasedTimes(L_Enum.ID_ShopProduct.StarterGift, Player_Controller) -- 首充商品已购买次数
    local Starter_Gift_Visibility = Purchased_Times > 0 and ESlateVisibility.Collapsed or ESlateVisibility.Visible -- 首充入口显示状态
    local Starter_Gift_Image_Visibility = (Purchased_Times > 0 or self.First_Charge_Image_Hidden) and
                                              ESlateVisibility.Collapsed or ESlateVisibility.Visible -- 首充图片显示状态
    self.Button_0:SetVisibility(Starter_Gift_Visibility)
    self.Image_187:SetVisibility(Starter_Gift_Image_Visibility)
end

--[[----------------------首充购买成功后隐藏入口按钮------------------------]]
function UI02:OnBuyStarterGiftResult(bSuccess, PlayerKey, CommodityID, Count, UID, ProductID)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    if not bSuccess or PlayerKey ~= Player_Controller.PlayerKey or CommodityID ~= L_Enum.ID_Gift.StarterGift or
        ProductID ~= L_Enum.ID_ShopProduct.StarterGift then
        return
    end

    self.Button_0:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_187:SetVisibility(ESlateVisibility.Collapsed)
end

--[[---------------------首充-------------------------]] --
function UI02:Button_0_OnClicked()
    self.First_Charge_Image_Hidden = true -- 点击后本局不再显示首充图片
    self.Image_187:SetVisibility(ESlateVisibility.Collapsed)
    local UI_Path = L_Enum.Name_ClassPath.UI06 -- 首充界面路径
    local UI_BP = L_GloTools.UI_Map[UI_Path] -- 已创建的首充界面
    local Is_Opening = UI_BP == nil or not UI_BP:IsVisible() -- 本次是否打开界面
    L_GloTools.UIMgr(UI_Path, true)
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

--[[----------------------点击回城按钮传送到初始点位------------------------]]
function UI02:Button_181_OnClicked()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Tele_To_Point, 1)
    self.Button_181:SetVisibility(ESlateVisibility.Collapsed)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)
end

--[[----------------------申请购买门票并打开界面------------------------]]
function UI02:Button_2_OnClicked()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Buy_Ticket)
end

function UI02:Button_3_OnClicked()

    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, false, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, true, true)
end

-- [Editor Generated Lua] function define End;
--[[--------------------奖杯商店--------------------------]] --

function UI02:Button_113_OnClicked()
    -- 打开奖杯商店
    local UI_Path = L_Enum.Name_ClassPath.UI05 -- 奖杯商店界面路径
    local UI_BP = L_GloTools.UI_Map[UI_Path] -- 已创建的奖杯商店界面
    local Is_Opening = UI_BP == nil or not UI_BP:IsVisible() -- 本次是否打开界面
    L_GloTools.UIMgr(UI_Path, true)
    SoundMgr.PlaySound2D(Is_Opening and SoundMgr.SoundName.UI_Switch or SoundMgr.SoundName.Event_Notice)
end
return UI02
