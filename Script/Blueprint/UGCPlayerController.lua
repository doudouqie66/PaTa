---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
---@field UGCTaskTemplateController UUGCTaskTemplateController
--Edit Below--
local UGCPlayerController = {
    PlayerGameLevel = 1,
    PlayerAttack = 1,
    PlayerMaxHP = 1
}
--[[------------------Ctrl放私人数据和服务器交互----------------------------]] --
-- ✅ 放这里合适：
-- 金币数、累计得分、击杀数（只需要自己知道的）
-- 购买道具、发送 ServerRPC 申请
-- 仅自身收到的通知播报
-- UI 的加载与初始化

--[[-----------------------需要同步的属性-----------------------]] --
function UGCPlayerController:GetReplicatedProperties()
    return {"PlayerGameLevel", "Lazy"}, {"PlayerAttack", "Lazy"}, {"PlayerMaxHP", "Lazy"}
end
--[[----------------------注册客户端可调用的服务端RPC------------------------]]
function UGCPlayerController:GetAvailableServerRPCs()
    return L_Enum.Name_RPC.AddLevel
end

--[[----------------------下面是RPC方法------------------------]] --
--[[----------------------测试玩家等级加一------------------------]]
function UGCPlayerController:AddLevel(AddLevel)
    self.PlayerGameLevel = self.PlayerGameLevel + AddLevel
    if self.PlayerArchiveData then
        self.PlayerArchiveData.Level = self.PlayerGameLevel
    end
    self:CallRefreshLazy(L_Enum.Name_RepPts.PlayerGameLevel)
    self:SaveArchive()
end
--[[--------------------下面是属性变动后对应的方法--------------------------]] --
--[[----------------------玩家等级同步后刷新显示------------------------]]
function UGCPlayerController:OnRep_PlayerGameLevel()
    self.MainUI_BP:RefreshPlayerGameLevel(self.PlayerGameLevel)
    TipsMgr.ShowTips_01(tostring(self.PlayerGameLevel))
end

--[[-----------------------下面是通用方法-----------------------]] --
function UGCPlayerController:CallRefreshLazy(str)
    UnrealNetwork.RepLazyProperty(self, str)
end
--[[----------------------保存当前玩家存档数据------------------------]]
function UGCPlayerController:SaveArchive()
    local GameMode = UGCGameSystem.GetGameMode()
    if GameMode then
        GameMode:SavePlayerArchive(self)
    end
end
return UGCPlayerController
