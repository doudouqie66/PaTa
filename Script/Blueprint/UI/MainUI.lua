---@class MainUI_C:UUserWidget
---@field Button_87 UButton
---@field Button_263 UButton
---@field Button_381 UButton
---@field EditorUtilityEditableTextBox_36 UEditorUtilityEditableTextBox
---@field ShopV2_OpenShopButton_UIBP ShopV2_OpenShopButton_UIBP_C
---@field TextBlock_73 UTextBlock
---@field TextBlock_134 UTextBlock
--Edit Below--
---@class MainUI_C:UUserWidget
---@field Button_87 UButton
---@field Button_263 UButton
---@field Button_381 UButton
---@field EditorUtilityEditableTextBox_36 UEditorUtilityEditableTextBox
---@field ShopV2_OpenShopButton_UIBP ShopV2_OpenShopButton_UIBP_C
---@field TextBlock_73 UTextBlock
---@field TextBlock_134 UTextBlock
-- Edit Below--
local MainUI = {
    bInitDoOnce = false
}

local Fly_Vertical_Input_Scale = 0.3 -- 飞行升降速度比例

function MainUI:Construct()
    self:LuaInit();
    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC then
        self:RefreshPlayerGameLevel(PC.PlayerGameLevel)
    end

end

function MainUI:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;

    self.Button_87.OnPressed:Add(self.Button_87_OnPressed, self);
    self.Button_87.OnReleased:Add(self.Button_87_OnReleased, self);
    self.Button_263.OnPressed:Add(self.Button_263_OnPressed, self);
    self.Button_263.OnReleased:Add(self.Button_263_OnReleased, self);
    self.Button_381.OnClicked:Add(self.Button_381_OnClicked, self);
    self.EditorUtilityEditableTextBox_36.OnTextCommitted:Add(self.EditorUtilityEditableTextBox_36_OnTextCommitted, self);

    self:SetFlyControlsEnabled(false)

    self:DisableUnUse()
    self:TestInit()
end

--[[----------------------刷新事件秒数显示------------------------]]
function MainUI:Tick(MyGeometry, InDeltaTime)
    local GameState = UGCGameSystem.GameState
    self.TextBlock_134:SetText(tostring(GameState.EventElapsed or 0))
    if self.Fly_Vertical_Input_Value ~= 0 then
        UGCGameSystem.GetLocalPlayerPawn():AddMovementInput(Vector.New(0, 0, 1),
            self.Fly_Vertical_Input_Value, false)
    end
end

--[[---------------------关闭无用UI-------------------------]] --
function MainUI:DisableUnUse()
    local MainUI = UGCWidgetManagerSystem.GetMainControlUI()
    MainUI.NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
    MainUI.Image_0:SetVisibility(ESlateVisibility.Collapsed)
    MainUI.CanvasPanel_MiniMapAndSetting:SetVisibility(ESlateVisibility.Collapsed)

    --[[-------------------打开充值入口---------------------------]] --
    -- 显示并获取界面对象实例
    UGCCommoditySystem.ShowRechargeEntryUI():Then(function(Result)
        local UI = Result:Get()
        -- UI:SetVisibility()
    end)

end

--[[--------------------测试--------------------------]] --
function MainUI:TestInit()
    local RankListBtnClass = UE.LoadClass(UGCMapInfoLib.GetRootLongPackagePath() ..
                                              "ExtendResource/RankingList/OfficialPackage/Asset/RankingList/Blueprint/WBP_RankingListBtn.WBP_RankingListBtn_C");
    local PlayerController = STExtraGameplayStatics.GetFirstPlayerController(self);
    local RankListBtn = UserWidget.NewWidgetObjectBP(PlayerController, RankListBtnClass);
    RankListBtn:AddToViewport(1000);
end

--[[----------------------设置飞行控制按钮显示状态------------------------]]
function MainUI:SetFlyControlsEnabled(Is_Enabled)
    local Fly_Button_Visibility = Is_Enabled and ESlateVisibility.Visible or ESlateVisibility.Collapsed -- 飞行按钮显示状态
    self.Button_87:SetIsEnabled(Is_Enabled)
    self.Button_263:SetIsEnabled(Is_Enabled)
    self.Button_87:SetVisibility(Fly_Button_Visibility)
    self.Button_263:SetVisibility(Fly_Button_Visibility)
    self.Fly_Vertical_Input_Value = 0 -- 竖直飞行输入值
end

--[[----------------------按下上升按钮------------------------]]
function MainUI:Button_87_OnPressed()
    self.Fly_Vertical_Input_Value = Fly_Vertical_Input_Scale
end

--[[----------------------松开上升按钮------------------------]]
function MainUI:Button_87_OnReleased()
    if self.Fly_Vertical_Input_Value > 0 then
        self.Fly_Vertical_Input_Value = 0
    end
end

--[[----------------------按下下降按钮------------------------]]
function MainUI:Button_263_OnPressed()
    self.Fly_Vertical_Input_Value = -Fly_Vertical_Input_Scale
end

--[[----------------------松开下降按钮------------------------]]
function MainUI:Button_263_OnReleased()
    if self.Fly_Vertical_Input_Value < 0 then
        self.Fly_Vertical_Input_Value = 0
    end
end

--[[----------------------切换关注界面显示状态------------------------]]
function MainUI:Button_381_OnClicked()
    --[[-------------------测试兑换码---------------------------]] --
    -- local PC = UGCGameSystem.GetLocalPlayerController()
    -- UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.UseRedemptionCode, "XXXX-XXXX-XXXX")
    --[[-------------------测试UImgr---------------------------]] --
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_Attention)

end

--[[----------------------输入完成后提交兑换码------------------------]]
function MainUI:EditorUtilityEditableTextBox_36_OnTextCommitted(Text, CommitMethod)
    local PC = UGCGameSystem.GetLocalPlayerController()
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.UseRedemptionCode, tostring(Text))
end

--[[----------------------刷新玩家等级显示------------------------]]
function MainUI:RefreshPlayerGameLevel(PlayerGameLevel)
    self.TextBlock_73:SetText(tostring(PlayerGameLevel))
end

-- [Editor Generated Lua] function define End;

return MainUI
