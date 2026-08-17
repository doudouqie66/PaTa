---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {};
local Max_Room_Player_Count = 10 -- 房间最大玩家数量
local Room_Only_Item_ID = 8310033 -- 仅限当前房间使用的物品ID
UGCGameMode.Backfill_Request_Pending = false -- 是否存在补人请求
UGCGameMode.Backfill_Match_Callback_Seen = false -- 是否收到补人成功回调
UGCGameMode.Backfill_Login_Serial = 0 -- 玩家登录序号
UGCGameMode.Backfill_Login_Serial_At_Request = 0 -- 申请补人时的登录序号
UGCGameMode.Backfill_Refresh_Scheduled = false -- 是否已安排补人刷新

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
        UGCGameSystem.ApplyPlayerJoinSucceededDelegate:Add(self.OnPlayerJoinSucceeded, self)
        UGCGameSystem.OpenPlayerJoin()
    end

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
    KismetSystemLibrary.K2_SetTimerDelegateForLua(Apply_Player_Join_Delegate, self, 1, false)
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

    local Team_ID = UGCTeamSystem.GetTeamIDByPlayerKey(Player_Controllers[1].PlayerKey) -- 补人目标队伍ID
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
    self:LoadPlayerArchive(PlayerController)

    local activeEvent = EventScheduler.GetActiveEvent()
    if activeEvent then
        -- 施加效果
        EventScheduler:_OnStart(activeEvent)
    end

    self:CompleteRoomPlayerJoin()
    self:ScheduleRoomPlayerJoin()
end

--[[----------------------玩家非怪物致死后自动复活------------------------]]
function UGCGameMode:UGC_PlayerKilledEvent(Killer, VictimPlayer, VictimPawn, DamageType)
    if VictimPlayer.Is_Monster_Death then
        VictimPlayer.Is_Monster_Death = false -- 消耗怪物致死标记
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
    self:ScheduleRoomPlayerJoin()
end
return UGCGameMode;
