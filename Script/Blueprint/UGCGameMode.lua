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
UGCGameMode.Backfill_Request_Pending = false -- 是否存在补人请求
UGCGameMode.Backfill_Match_Callback_Seen = false -- 是否收到补人成功回调
UGCGameMode.Backfill_Login_Serial = 0 -- 玩家登录序号
UGCGameMode.Backfill_Login_Serial_At_Request = 0 -- 申请补人时的登录序号
UGCGameMode.Backfill_Refresh_Scheduled = false -- 是否已安排补人刷新
UGCGameMode.Assigned_Team_By_Player = {} -- 玩家对应的玩法队伍
UGCGameMode.Camp_By_Team = {} -- 玩法队伍对应的阵营
UGCGameMode.Room_Lottery_Claimed_UIDs = {} -- 当前房间已经抽奖的玩家UID集合

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
        UGCCampSystem.SetDefaultCampRelation(ECampRelation.Enemy)
        UGCGameSystem.ApplyPlayerJoinSucceededDelegate:Add(self.OnPlayerJoinSucceeded, self)
        UGCGameSystem.OpenPlayerJoin()
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
    if self.Backfill_Refresh_Scheduled then
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
    if self.Backfill_Request_Pending then
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
    if not self.Backfill_Request_Pending or not self.Backfill_Match_Callback_Seen or
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
    if not self:HasAuthority() or not self.Backfill_Request_Pending then
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
    PlayerController.WeekEndTime = archiveData.WeekEndTime
    UnrealNetwork.RepLazyProperty(PlayerController, "WeekEndTime")
    PlayerController.WinCup = archiveData.WinCup or 0
    PlayerController:SyncWinCupToPawn()
    PlayerController.Coin_Lottery_Archive = archiveData.CoinLottery
    PlayerController:Sync_Coin_Lottery_Archive()
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
    archiveData.WinCup = PlayerController.WinCup
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
        WinCup = 0
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
    self:ScheduleRoomPlayerJoin()
end
return UGCGameMode;
