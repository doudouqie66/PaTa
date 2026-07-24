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
local UGCGameState = {
    Room_Pass = 0
};

--[[----------------------注册客户端可调用的服务端RPC------------------------]]
function UGCGameState:GetAvailableServerRPCs()
    return L_Enum.Name_RPC.Men_State

end

--[[----------------------声明房间同步属性------------------------]]
function UGCGameState:GetReplicatedProperties()
    return {"Room_Pass", "Lazy"}
end
--[[----------------------游戏状态开始时初始化------------------------]]
function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
    self:InitUI()
end

--[[--------------------改变门状态--------------------------]] --
function UGCGameState:Men_State(Can_Enter, From_Multicast)
    if self:HasAuthority() and not From_Multicast then
        for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men")) do
            Actor:SetActorEnableCollision(not Can_Enter)
        end

        UnrealNetwork.CallUnrealRPC_Multicast(self, L_Enum.Name_RPC.Men_State, Can_Enter, true)
        return
    end

    local Material_Path = Can_Enter and L_Enum.Name_Material.Men_CanEnter or L_Enum.Name_Material.Men_YuanLai -- 门材质路径
    local Material = UE.LoadObject(Material_Path) -- 加载门材质
    for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men")) do
        Actor:SetActorEnableCollision(not Can_Enter)
        Actor.StaticMeshComponent:SetMaterial(0, Material)
    end

    if not self:HasAuthority() then
        for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men_Head_Body")) do
            if Can_Enter then
                Actor:StartCountdown()
            else
                Actor:StopCountdown()
            end
        end
    end
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
