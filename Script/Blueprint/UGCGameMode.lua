---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
-- Edit Below--
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {
    Version = 1,
    Level = 1,
    Exp = 0,
    Coins = 0,
    Attack = 1,
    MaxHP = 1
};

--[[----------------------玩家被淘汰后自动复活------------------------]]
function UGCGameMode:UGC_PlayerKilledEvent(Killer, VictimPlayer, VictimPawn, DamageType)
    if VictimPlayer then
        UGCPlayerPawnSystem.RespawnPlayer(VictimPlayer.PlayerKey, 1, false, 0.01)
    end
end

--[[----------------------玩家进入游戏时读取存档------------------------]]
function UGCGameMode:UGC_PlayerLoginEvent(PlayerController)
    self:LoadPlayerArchive(PlayerController)
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
end

--[[----------------------保存玩家存档数据------------------------]]
function UGCGameMode:SavePlayerArchive(PlayerController)
    local playerPawn = PlayerController:GetPlayerCharacterSafety()
    local uid = UGCPawnAttrSystem.GetPlayerUID(playerPawn)

    local archiveData = PlayerController.PlayerArchiveData or self:GetDefaultArchiveData()
    archiveData.Level = PlayerController.PlayerGameLevel
    archiveData.Attack = PlayerController.PlayerAttack
    archiveData.MaxHP = PlayerController.PlayerMaxHP

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
        Version = 1,
        Level = 1,
        Exp = 0,
        Coins = 0,
        Attack = 1,
        MaxHP = 1
    }
end

--[[----------------------玩家离开游戏前保存存档------------------------]]
function UGCGameMode:UGC_PlayerExitEvent(PlayerController)
    self:SavePlayerArchive(PlayerController)
end
return UGCGameMode;
