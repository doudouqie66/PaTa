---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {};
local Max_Room_Player_Count = 10 -- 房间最大玩家数量
local Max_Room_Team_Count = 10 -- 房间最大队伍数量
local Backfill_Refresh_Delay = 5 -- 补人刷新延迟
local Room_Only_Item_ID = 8310033 -- 仅限当前房间使用的物品ID
local Room_Mode_A_ID = 1001 -- 挂机房A模式ID
local Room_Mode_B_ID = 1002 -- 挂机房B模式ID
local Room_Rotate_Start_Time = 20 * 60 -- 剩余二十分钟开始换房
local Room_Rotate_Save_Time = 5 * 60 -- 剩余五分钟再次保存
local Room_Force_Exit_Time = 60 -- 剩余一分钟强制结束旧房
local Room_Force_Exit_Delay = 3 -- 通知客户端退出后的关房延迟
local Room_Short_Test_Enabled = false -- 是否启用五分钟换房测试
local Room_Short_Test_Total_Time = 5 * 60 -- 测试房间总时长
local Room_Short_Test_Rotate_Remain_Time = 60 -- 测试房间剩余一分钟开始换房
local Room_Short_Test_Retry_Remain_Time = 30 -- 测试房间剩余三十秒重试换房
local Week_Time_Ver = 1 -- 周卡时间版本
local Legacy_Week_Time_Offset = 8 * 60 * 60 -- 旧周卡时间偏移秒数
UGCGameMode.Backfill_Request_Pending = false -- 是否存在补人请求
UGCGameMode.Backfill_Match_Callback_Seen = false -- 是否收到补人成功回调
UGCGameMode.Backfill_Login_Serial = 0 -- 玩家登录序号
UGCGameMode.Backfill_Login_Serial_At_Request = 0 -- 申请补人时的登录序号
UGCGameMode.Backfill_Refresh_Scheduled = false -- 是否已安排补人刷新
UGCGameMode.Assigned_Team_By_Player = {} -- 玩家对应的玩法队伍
UGCGameMode.Camp_By_Team = {} -- 玩法队伍对应的阵营
UGCGameMode.Room_Lottery_Claimed_UIDs = {} -- 当前房间已经抽奖的玩家UID集合
UGCGameMode.Room_Is_Rotating = false -- 当前房间是否正在换房
UGCGameMode.Room_Rotate_Target_Mode_ID = 0 -- 本次换房目标模式ID
UGCGameMode.Room_Force_Exit_Started = false -- 是否已经执行旧房退出兜底

--[[----------------------游戏启动------------------------]] --
function UGCGameMode:ReceiveBeginPlay()
    if self:HasAuthority() then

        EventScheduler.Start()
        -- 生成随机密码
        self:GenerateRoomPass()
        self.Backfill_Request_Pending = false
        self.Backfill_Match_Callback_Seen = false
        self.Backfill_Login_Serial = 0
        self.Backfill_Login_Serial_At_Request = 0
        self.Backfill_Refresh_Scheduled = false
        self.Assigned_Team_By_Player = {}
        self.Camp_By_Team = {}
        self.Room_Lottery_Claimed_UIDs = {}
        self.Room_Is_Rotating = false
        self.Room_Rotate_Target_Mode_ID = 0
        self.Room_Force_Exit_Started = false
        UGCCampSystem.SetDefaultCampRelation(ECampRelation.Enemy)
        UGCGameSystem.ApplyPlayerJoinSucceededDelegate:Add(self.OnPlayerJoinSucceeded, self)
        UGCGameSystem.OpenPlayerJoin()
        if Room_Short_Test_Enabled then
            local Room_Rotate_Delegate = ObjectExtend.CreateDelegate(self, function()
                self:BeginRoomRotate()
            end) -- 测试换房代理
            KismetSystemLibrary.K2_SetTimerDelegateForLua(Room_Rotate_Delegate, self,
                Room_Short_Test_Total_Time - Room_Short_Test_Rotate_Remain_Time, false)

            local Room_Retry_Delegate = ObjectExtend.CreateDelegate(self, function()
                self:RetryRoomRotate()
            end) -- 测试重试代理
            KismetSystemLibrary.K2_SetTimerDelegateForLua(Room_Retry_Delegate, self,
                Room_Short_Test_Total_Time - Room_Short_Test_Retry_Remain_Time, false)

            local Room_Exit_Delegate = ObjectExtend.CreateDelegate(self, function()
                self:ForceExitOldRoom()
            end) -- 测试退出代理
            KismetSystemLibrary.K2_SetTimerDelegateForLua(Room_Exit_Delegate, self, Room_Short_Test_Total_Time, false)
        else
            UGCGameSystem.SetDSCloseNotify({Room_Rotate_Start_Time, Room_Rotate_Save_Time, Room_Force_Exit_Time})
            self.Room_DS_Close_Listener_ID = UGCGenericMessageSystem.ListenGlobalMessage(self.GameState,
                UGCGenericMessageSystem.UserDefinedMessages.UGC.UGCDSShutDownManager.DSCloseNotify, self,
                self.OnDSCloseNotify)
        end
    end

