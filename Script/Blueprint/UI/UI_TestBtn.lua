---@class UI_TestBtn_C:UUserWidget
---@field Button_6 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

local Trophy_Rank_ID = 1 -- 奖杯排行榜ID
local Rank_Pawn_Class_Path = "Asset/Blueprint/Actor/AC_RankPawn.AC_RankPawn_C" -- 排行展示角色类路径

--[[----------------------构造测试按钮界面------------------------]]
function UI_TestBtn:Construct()
    self:LuaInit();

end

--[[----------------------初始化测试按钮事件------------------------]]
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
end

--[[----------------------请求并刷新排行角色展示------------------------]]
function UI_TestBtn:Button_6_OnClicked()
    ugcprint("[UI_TestBtn] 点击刷新排行角色")
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Ranking_List_Manager = UGCGamePartSystem.GetGamePartGlobalActor("RankingListManager") -- 排行榜管理器
    if not UE.IsValid(Player_Controller) or not UE.IsValid(Player_Controller.RankingListComponent) or
        not UE.IsValid(Ranking_List_Manager) then
        return
    end

    if not self.Rank_Data_Delegate_Bound then
        Ranking_List_Manager.ShowRankDataChangeDelegate:Add(self.OnRankDataChanged, self)
        Ranking_List_Manager.ProfileDataChangeDelegate:Add(self.OnProfileDataChanged, self)
        self.Rank_Data_Delegate_Bound = true
        self.Ranking_List_Manager = Ranking_List_Manager
    end

    Player_Controller.RankingListComponent:RequestRankingListDataByRankID(Trophy_Rank_ID, 1, 10, 0)
    self:RefreshRankPawns()
end

--[[----------------------响应排行榜数据变化------------------------]]
function UI_TestBtn:OnRankDataChanged(Rank_ID, Ranking_Cycles)
    if Rank_ID == Trophy_Rank_ID and Ranking_Cycles == 0 then
        self:RefreshRankPawns()
    end
end

--[[----------------------响应排行榜玩家资料变化------------------------]]
function UI_TestBtn:OnProfileDataChanged(Rank_ID)
    if Rank_ID == Trophy_Rank_ID then
        self:RefreshRankPawns()
    end
end

--[[----------------------刷新场景排行角色的名字和头像------------------------]]
function UI_TestBtn:RefreshRankPawns()
    if not UE.IsValid(self.Ranking_List_Manager) then
        return
    end

    local Rank_List_Data = self.Ranking_List_Manager:GetRankListData(Trophy_Rank_ID, 0) -- 当前奖杯榜数据
    local Rank_Pawn_Class = UE.LoadClass(UGCGameSystem.GetUGCResourcesFullPath(Rank_Pawn_Class_Path)) -- 排行展示角色类
    local Rank_Pawns = UGCActorComponentUtility.GetAllActorsOfClass(self, Rank_Pawn_Class) -- 场景排行展示角色
    ugcprint(string.format("[UI_TestBtn] 找到排行角色数量=%d", #Rank_Pawns))

    for _, Rank_Pawn in ipairs(Rank_Pawns) do
        local Rank_Data = Rank_List_Data and Rank_List_Data[Rank_Pawn.Index_Rank] -- 对应名次数据
        local Rank_Widget = Rank_Pawn.Widget:GetUserWidgetObject() -- 角色头顶排行控件
        if Rank_Data and Rank_Widget then
            local Profile_Data = self.Ranking_List_Manager:GetProfileData(Trophy_Rank_ID, Rank_Data.UID) -- 榜单玩家资料
            if Profile_Data and next(Profile_Data) then
                Rank_Widget.TextBlock_0:SetText(Profile_Data.ShowName or Profile_Data.PlayerName or "匿名玩家")
                Rank_Pawn.Widget:RequestRedraw()
                Rank_Widget.UI_Head.HeadImage:SetVisibility(ESlateVisibility.Collapsed)
                Rank_Widget.UI_Head.Avatar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                Rank_Widget.UI_Head.Avatar:InitView(2, Profile_Data.UID, Profile_Data.PicUrl, nil, nil, nil, true, false)
            else
                Rank_Widget.TextBlock_0:SetText("玩家 UID: " .. tostring(Rank_Data.UID))
                Rank_Pawn.Widget:RequestRedraw()
                Rank_Widget.UI_Head.HeadImage:SetVisibility(ESlateVisibility.Collapsed)
                Rank_Widget.UI_Head.Avatar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                Rank_Widget.UI_Head.Avatar:InitView(2, Rank_Data.UID, "", nil, nil, nil, true, false)
            end
            Rank_Pawn.Widget:RequestRedraw()
            ugcprint(string.format("[UI_TestBtn] 已刷新名次=%d UID=%s", Rank_Pawn.Index_Rank,
                tostring(Rank_Data.UID)))
        end
    end
end

--[[----------------------清理排行榜回调------------------------]]
function UI_TestBtn:Destruct()
    if self.Rank_Data_Delegate_Bound and UE.IsValid(self.Ranking_List_Manager) then
        self.Ranking_List_Manager.ShowRankDataChangeDelegate:Remove(self.OnRankDataChanged, self)
        self.Ranking_List_Manager.ProfileDataChangeDelegate:Remove(self.OnProfileDataChanged, self)
        self.Rank_Data_Delegate_Bound = false
    end
end

return UI_TestBtn
