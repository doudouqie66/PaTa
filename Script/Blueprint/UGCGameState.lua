---@class UGCGameState_C:BP_UGCGameState_C
---@field EventElapsed int32
-- Edit Below--
---@class UGCGameState_C:BP_UGCGameState_C
-- Edit Below--
--[[----------------------全局提前引用------------------------]] --
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')
UGCGameSystem.UGCRequire('Script.L_Com.L_TipsTool')
UGCGameSystem.UGCRequire('Script.L_Com.TipsMgr')
UGCGameSystem.UGCRequire('Script.L_Com.L_GloTools')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventConfig')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventScheduler')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventConfig_BackUp')
UGCGameSystem.UGCRequire("ExtendResource.GiftPack.OfficialPackage.Script.GiftPack.GiftPackManager")
UGCGameSystem.UGCRequire("ExtendResource.SignInEvent.OfficialPackage.Script.SignInEvent.SignInEventManager")
UGCGameSystem.UGCRequire("ExtendResource.RankingList.OfficialPackage.Script.RankingList.RankingListManager")
local UGCGameState = {};
--[[----------------------游戏状态开始时初始化------------------------]]
function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
    self:InitUI()
end

--[[----------------------初始化界面------------------------]]
function UGCGameState:InitUI()
    if self:HasAuthority() == true then
        -- 只有客户端加载UI
    else
        -- local UI01 = UE.LoadClass(L_Enum.Name_ClassPath.UI01);
        -- local PlayerController = UGCGameSystem.GetLocalPlayerController()
        -- local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, UI01);
        -- PlayerController.MainUI_BP = MainUI_BP;
        -- MainUI_BP:AddToViewport();
        L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI01, true)

    end

    local MainUI = UGCWidgetManagerSystem.GetMainControlUI()
    if MainUI then
        MainUI.NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
        MainUI.Image_0:SetVisibility(ESlateVisibility.Collapsed)

        MainUI.CanvasPanel_MiniMapAndSetting:SetVisibility(ESlateVisibility.Collapsed)

    end

end
return UGCGameState;
