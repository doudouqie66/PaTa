---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field GiftPackComponent GiftPackComponent_C
---@field TaskTemplateComponent TaskTemplateComponent_C
---@field RankingListComponent RankingListComponent_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
-- Edit Below--
---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field GiftPackComponent GiftPackComponent_C
---@field TaskTemplateComponent TaskTemplateComponent_C
---@field RankingListComponent RankingListComponent_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
-- Edit Below--
---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field GiftPackComponent GiftPackComponent_C
---@field TaskTemplateComponent TaskTemplateComponent_C
---@field RankingListComponent RankingListComponent_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
-- Edit Below--
---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field GiftPackComponent GiftPackComponent_C
---@field TaskTemplateComponent TaskTemplateComponent_C
---@field RankingListComponent RankingListComponent_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
-- Edit Below--
---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field TaskTemplateComponent TaskTemplateComponent_C
---@field RankingListComponent RankingListComponent_C
---@field SignInEventComponent SignInEventComponent_C
---@field ShopV2Component ShopV2Component_C
-- Edit Below--
local UGCPlayerController = {
    PlayerGameLevel = 1,
    PlayerAttack = 1,
    PlayerMaxHP = 1,
    Return_To_Death_Location = false, -- 是否返回死亡位置
    WeekEndTime = nil,
    WinCup = 0 -- 获得奖杯数量
}

--[[---------------------初始化测试-------------------------]] --
function UGCPlayerController:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Add(self.OnBuyUGCCommodityResult, self)
    self:InitTest()
end

--[[----------------------结束时解绑购买结果委托------------------------]]
function UGCPlayerController:ReceiveEndPlay()
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Remove(self.OnBuyUGCCommodityResult, self)
    self.SuperClass.ReceiveEndPlay(self)
end
--[[------------------测试送东西----------------------------]] --
function UGCPlayerController:InitTest()
    local OBTimerDelegate = ObjectExtend.CreateDelegate(self, function()
        if self:HasAuthority() == true then
            local PlayerPawn = self:GetPlayerCharacterSafety()
            -- V2 背包添加物品
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310035, 1)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310033, 1)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310036, 1)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310023, 33)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310020, 33)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310014, 33)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310018, 33)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310026, 33)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310021, 33)

        end
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(OBTimerDelegate, self, 2, false)

end

--[[------------------Ctrl放私人数据和服务器交互----------------------------]] --
-- ✅ 放这里合适：
-- 金币数、累计得分、击杀数（只需要自己知道的）
-- 购买道具、发送 ServerRPC 申请
-- 仅自身收到的通知播报
-- UI 的加载与初始化

--[[-----------------------需要同步的属性-----------------------]] --
function UGCPlayerController:GetReplicatedProperties()
    return {"PlayerGameLevel", "Lazy"}, {"PlayerAttack", "Lazy"}, {"PlayerMaxHP", "Lazy"}, {"WeekEndTime", "Lazy"},
        {"WinCup", "Lazy"}
end
--[[----------------------注册客户端可调用的服务端RPC------------------------]]
function UGCPlayerController:GetAvailableServerRPCs()
    return L_Enum.Name_RPC.AddLevel, L_Enum.Name_RPC.UseRedemptionCode, L_Enum.Name_RPC.Mgr_Atten,
        L_Enum.Name_RPC.Request_Respawn, L_Enum.Name_RPC.Add_WinCup, L_Enum.Name_RPC.Switch_View,
        L_Enum.Name_RPC.New_Pass, L_Enum.Name_RPC.Add_Backpack_Item

end

--[[----------------------给当前玩家添加背包物品------------------------]]
function UGCPlayerController:Add_Backpack_Item(Item_ID, Item_Count)
    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager")
    Virtual_Item_Manager:AddVirtualItem(self, Item_ID, Item_Count)
end

--[[----------------------重新生成密码------------------------]]
function UGCPlayerController:New_Pass()
    local Game_Mode = UGCGameSystem.GetGameMode() -- 当前游戏模式
    Game_Mode:GenerateRoomPass()

end

--[[----------------------切换第一和第三人称------------------------]]
function UGCPlayerController:Switch_View()
    local Player_Pawn = UGCGameSystem.GetPlayerPawnByPlayerController(self) -- 当前玩家角色

    if UGCPlayerPawnSystem.GetIsFPP(Player_Pawn) then
        UGCPlayerPawnSystem.SetIsTPP(Player_Pawn, true, true)
    else
        UGCPlayerPawnSystem.SetIsFPP(Player_Pawn, true, true)
    end
end
--[[----------------------增加玩家奖杯并保存------------------------]]
function UGCPlayerController:Add_WinCup(Add_Count)
    if not self:HasAuthority() then
        return
    end

    self:Add_Backpack_Item(1014, Add_Count)
    -- 添加排行榜
    local Ranking_List_Manager = UGCGamePartSystem.GetGamePartGlobalActor("RankingListManager") -- 排行榜管理器
    local Player_UID = UGCGameSystem.GetUIDByPlayerController(self) -- 玩家UID
    Ranking_List_Manager:UpdateScore(self, Player_UID, 1, Add_Count, true)
    self.WinCup = self.WinCup + Add_Count
    self:SyncWinCupToPawn()
    self:SaveArchive()
