---@class UGCGameState_C:BP_UGCGameState_C
---@field EventElapsed int32
---@field Reward_End_Time float
--Edit Below--
--[[----------------------全局提前引用------------------------]] --
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')
UGCGameSystem.UGCRequire('Script.L_Com.SoundMgr')
UGCGameSystem.UGCRequire('Script.L_Com.L_TipsTool')
UGCGameSystem.UGCRequire('Script.L_Com.TipsMgr')
UGCGameSystem.UGCRequire('Script.L_Com.L_GloTools')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventConfig')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventScheduler')
UGCGameSystem.UGCRequire('Script.Blueprint.Event.EventConfig_BackUp')
UGCGameSystem.UGCRequire("ExtendResource.GiftPack.OfficialPackage.Script.GiftPack.GiftPackManager")
UGCGameSystem.UGCRequire("ExtendResource.SignInEvent.OfficialPackage.Script.SignInEvent.SignInEventManager")
UGCGameSystem.UGCRequire("ExtendResource.RankingList.OfficialPackage.Script.RankingList.RankingListManager")
UGCGameSystem.UGCRequire("ExtendResource.ShopV2.OfficialPackage.Script.ShopV2.ShopV2Manager")
UGCGameSystem.UGCRequire('Script.L_Com.Config_SL.CFG_SL')
local UGCGameState = {
    Room_Pass = 0,
    Reward_End_Time = 0 -- 礼包可再次领取的服务器时间
};

local Trophy_Rank_ID = 1 -- 奖杯排行榜ID
local Max_Rank_Pawn_Count = 60 -- 最大排行角色数量
local Rank_BP_Init_Check_Interval = 1 -- 排行角色初始化检查间隔秒数
local Rank_BP_Collect_Check_Interval = 1 -- 排行角色同步检查间隔秒数
local Virtual_Item_Get_UI_Class_Path = "Asset/Blueprint/UI/UGC_Get_UIBP.UGC_Get_UIBP_C" -- 自定义获得物品界面路径

--[[----------------------注册客户端可调用的服务端RPC------------------------]]
function UGCGameState:GetAvailableServerRPCs()
    return L_Enum.Name_RPC.Men_State

end

--[[----------------------声明房间同步属性------------------------]]
function UGCGameState:GetReplicatedProperties()
    return {"Room_Pass", "Lazy"}, {"Reward_End_Time", "Lazy"}
end
--[[----------------------游戏状态开始时初始化------------------------]]
function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
    self:InitUI()

    if not self:InitVirtualItemGetUI() then
        self.Virtual_Item_UI_Listener_ID = UGCGenericMessageSystem.ListenGlobalMessage(self,
            UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded, self, self.OnGamePartLoaded)
    end

    -- if not self:InitRankBP() then
    --     self.Rank_BP_Init_Timer = Timer.InsertTimer(Rank_BP_Init_Check_Interval, function()
    --         if self:InitRankBP() then
    --             Timer.RemoveTimer(self.Rank_BP_Init_Timer)
    --             self.Rank_BP_Init_Timer = nil
    --         end
    --     end, true, "RankBPInit", 0)
    -- end
end

--[[----------------------替换获得物品默认界面------------------------]]
function UGCGameState:InitVirtualItemGetUI()
    if self:HasAuthority() then
        return true
    end

    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not UE.IsValid(Virtual_Item_Manager) then
        return false
    end

    local Get_Item_UI_Class_Path = Virtual_Item_Manager.GetItemUIClassPath -- 获得物品界面软类路径
    Get_Item_UI_Class_Path.AssetPathName = UGCGameSystem.GetUGCResourcesFullPath(Virtual_Item_Get_UI_Class_Path)
    Get_Item_UI_Class_Path.SubPathString = ""
    Virtual_Item_Manager.GetItemUIClassPath = Get_Item_UI_Class_Path
    return true
end

--[[----------------------响应功能模块加载完成------------------------]]
function UGCGameState:OnGamePartLoaded(GamePart_Name)
    if GamePart_Name ~= "VirtualItemManager" or not self:InitVirtualItemGetUI() then
        return
    end

    UGCGenericMessageSystem.UnListenMessage(self.Virtual_Item_UI_Listener_ID,
        UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded)
    self.Virtual_Item_UI_Listener_ID = nil
end

--[[----------------------初始化排行榜角色------------------------]]
function UGCGameState:InitRankBP()
    if self:HasAuthority() then
        return self:InitRankBPServer()
    end

    return self:InitRankBPClient()
end

--[[----------------------服务端初始化排行榜角色------------------------]]
function UGCGameState:InitRankBPServer()
    local Spawn_Points = UGCActorComponentUtility.GetAllActorsWithTag(self, "Point_RankBP") -- 排行角色点位
    if #Spawn_Points == 0 then
        return false
    end

    table.sort(Spawn_Points, function(Point_A, Point_B)
        return Point_A.ID_PointSpawn < Point_B.ID_PointSpawn
    end)

    self.Rank_Spawn_Points = Spawn_Points
    self.Rank_Pawn_By_ID = {}
    self:SpawnRankPawns()
    return true
