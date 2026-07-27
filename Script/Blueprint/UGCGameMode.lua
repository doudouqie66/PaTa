---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {};
local Max_Room_Player_Count = 10 -- 房间最大玩家数量

--[[----------------------游戏启动------------------------]] --
function UGCGameMode:ReceiveBeginPlay()
    if self:HasAuthority() then

        EventScheduler.Start()
        -- 生成随机密码
        self:GenerateRoomPass()
        UGCGameSystem.OpenPlayerJoin()

        --[[----------------------延迟申请初始补人名额------------------------]]
        local Apply_Player_Join_Delegate = ObjectExtend.CreateDelegate(self, function()
            self:ApplyRoomPlayerJoin()
        end)
        KismetSystemLibrary.K2_SetTimerDelegateForLua(Apply_Player_Join_Delegate, self, 3, false)
    end

end

--[[----------------------申请将房间玩家补充至人数上限------------------------]]
function UGCGameMode:ApplyRoomPlayerJoin()
    local Player_Controllers = UGCGameSystem.GetAllPlayerController(false)
    if #Player_Controllers == 0 then
        return
    end

    local Need_Player_Count = Max_Room_Player_Count - #Player_Controllers -- 当前需要补充的玩家数量
    if Need_Player_Count <= 0 then
        return
    end

    local Team_ID = UGCTeamSystem.GetTeamIDByPlayerKey(Player_Controllers[1].PlayerKey) -- 补人目标队伍ID
    UGCGameSystem.ApplyPlayerJoinLimitCount({[Team_ID] = Need_Player_Count})
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
    self:LoadPlayerArchive(PlayerController)

    local activeEvent = EventScheduler.GetActiveEvent()
    if activeEvent then
        -- 施加效果
        EventScheduler:_OnStart(activeEvent)
    end
end

--[[----------------------玩家非怪物致死后自动复活------------------------]]
function UGCGameMode:UGC_PlayerKilledEvent(Killer, VictimPlayer, VictimPawn, DamageType)
    if VictimPlayer.Is_Monster_Death then
        VictimPlayer.Is_Monster_Death = false -- 消耗怪物致死标记
        return
    end

    UGCPlayerPawnSystem.RespawnPlayer(VictimPlayer.PlayerKey, 1, false, 0.01)
end

--[[----------------------复活后返回死亡位置------------------------]]
function UGCGameMode:UGC_PlayerRespawnEvent(RespawnedController)
    RespawnedController:SyncWinCupToPawn()
    if not RespawnedController.Return_To_Death_Location or RespawnedController.Death_Location == nil then
        return
    end

    local PlayerPawn = RespawnedController:GetPlayerCharacterSafety()
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
    self:SavePlayerArchive(PlayerController)

    local Team_ID = UGCTeamSystem.GetTeamIDByPlayerKey(PlayerController.PlayerKey) -- 离开玩家的队伍ID
    UGCGameSystem.ApplyPlayerJoinLimitCount({[Team_ID] = 1})
end
return UGCGameMode;