end

--[[----------------------获取本次换房目标模式------------------------]]
function UGCGameMode:GetRoomRotateTargetModeID()
    local Current_Mode_ID = UGCMultiMode.GetModeID() -- 当前子模式ID
    if Current_Mode_ID == Room_Mode_A_ID then
        return Room_Mode_B_ID
    end
    if Current_Mode_ID == Room_Mode_B_ID then
        return Room_Mode_A_ID
    end
    return 0
end

--[[----------------------判断玩家是否负责发起队伍换房------------------------]]
function UGCGameMode:IsRoomRotateLeader(PlayerController)
    local Lobby_Teammate_Keys = UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(PlayerController.PlayerKey) or {} -- 大厅队友Key列表
    if UGCTeamSystem.GetIsLeaderOrNotByPlayerKey(PlayerController.PlayerKey) then
        return true
    end
    for _, Lobby_Teammate_Key in ipairs(Lobby_Teammate_Keys) do
        if tostring(Lobby_Teammate_Key) ~= tostring(PlayerController.PlayerKey) then
            return false
        end
    end
    return true
end

--[[----------------------保存当前房间全部玩家------------------------]]
function UGCGameMode:SaveAllRoomPlayers()
    for _, PlayerController in ipairs(UGCGameSystem.GetAllPlayerController(false)) do
        self:SavePlayerArchive(PlayerController)
    end
end

--[[----------------------通知玩家准备自动换房------------------------]]
function UGCGameMode:PreparePlayerRoomRotate(PlayerController)
    if self.Room_Rotate_Target_Mode_ID <= 0 then
        return
    end
    UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Prepare_Room_Rotate,
        self.Room_Rotate_Target_Mode_ID, self:IsRoomRotateLeader(PlayerController))
end

--[[----------------------开始关闭旧房并自动匹配新房------------------------]]
function UGCGameMode:BeginRoomRotate()
    if self.Room_Is_Rotating then
        return
    end

    self.Room_Is_Rotating = true
    self.Room_Rotate_Target_Mode_ID = self:GetRoomRotateTargetModeID()
    self.Backfill_Request_Pending = false
    self.Backfill_Match_Callback_Seen = false
    UGCGameSystem.StopPlayerJoin()
    UGCMultiMode.SetPlayerFill(false)
    self:SaveAllRoomPlayers()

    for _, PlayerController in ipairs(UGCGameSystem.GetAllPlayerController(false)) do
        self:PreparePlayerRoomRotate(PlayerController)
    end
end

--[[----------------------重试仍未开始的新房匹配------------------------]]
function UGCGameMode:RetryRoomRotate()
    self:SaveAllRoomPlayers()
    if self.Room_Rotate_Target_Mode_ID <= 0 then
        return
    end
    for _, PlayerController in ipairs(UGCGameSystem.GetAllPlayerController(false)) do
        UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Retry_Room_Rotate,
            self:IsRoomRotateLeader(PlayerController))
    end
end