end

--[[-------------------传送---------------------------]] --
function UGCPlayerController:TeleToPoint(Point)
    local pawn = self:K2_GetPawn()
    local PlayerStartManagerComponentClass = ScriptGameplayStatics.FindClass("PlayerStartManagerComponent")
    local PlayerStartManagerComponent = UGCGameSystem.GameMode:GetComponentByClass(PlayerStartManagerComponentClass)
    local PlayerStart = PlayerStartManagerComponent:FindPlayerStartByBornPointID(Point, false)
    local loc = PlayerStart:K2_GetActorLocation()
    UGCPlayerControllerSystem.TeleportTo(self, loc.X, loc.Y, loc.Z + 100)
end
--[[----------------------同步奖杯数量到玩家Pawn------------------------]]
function UGCPlayerController:SyncWinCupToPawn()
    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家Pawn
    if not Player_Pawn then
        return
    end

    Player_Pawn.WinCup = self.WinCup
    UnrealNetwork.RepLazyProperty(Player_Pawn, "WinCup")
end
-- [[----------------------下面是RPC方法------------------------]] --

--[[----------------------打开礼包界面------------------------]]
function UGCPlayerController:OpenGiftPack(Gift_Pack_ID)
    GiftPackManager:OpenGiftPack(Gift_Pack_ID)
end

--[[----------------------购买周卡成功后更新有效期------------------------]]
function UGCPlayerController:OnBuyUGCCommodityResult(bSuccess, PlayerKey, CommodityID, Count, UID, ProductID)
    if not bSuccess or PlayerKey ~= self.PlayerKey or ProductID ~= L_Enum.ID_ShopProduct.WeekdGift or CommodityID ~=
        L_Enum.ID_Gift.WeekdGift then
        return
    end

    local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
    local Week_Card_Duration = 7 * 24 * 60 * 60 -- 单张周卡持续秒数
    self.WeekEndTime = math.max(self.WeekEndTime or 0, Current_Time) + Week_Card_Duration * Count
    if self:HasAuthority() then
        UnrealNetwork.RepLazyProperty(self, "WeekEndTime")
        self:SaveArchive()
    end
end

--[[--------------------通用提示方法1--------------------------]] --
function UGCPlayerController:Tool_Msg_01(str)
    TipsMgr.ShowTips_01(str)
end
--[[----------------------通知警示区域------------------------]] --

function UGCPlayerController:Mgr_Atten(bool)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_Attention, bool)
end
--[[----------------------请求复活当前玩家------------------------]]
function UGCPlayerController:RequestRespawn(Return_To_Death_Location)
    self.Return_To_Death_Location = Return_To_Death_Location
    UGCPlayerPawnSystem.RespawnPlayer(self.PlayerKey, 0, false, 0.01)
end
--[[----------------------显示复活界面------------------------]]
function UGCPlayerController:ShowRespawnUI()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_Attention, false)

end
--[[----------------------测试玩家等级加一------------------------]]
function UGCPlayerController:AddLevel(AddLevel)
    self.PlayerGameLevel = self.PlayerGameLevel + AddLevel
    if self.PlayerArchiveData then
        self.PlayerArchiveData.Level = self.PlayerGameLevel
    end
    self:CallRefreshLazy(L_Enum.Name_RepPts.PlayerGameLevel)
    self:SaveArchive()
end

--[[----------------------测试兑换码------------------------]]
function UGCPlayerController:UseRedemptionCode(RedemptionCode)
    if not self.bUseRedemptionCodeResultDelegateInit then
        self.bUseRedemptionCodeResultDelegateInit = true
        UGCCommoditySystem.UseRedemptionCodeResultDelegate:Add(self.OnUseRedemptionCodeResult, self)
    end

    local PlayerPawn = self:GetPlayerCharacterSafety()
    local UID = UGCPawnAttrSystem.GetPlayerUID(PlayerPawn)
    print(string.format("[UseRedemptionCode] UID=%s Code=%s", tostring(UID), tostring(RedemptionCode)))
    UGCCommoditySystem.UseRedemptionCode(tonumber(UID), RedemptionCode)
end

--[[----------------------打印兑换码结果------------------------]]
function UGCPlayerController:OnUseRedemptionCodeResult(Result, PlayerKey, UID, CommodityID, Count, ProductID)
    if Result == EUseRedemptionCodeResult.Success then
        print(string.format("[UseRedemptionCode] Success UID=%s CommodityID=%s Count=%s ProductID=%s", tostring(UID),
            tostring(CommodityID), tostring(Count), tostring(ProductID)))
    else
        print(string.format("[UseRedemptionCode] Failed Result=%s UID=%s PlayerKey=%s", tostring(Result), tostring(UID),
            tostring(PlayerKey)))
    end
end
--[[--------------------下面是属性变动后对应的方法--------------------------]] --
--[[----------------------玩家等级同步后刷新显示------------------------]]
function UGCPlayerController:OnRep_PlayerGameLevel()
    -- if self.MainUI_BP then
    --     self.MainUI_BP:RefreshPlayerGameLevel(self.PlayerGameLevel)
    -- end
    L_TipsTool.ShowTips_01(tostring(self.PlayerGameLevel))
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