end

--[[----------------------客户端初始化排行榜展示------------------------]]
function UGCGameState:InitRankBPClient()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Ranking_List_Manager = UGCGamePartSystem.GetGamePartGlobalActor("RankingListManager") -- 排行榜管理器

    if not UE.IsValid(Player_Controller) or not UE.IsValid(Player_Controller.RankingListComponent) or
        not UE.IsValid(Ranking_List_Manager) then
        return false
    end

    local Spawn_Points = UGCActorComponentUtility.GetAllActorsWithTag(self, "Point_RankBP") -- 排行角色点位
    if #Spawn_Points == 0 then
        return false
    end

    self.Rank_Pawn_By_ID = {}
    self.Rank_Spawn_Count = math.min(#Spawn_Points, Max_Rank_Pawn_Count)
    self.Ranking_List_Manager = Ranking_List_Manager

    Ranking_List_Manager.ShowRankDataChangeDelegate:Add(self.OnTrophyRankDataChanged, self)
    Ranking_List_Manager.ProfileDataChangeDelegate:Add(self.OnTrophyProfileDataChanged, self)
    self.Rank_Data_Delegate_Bound = true

    if self.Rank_Spawn_Count > 0 then
        Player_Controller.RankingListComponent:RequestRankingListDataByRankID(Trophy_Rank_ID, 1, self.Rank_Spawn_Count,
            0)
    end

    if self:CollectRankPawns() < self.Rank_Spawn_Count then
        self.Rank_BP_Collect_Timer = Timer.InsertTimer(Rank_BP_Collect_Check_Interval, function()
            local Collected_Count = self:CollectRankPawns() -- 已同步排行角色数量
            self:RefreshRankPawnProfiles()

            if Collected_Count >= self.Rank_Spawn_Count then
                Timer.RemoveTimer(self.Rank_BP_Collect_Timer)
                self.Rank_BP_Collect_Timer = nil
            end
        end, true, "RankBPCollect", 0)
    end

    self:RefreshRankPawnProfiles()
    return true
end

--[[----------------------响应奖杯排行榜数据变化------------------------]]
function UGCGameState:OnTrophyRankDataChanged(Rank_ID, Ranking_Cycles)
    if Rank_ID == Trophy_Rank_ID and Ranking_Cycles == 0 then
        self:RefreshRankPawnProfiles()
    end
end

--[[----------------------响应排行榜玩家资料变化------------------------]]
function UGCGameState:OnTrophyProfileDataChanged(Rank_ID)
    if Rank_ID == Trophy_Rank_ID then
        self:RefreshRankPawnProfiles()
    end
end

--[[----------------------在排行榜点位生成展示角色------------------------]]
function UGCGameState:SpawnRankPawns()
    if not self:HasAuthority() then
        return
    end

    local Rank_Pawn_Class = UGCObjectUtility.LoadClass(L_Enum.Path_RankBP.BP_Rank_01) -- 排行角色类

    for Spawn_Order, Spawn_Point in ipairs(self.Rank_Spawn_Points) do
        if Spawn_Order > Max_Rank_Pawn_Count then
            break
        end

        local Rank_Index = Spawn_Point.ID_PointSpawn -- 点位对应名次

        if not self.Rank_Pawn_By_ID[Rank_Index] then
            local Rank_Pawn = UGCGenericCharacterSystem.SpawnGenericCharacter(self, Rank_Pawn_Class,
                Spawn_Point:K2_GetActorLocation(), Spawn_Point.Arrow:K2_GetComponentRotation()) -- 排行榜怪物

            if Rank_Pawn then
                Rank_Pawn.Rank_Index = Rank_Index
                Rank_Pawn:K2_SetActorLocation(Spawn_Point:K2_GetActorLocation())
                self.Rank_Pawn_By_ID[Rank_Index] = Rank_Pawn
            end
        end
    end
end

--[[----------------------收集服务端同步的排行角色------------------------]]
function UGCGameState:CollectRankPawns()
    local Rank_Pawn_Class = UGCObjectUtility.LoadClass(L_Enum.Path_RankBP.BP_Rank_01) -- 排行角色类
    local Rank_Pawns = UGCActorComponentUtility.GetAllActorsOfClass(self, Rank_Pawn_Class) -- 已同步排行角色
    local Collected_Count = 0 -- 已收集角色数量

    for _, Rank_Pawn in ipairs(Rank_Pawns) do
        if Rank_Pawn.Rank_Index and Rank_Pawn.Rank_Index > 0 then
            self.Rank_Pawn_By_ID[Rank_Pawn.Rank_Index] = Rank_Pawn
        end
    end

    for _ in pairs(self.Rank_Pawn_By_ID) do
        Collected_Count = Collected_Count + 1
    end

    return Collected_Count
end

--[[----------------------刷新排行角色名字和头像------------------------]]
function UGCGameState:RefreshRankPawnProfiles()
    if not UE.IsValid(self.Ranking_List_Manager) then
        return
    end

    local Rank_List_Data = self.Ranking_List_Manager:GetRankListData(Trophy_Rank_ID, 0) or {} -- 奖杯排行榜数据

    for Rank_Index, Rank_Pawn in pairs(self.Rank_Pawn_By_ID) do
        local Rank_Data = Rank_List_Data[Rank_Index] -- 当前名次数据
        local Profile_Data = nil -- 当前玩家资料

        if Rank_Data then
            Profile_Data = self.Ranking_List_Manager:GetProfileData(Trophy_Rank_ID, Rank_Data.UID)
        end

        if UE.IsValid(Rank_Pawn) then
            Rank_Pawn:RefreshRankDisplay(Rank_Data, Profile_Data)
        end
    end
end

--[[----------------------清理排行榜角色展示回调------------------------]]
function UGCGameState:ReceiveEndPlay()
    if self.Virtual_Item_UI_Listener_ID then
        UGCGenericMessageSystem.UnListenMessage(self.Virtual_Item_UI_Listener_ID,
            UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded)
        self.Virtual_Item_UI_Listener_ID = nil
    end

    if self.Rank_BP_Init_Timer then
        Timer.RemoveTimer(self.Rank_BP_Init_Timer)
        self.Rank_BP_Init_Timer = nil
    end

    if self.Rank_BP_Collect_Timer then
        Timer.RemoveTimer(self.Rank_BP_Collect_Timer)
        self.Rank_BP_Collect_Timer = nil
    end

    if self.Rank_Data_Delegate_Bound and UE.IsValid(self.Ranking_List_Manager) then
        self.Ranking_List_Manager.ShowRankDataChangeDelegate:Remove(self.OnTrophyRankDataChanged, self)
        self.Ranking_List_Manager.ProfileDataChangeDelegate:Remove(self.OnTrophyProfileDataChanged, self)
        self.Rank_Data_Delegate_Bound = false
    end

    UGCGameState.SuperClass.ReceiveEndPlay(self)
end

--[[--------------------改变门状态--------------------------]] --
function UGCGameState:Men_State(Can_Enter, From_Multicast, Open_Player_Name)
    if self:HasAuthority() and not From_Multicast then
        for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men")) do
            Actor:SetActorEnableCollision(not Can_Enter)
        end

        UnrealNetwork.CallUnrealRPC_Multicast(self, L_Enum.Name_RPC.Men_State, Can_Enter, true, Open_Player_Name)
        return
    end

    local Material_Path = Can_Enter and L_Enum.Name_Material.Men_CanEnter or L_Enum.Name_Material.Men_YuanLai -- 门材质路径
    local Material = UE.LoadObject(Material_Path) -- 加载门材质
    for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men")) do
        Actor:SetActorEnableCollision(not Can_Enter)
        Actor.StaticMeshComponent:SetMaterial(0, Material)
    end

    if not self:HasAuthority() then
        if Can_Enter and Open_Player_Name then
            L_TipsTool.ShowTips_01(Open_Player_Name .. "打开了密道")
        end

        for _, Actor in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(self, "Men_Head_Body")) do
            if Can_Enter then
                Actor:StartCountdown()
            else
                Actor:StopCountdown()
            end
        end
    end
end

--[[----------------------广播播放或停止玩家蒙太奇------------------------]]
function UGCGameState:MulticastRPC_SetAnimMontage(Player_Key, Anim_Montage_Path, Is_Playing, Play_Rate,
    Start_Section_Name)
    if self:HasAuthority() then
        return
    end

    local Player_Pawn = UGCGameSystem.GetPlayerPawnByPlayerKey(Player_Key) -- 播放动画的玩家
    L_GloTools.SetPawnAnimMontage(Player_Pawn, Anim_Montage_Path, Is_Playing, Play_Rate, Start_Section_Name)
end

--[[----------------------向所有玩家显示小提示------------------------]]
function UGCGameState:MulticastRPC_ShowTips(text, Sound_Name)
    if self:HasAuthority() then
        return
    end

    L_TipsTool.ShowTips_01(text, nil, Sound_Name)
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
        L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_TestBtn, true)

    end

    local MainUI = UGCWidgetManagerSystem.GetMainControlUI()
    if MainUI then
        MainUI.NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
        MainUI.Image_0:SetVisibility(ESlateVisibility.Collapsed)
        MainUI.CanvasPanel_MiniMapAndSetting:SetVisibility(ESlateVisibility.Collapsed)
    end

end
return UGCGameState;
