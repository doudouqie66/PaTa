---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {};

--[[----------------------游戏启动------------------------]] --
function UGCGameMode:ReceiveBeginPlay()
    -- EventScheduler.Start()
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
end
return UGCGameMode;
