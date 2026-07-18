---@class MainUI_C:UUserWidget
---@field Button_87 UButton
---@field Button_263 UButton
---@field Button_381 UButton
---@field ShopV2_OpenShopButton_UIBP ShopV2_OpenShopButton_UIBP_C
---@field TestButton TestButton_C
---@field TextBlock_73 UTextBlock
---@field WBP_RankingListBtn WBP_RankingListBtn_C
---@field WBP_TaskMainUIButton WBP_TaskMainUIButton_C
--Edit Below--
---@class MainUI_C:UUserWidget
---@field Button_87 UButton
---@field Button_263 UButton
---@field Button_381 UButton
---@field TextBlock_73 UTextBlock
-- Edit Below--
local MainUI = {
    bInitDoOnce = false
}

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

    self.Button_87.OnClicked:Add(self.Button_87_OnClicked, self);
    self.Button_263.OnClicked:Add(self.Button_263_OnClicked, self);
    self.Button_381.OnClicked:Add(self.Button_381_OnClicked, self);

    self:DisableUnUse()

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

function MainUI:Button_87_OnClicked()
    L_TipsTool.ShowTips_01("6666")
end

function MainUI:Button_263_OnClicked()
    L_TipsTool.ShowOfficialTips("测试哈哈")
end

function MainUI:Button_381_OnClicked()
    --[[-------------------测试等级加1---------------------------]] --
    local PC = UGCGameSystem.GetLocalPlayerController()
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.AddLevel, 1)
end

--[[----------------------刷新玩家等级显示------------------------]]
function MainUI:RefreshPlayerGameLevel(PlayerGameLevel)
    self.TextBlock_73:SetText(tostring(PlayerGameLevel))
end

-- [Editor Generated Lua] function define End;

return MainUI
