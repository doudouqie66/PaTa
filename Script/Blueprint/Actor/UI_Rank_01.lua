---@class UI_Rank_01_C:AActor
---@field Widget UWidgetComponent
---@field DefaultSceneRoot USceneComponent
---@field Name FString
--Edit Below--
local UI_Rank_01 = {}

local Tower_Climb_Rank_ID = 2 -- 最短爬塔时间排行榜ID
local Tower_Climb_Rank_Count = 10 -- 看板显示名次数量
local Tower_Climb_Rank_Refresh_Interval = 60 -- 排行榜请求间隔秒数
local Tower_Climb_Rank_Check_Interval = 5 -- 排行榜初始化检查间隔秒数

--[[----------------------初始化最短爬塔时间排行榜------------------------]]
function UI_Rank_01:ReceiveBeginPlay()
    UI_Rank_01.SuperClass.ReceiveBeginPlay(self)

    if self:HasAuthority() then
        return
    end

    self:RefreshTowerClimbRank()
    self.Tower_Climb_Rank_Timer = Timer.InsertTimer(
        Tower_Climb_Rank_Check_Interval,
        function()
            self:RefreshTowerClimbRank()
        end,
        true,
        "TowerClimbRankRefresh",
        0
    )
end

--[[----------------------请求并刷新最短爬塔时间排行榜------------------------]]
function UI_Rank_01:RefreshTowerClimbRank()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    if not UE.IsValid(Player_Controller) or not UE.IsValid(Player_Controller.RankingListComponent) then
        return
    end

    local Ranking_List_Manager = UGCGamePartSystem.GetGamePartGlobalActor("RankingListManager") -- 排行榜管理器
    if not UE.IsValid(Ranking_List_Manager) then
        return
    end

    if not self.Rank_Data_Delegate_Bound then
        Ranking_List_Manager.ShowRankDataChangeDelegate:Add(self.OnTowerClimbRankChanged, self)
        self.Rank_Data_Delegate_Bound = true
        self.Ranking_List_Manager = Ranking_List_Manager
    end

    local Current_Time = UGCGameSystem.GetServerTimeSec() -- 当前服务器时间
    if not self.Last_Rank_Request_Time or Current_Time - self.Last_Rank_Request_Time >= Tower_Climb_Rank_Refresh_Interval then
        Player_Controller.RankingListComponent:RequestRankingListDataByRankID(
            Tower_Climb_Rank_ID,
            1,
            Tower_Climb_Rank_Count,
            0
        )
        self.Last_Rank_Request_Time = Current_Time
    end
    self:ShowTowerClimbRank()
end

--[[----------------------响应最短爬塔排行榜数据变化------------------------]]
function UI_Rank_01:OnTowerClimbRankChanged(Rank_ID, Ranking_Cycles)
    if Rank_ID == Tower_Climb_Rank_ID and Ranking_Cycles == 0 then
        self:ShowTowerClimbRank()
    end
end

--[[----------------------显示最短爬塔时间排行榜------------------------]]
function UI_Rank_01:ShowTowerClimbRank()
    local Rank_Widget = self.Widget:GetUserWidgetObject() -- 排行榜控件
    if not Rank_Widget or not UE.IsValid(self.Ranking_List_Manager) then
        return
    end

    local Rank_List_Data = self.Ranking_List_Manager:GetRankListData(Tower_Climb_Rank_ID, 0) -- 当前榜单数据
    Rank_Widget:RefreshRankingList(Rank_List_Data, self.Ranking_List_Manager, Tower_Climb_Rank_ID)
end

--[[----------------------清理排行榜回调与计时器------------------------]]
function UI_Rank_01:ReceiveEndPlay()
    if self.Tower_Climb_Rank_Timer then
        Timer.RemoveTimer(self.Tower_Climb_Rank_Timer)
        self.Tower_Climb_Rank_Timer = nil
    end

    if self.Rank_Data_Delegate_Bound and UE.IsValid(self.Ranking_List_Manager) then
        self.Ranking_List_Manager.ShowRankDataChangeDelegate:Remove(self.OnTowerClimbRankChanged, self)
        self.Rank_Data_Delegate_Bound = false
    end

    UI_Rank_01.SuperClass.ReceiveEndPlay(self)
end

--[[
function UI_Rank_01:GetReplicatedProperties()
    return
end
--]]

--[[
function UI_Rank_01:GetAvailableServerRPCs()
    return
end
--]]

return UI_Rank_01