--[[----------------------结束未成功换房的旧房------------------------]]
function UGCGameMode:ForceExitOldRoom()
    if self.Room_Force_Exit_Started then
        return
    end

    self.Room_Force_Exit_Started = true
    self.Room_Is_Rotating = true
    UGCGameSystem.StopPlayerJoin()
    UGCMultiMode.SetPlayerFill(false)
    self:SaveAllRoomPlayers()
    for _, PlayerController in ipairs(UGCGameSystem.GetAllPlayerController(false)) do
        UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Force_Room_Exit)
    end

    local Game_Over_Delegate = ObjectExtend.CreateDelegate(self, function()
        UGCGameSystem.GameOver()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(Game_Over_Delegate, self, Room_Force_Exit_Delay, false)
end

--[[----------------------处理DS关闭前通知------------------------]]
function UGCGameMode:OnDSCloseNotify(Remain_Time)
    local DS_Remain_Time = tonumber(Remain_Time) or UGCGameSystem.GetDSRemainingTime() -- DS剩余秒数
    if DS_Remain_Time <= Room_Force_Exit_Time then
        self:ForceExitOldRoom()
        return
    end
    if not self.Room_Is_Rotating then
        self:BeginRoomRotate()
    end
    if DS_Remain_Time <= Room_Rotate_Save_Time then
        self:RetryRoomRotate()
    end
end

--[[----------------------判断两个玩家Key是否相同------------------------]]
local function Is_Same_Player_Key(Player_Key_A, Player_Key_B)
    return Player_Key_A ~= nil and Player_Key_B ~= nil and tostring(Player_Key_A) == tostring(Player_Key_B)
end

--[[----------------------判断两个玩家是否为大厅队友------------------------]]
function UGCGameMode:IsLobbyTeammate(Player_Key_A, Player_Key_B)
    if Is_Same_Player_Key(Player_Key_A, Player_Key_B) then
        return true
    end

    local Lobby_Teammate_Keys = UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(Player_Key_A) -- 大厅队友Key列表
    for _, Lobby_Teammate_Key in ipairs(Lobby_Teammate_Keys or {}) do
        if Is_Same_Player_Key(Lobby_Teammate_Key, Player_Key_B) then
            return true
        end
    end
    return false
end

--[[----------------------查找大厅队伍已分配的玩法队伍------------------------]]
function UGCGameMode:GetLobbyGroupTeamID(Player_Key)
    for Assigned_Player_Key, Assigned_Team_ID in pairs(self.Assigned_Team_By_Player) do
        if self:IsLobbyTeammate(Player_Key, Assigned_Player_Key) then
            return Assigned_Team_ID
        end
    end
    return nil
end

--[[----------------------查找未被玩家占用的玩法队伍------------------------]]
function UGCGameMode:FindUnusedRoomTeamID()
    local Used_Team_IDs = {} -- 已占用队伍ID集合
    for _, Assigned_Team_ID in pairs(self.Assigned_Team_By_Player) do
        Used_Team_IDs[Assigned_Team_ID] = true
    end

    for Team_ID = 1, Max_Room_Team_Count do
        if not Used_Team_IDs[Team_ID] then
            return Team_ID
        end
    end
    return nil
end

--[[----------------------为玩法队伍创建独立敌对阵营------------------------]]
function UGCGameMode:EnsureRoomTeamCamp(Team_ID)
    if self.Camp_By_Team[Team_ID] then
        return self.Camp_By_Team[Team_ID]
    end

    local Camp_ID = UGCCampSystem.AddCamp("Room_Team_" .. tostring(Team_ID)) -- 新队伍阵营ID
    if Camp_ID == nil or Camp_ID < 0 then
        return nil
    end

    for _, Other_Camp_ID in pairs(self.Camp_By_Team) do
        UGCCampSystem.SetCampRelation(Camp_ID, Other_Camp_ID, ECampRelation.Enemy)
        UGCCampSystem.SetCampRelation(Other_Camp_ID, Camp_ID, ECampRelation.Enemy)
    end
    self.Camp_By_Team[Team_ID] = Camp_ID
    UGCCampSystem.SetCampForTeam(Team_ID, Camp_ID)
    UGCCampSystem.SetCampRelation(Camp_ID, Camp_ID, ECampRelation.Same)
    return Camp_ID
end

--[[----------------------按大厅组队关系分配玩法队伍------------------------]]
function UGCGameMode:AssignPlayerRoomTeam(PlayerController)
    local Player_Key = PlayerController.PlayerKey -- 当前玩家Key
    local Team_ID = self:GetLobbyGroupTeamID(Player_Key) -- 大厅队伍已分配的队伍ID
    if Team_ID == nil then
        local Current_Team_ID = tonumber(UGCTeamSystem.GetTeamIDByPlayerKey(Player_Key)) or 0 -- 平台初始队伍ID
        if Current_Team_ID > 0 and Current_Team_ID <= Max_Room_Team_Count and
            self.Assigned_Team_By_Player[Player_Key] == nil then
            local Team_Used = false -- 当前队伍是否已被其他大厅队伍占用
            for Assigned_Player_Key, Assigned_Team_ID in pairs(self.Assigned_Team_By_Player) do
                if Assigned_Team_ID == Current_Team_ID and
                    not self:IsLobbyTeammate(Player_Key, Assigned_Player_Key) then
                    Team_Used = true
                    break
                end
            end
            Team_ID = not Team_Used and Current_Team_ID or nil
        end
        Team_ID = Team_ID or self:FindUnusedRoomTeamID()
    end

    if Team_ID == nil then
        return
    end
    if UGCTeamSystem.GetTeamIDByPlayerKey(Player_Key) ~= Team_ID then
        UGCTeamSystem.ChangePlayerTeamID(Player_Key, Team_ID)
    end
    self.Assigned_Team_By_Player[Player_Key] = Team_ID
    self:EnsureRoomTeamCamp(Team_ID)
    ugcprint("[房间分队] 玩家=" .. tostring(Player_Key) .. "，队伍=" .. tostring(Team_ID))
end

--[[----------------------延迟刷新房间补人请求------------------------]]
function UGCGameMode:ScheduleRoomPlayerJoin()
    if self.Room_Is_Rotating or self.Backfill_Refresh_Scheduled then
        return
    end

    self.Backfill_Refresh_Scheduled = true
    --[[----------------------执行延迟补人刷新------------------------]]
    local Apply_Player_Join_Delegate = ObjectExtend.CreateDelegate(self, function()
        self.Backfill_Refresh_Scheduled = false
        self:ApplyRoomPlayerJoin()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(Apply_Player_Join_Delegate, self, Backfill_Refresh_Delay, false)
end

--[[----------------------为房间滚动申请一名玩家------------------------]]
function UGCGameMode:ApplyRoomPlayerJoin()
    if self.Room_Is_Rotating or self.Backfill_Request_Pending then
        return
    end

    local Player_Controllers = UGCGameSystem.GetAllPlayerController(false)
    if #Player_Controllers == 0 or #Player_Controllers >= Max_Room_Player_Count then
        return
    end

    local Team_ID = self:FindUnusedRoomTeamID() -- 补人目标空闲队伍ID
    if Team_ID == nil then
        return
    end
    self.Backfill_Request_Pending = true
    self.Backfill_Match_Callback_Seen = false
    self.Backfill_Login_Serial_At_Request = self.Backfill_Login_Serial
    UGCGameSystem.ApplyPlayerJoinLimitCount({[Team_ID] = 1})
    ugcprint("[房间补人] 已申请一名玩家，队伍=" .. tostring(Team_ID) .. "，当前人数=" .. tostring(#Player_Controllers))
end

--[[----------------------确认本次补人已经完成------------------------]]
function UGCGameMode:CompleteRoomPlayerJoin()
    if self.Room_Is_Rotating or not self.Backfill_Request_Pending or not self.Backfill_Match_Callback_Seen or
        self.Backfill_Login_Serial <= self.Backfill_Login_Serial_At_Request then
        return
    end

    self.Backfill_Request_Pending = false
    self.Backfill_Match_Callback_Seen = false
    ugcprint("[房间补人] 玩家已进入房间，继续申请下一名玩家")
    self:ScheduleRoomPlayerJoin()
end

--[[----------------------接收补人成功回调------------------------]]
function UGCGameMode:OnPlayerJoinSucceeded(UID, Remaining_Player_Count_To_Join)
    if not self:HasAuthority() or self.Room_Is_Rotating or not self.Backfill_Request_Pending then
        return
    end

    self.Backfill_Match_Callback_Seen = true
    ugcprint("[房间补人] 匹配成功，玩家UID=" .. tostring(UID) .. "，剩余人数=" ..
        tostring(Remaining_Player_Count_To_Join))
    self:CompleteRoomPlayerJoin()
end

--[[-------------------生成随机密码---------------------------]] --
function UGCGameMode:GenerateRoomPass()
    if not self:HasAuthority() then
        return
    end

    self.GameState.Room_Pass = math.random(1000, 9999)

    UnrealNetwork.RepLazyProperty(self.GameState, "Room_Pass")
end

--[[----------------------玩家进入游戏时读取存档，后加入的同步事件状态------------------------]] --
function UGCGameMode:UGC_PlayerLoginEvent(PlayerController)
    self.Backfill_Login_Serial = self.Backfill_Login_Serial + 1
    self:AssignPlayerRoomTeam(PlayerController)
    self:LoadPlayerArchive(PlayerController)
    local Player_Pawn = PlayerController:GetPlayerCharacterSafety() -- 当前玩家角色
    local Player_UID = UGCPawnAttrSystem.GetPlayerUID(Player_Pawn) -- 当前玩家UID
    PlayerController.Room_Lottery_Has_Claimed = Player_UID ~= nil and
                                                    self.Room_Lottery_Claimed_UIDs[tostring(Player_UID)] == true
    UnrealNetwork.RepLazyProperty(PlayerController, "Room_Lottery_Has_Claimed")

    local activeEvent = EventScheduler.GetActiveEvent()
    if activeEvent then
        -- 施加效果
        EventScheduler:_OnStart(activeEvent)
    end

    if self.Room_Is_Rotating then
        self:PreparePlayerRoomRotate(PlayerController)
        return
    end

    self:CompleteRoomPlayerJoin()
    self:ScheduleRoomPlayerJoin()
end

--[[----------------------处理玩家死亡与复活------------------------]]
function UGCGameMode:UGC_PlayerKilledEvent(Killer, VictimPlayer, VictimPawn, DamageType)
    if VictimPlayer.Is_Monster_Death then
        VictimPlayer.Is_Monster_Death = false -- 消耗怪物致死标记
        UnrealNetwork.CallUnrealRPC(VictimPlayer, VictimPlayer, L_Enum.Name_RPC.Play_Sound,
            SoundMgr.SoundName.Lose)
        UnrealNetwork.CallUnrealRPC(VictimPlayer, VictimPlayer, L_Enum.Name_RPC.Show_Respawn_UI)
        return
    end

    UGCPlayerPawnSystem.RespawnPlayer(VictimPlayer.PlayerKey, 1, false, 0.01)
end

--[[----------------------复活后返回死亡位置------------------------]]
function UGCGameMode:UGC_PlayerRespawnEvent(RespawnedController)
    RespawnedController:SyncWinCupToPawn()
    local PlayerPawn = RespawnedController:GetPlayerCharacterSafety() -- 复活后的玩家角色
    if not RespawnedController.Return_To_Death_Location or RespawnedController.Death_Location == nil then
        return
    end

    if PlayerPawn then
        PlayerPawn:K2_SetActorLocation(RespawnedController.Death_Location)
    end
    RespawnedController.Return_To_Death_Location = false -- 重置返回死亡位置标记
end

--[[----------------------玩家登录时读取存档------------------------]]
function UGCGameMode:LoadPlayerArchive(PlayerController)
    local playerPawn = PlayerController:GetPlayerCharacterSafety()
    local uid = UGCPawnAttrSystem.GetPlayerUID(playerPawn)
    local archiveData = UGCPlayerStateSystem.GetPlayerArchiveData(tonumber(uid))

    if archiveData == nil then
        archiveData = self:GetDefaultArchiveData()
    end

    PlayerController.PlayerArchiveData = archiveData
    PlayerController.PlayerGameLevel = archiveData.Level or 1
    PlayerController.PlayerAttack = archiveData.Attack or 1
    PlayerController.PlayerMaxHP = archiveData.MaxHP or 1
    local Need_Week_Time_Migration = archiveData.WeekEndTime and (archiveData.WeekTimeVer or 0) < Week_Time_Ver -- 是否迁移旧周卡时间
    if Need_Week_Time_Migration then
        archiveData.WeekEndTime = archiveData.WeekEndTime - Legacy_Week_Time_Offset
        archiveData.WeekTimeVer = Week_Time_Ver
    end
    PlayerController.WeekEndTime = archiveData.WeekEndTime
    UnrealNetwork.RepLazyProperty(PlayerController, "WeekEndTime")
    PlayerController.WinCup = archiveData.WinCup or 0
    PlayerController:SyncWinCupToPawn()
    PlayerController.Tower_Reward_Has_Started = archiveData.TowerRewardHasStarted or false
    PlayerController.Tower_Reward_Is_Timing = false
    PlayerController.Tower_Reward_Enter_Time = 0
    PlayerController.Tower_Reward_Accumulated_Time = archiveData.TowerRewardAccumulatedTime or 0
    PlayerController.Tower_Reward_Claim_Mask = archiveData.TowerRewardClaimMask or 0
    PlayerController:SyncTowerRewardState()
    PlayerController.Coin_Lottery_Archive = archiveData.CoinLottery
    PlayerController:Sync_Coin_Lottery_Archive()
    if Need_Week_Time_Migration then
        self:SavePlayerArchive(PlayerController)
    end
end

--[[----------------------保存玩家存档数据------------------------]]
function UGCGameMode:SavePlayerArchive(PlayerController)
    local playerPawn = PlayerController:GetPlayerCharacterSafety()
    local uid = UGCPawnAttrSystem.GetPlayerUID(playerPawn)

    local archiveData = PlayerController.PlayerArchiveData or self:GetDefaultArchiveData()
    archiveData.Level = PlayerController.PlayerGameLevel
    archiveData.Attack = PlayerController.PlayerAttack
    archiveData.MaxHP = PlayerController.PlayerMaxHP
    archiveData.WeekEndTime = PlayerController.WeekEndTime
    archiveData.WeekTimeVer = Week_Time_Ver
    archiveData.WinCup = PlayerController.WinCup
    archiveData.TowerRewardHasStarted = PlayerController.Tower_Reward_Has_Started
    archiveData.TowerRewardAccumulatedTime = PlayerController:GetTowerRewardElapsedTime()
    archiveData.TowerRewardClaimMask = PlayerController.Tower_Reward_Claim_Mask
    archiveData.CoinLottery = PlayerController:Get_Coin_Lottery_Archive()

    UGCPlayerStateSystem.SavePlayerArchiveData(tonumber(uid), archiveData)
end

--[[----------------------通过玩家Key保存玩家存档数据------------------------]]
function UGCGameMode:SavePlayerArchiveByPlayerKey(PlayerKey)
    local PlayerController = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
    if PlayerController then
        self:SavePlayerArchive(PlayerController)
    end
end

--[[----------------------获取玩家默认存档数据------------------------]]
function UGCGameMode:GetDefaultArchiveData()
    return {
        Level = 1,
        Attack = 1,
        MaxHP = 1,
        WeekTimeVer = Week_Time_Ver,
        WinCup = 0,
        TowerRewardHasStarted = false,
        TowerRewardAccumulatedTime = 0,
        TowerRewardClaimMask = 0
    }
end

--[[----------------------玩家离开游戏前保存存档------------------------]]
function UGCGameMode:UGC_PlayerExitEvent(PlayerController)
    local Item_Count = UGCBackpackSystemV2.GetItemCountV2(PlayerController, Room_Only_Item_ID) -- 房间限定物品总数
    if Item_Count > 0 then
        UGCBackpackSystemV2.RemoveItemV2(PlayerController, Room_Only_Item_ID, Item_Count)
    end

    self:SavePlayerArchive(PlayerController)
    self.Assigned_Team_By_Player[PlayerController.PlayerKey] = nil
    if not self.Room_Is_Rotating then
        self:ScheduleRoomPlayerJoin()
    end
end
return UGCGameMode;
