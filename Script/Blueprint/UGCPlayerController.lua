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
    WinCup = 0, -- 获得奖杯数量
    Tower_Reward_Has_Started = false, -- 是否进入过计时区域
    Tower_Reward_Is_Timing = false, -- 当前是否正在区域内计时
    Tower_Reward_Enter_Time = 0, -- 本次进入区域的时间戳
    Tower_Reward_Accumulated_Time = 0, -- 已累计的区域内停留秒数
    Tower_Reward_Claim_Mask = 0, -- 五档奖励领取状态位
    Is_Monster_Death = false, -- 是否由怪物内部碰撞体致死
    Flying_Item_ID = 0 -- 当前装备的飞行物ID
}

local Jetpack_Item_ID = 8310037 -- 冲天炮物品ID
local Magic_Carpet_Item_ID = 8310038 -- 魔毯物品ID
local Flying_Item_Slot_Name = "EquipmentSlot.Custom.Jetpack" -- 飞行物装备槽位
local Fly_Movement_Mode = 5 -- 飞行移动模式
local Falling_Movement_Mode = 3 -- 下落移动模式
local Fly_State_Tag = "PawnState.Movement.Flying" -- 飞行状态标签
local Magic_Carpet_Max_Fly_Speed = 250 -- 魔毯最高飞行速度
local Magic_Carpet_Braking_Deceleration = 2048 -- 魔毯飞行制动力

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
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310033, 1)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310035, 1)
            -- UGCBackpackSystemV2.AddItemV2(PlayerPawn, 8310036, 1)

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
        {"WinCup", "Lazy"}, {"Tower_Reward_Has_Started", "Lazy"}, {"Tower_Reward_Is_Timing", "Lazy"},
        {"Tower_Reward_Enter_Time", "Lazy"}, {"Tower_Reward_Accumulated_Time", "Lazy"},
        {"Tower_Reward_Claim_Mask", "Lazy"}, {"Flying_Item_ID", "Lazy"}
end
--[[----------------------注册客户端可调用的服务端RPC------------------------]]
function UGCPlayerController:GetAvailableServerRPCs()
    return L_Enum.Name_RPC.AddLevel, L_Enum.Name_RPC.UseRedemptionCode, L_Enum.Name_RPC.Mgr_Atten,
        L_Enum.Name_RPC.Request_Respawn, L_Enum.Name_RPC.Add_WinCup, L_Enum.Name_RPC.Switch_View,
        L_Enum.Name_RPC.New_Pass, L_Enum.Name_RPC.Add_Backpack_Item, L_Enum.Name_RPC.Claim_Tower_Reward,
        L_Enum.Name_RPC.Exchange_Trophy_Item, L_Enum.Name_RPC.Buy_Gold_Item, L_Enum.Name_RPC.Tele_To_Point,
        L_Enum.Name_RPC.Switch_Trap_Item_Skill, L_Enum.Name_RPC.Set_Jetpack_Flying

end

--[[----------------------设置飞行移动模式------------------------]]
function UGCPlayerController:Set_Flying_Movement_Enabled(Is_Enabled)
    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家角色
    if not Is_Enabled then
        if not Player_Pawn.Flying_Item_Movement_Enabled then
            return
        end
        Player_Pawn.Flying_Item_Movement_Enabled = false
        local Should_Set_Falling = true -- 是否切换到下落模式
        if Player_Pawn.Flying_Item_Has_Entered_State then
            Should_Set_Falling = UGCPersistEffectSystem.LeaveDynamicState(Player_Pawn, Fly_State_Tag)
            Player_Pawn.Flying_Item_Has_Entered_State = false
        end
        if Should_Set_Falling and Player_Pawn.CharacterMovement.MovementMode == Fly_Movement_Mode then
            Player_Pawn.CharacterMovement:SetMovementMode(Falling_Movement_Mode, 0)
        end
        return
    end

    if Player_Pawn.Flying_Item_Movement_Enabled then
        return
    end
    Player_Pawn.Flying_Item_Movement_Enabled = true
    Player_Pawn.Flying_Item_Has_Entered_State = UGCPersistEffectSystem.EnterDynamicState(Player_Pawn, Fly_State_Tag)
    Player_Pawn.CharacterMovement:SetMovementMode(Fly_Movement_Mode, 0)
end

--[[----------------------设置冲天炮飞行状态------------------------]]
function UGCPlayerController:Set_Jetpack_Flying(Is_Flying)
    if not self:HasAuthority() or self.Flying_Item_ID ~= Jetpack_Item_ID then
        return
    end

    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家角色
    local Equipped_Item = UGCBackpackSystemV2.GetEquippedItemBySlotName(Player_Pawn, Flying_Item_Slot_Name) -- 已装备飞行物
    local Can_Fly = Equipped_Item.TypeSpecificID == Jetpack_Item_ID -- 是否允许冲天炮飞行
    self:Set_Flying_Movement_Enabled(Is_Flying and Can_Fly)
    ugcprint(string.format("[Jetpack] 服务端启动检查：装备物品ID=%s，允许飞行=%s",
        tostring(Equipped_Item.TypeSpecificID), tostring(Is_Flying and Can_Fly)))
end

--[[----------------------应用服务端魔毯移动参数------------------------]]
function UGCPlayerController:Apply_Magic_Carpet_Movement()
    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家角色
    local Character_Movement = Player_Pawn.CharacterMovement -- 角色移动组件
    Player_Pawn.Magic_Carpet_Original_Max_Fly_Speed = Character_Movement.MaxFlySpeed
    Player_Pawn.Magic_Carpet_Original_Braking_Deceleration = Character_Movement.BrakingDecelerationFlying
    Character_Movement.MaxFlySpeed = Magic_Carpet_Max_Fly_Speed
    Character_Movement.BrakingDecelerationFlying = Magic_Carpet_Braking_Deceleration
end

--[[----------------------恢复服务端角色移动参数------------------------]]
function UGCPlayerController:Restore_Magic_Carpet_Movement()
    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家角色
    if not Player_Pawn.Magic_Carpet_Original_Max_Fly_Speed then
        return
    end

    local Character_Movement = Player_Pawn.CharacterMovement -- 角色移动组件
    Character_Movement.MaxFlySpeed = Player_Pawn.Magic_Carpet_Original_Max_Fly_Speed
    Character_Movement.BrakingDecelerationFlying = Player_Pawn.Magic_Carpet_Original_Braking_Deceleration
    Player_Pawn.Magic_Carpet_Original_Max_Fly_Speed = nil
    Player_Pawn.Magic_Carpet_Original_Braking_Deceleration = nil
end

--[[----------------------同步当前装备的飞行物------------------------]]
function UGCPlayerController:Update_Flying_Item(Item_ID, Is_Equipped)
    if not self:HasAuthority() then
        return
    end

    if not Is_Equipped and self.Flying_Item_ID ~= Item_ID then
        return
    end

    self:Set_Flying_Movement_Enabled(false)
    self:Restore_Magic_Carpet_Movement()
    self.Flying_Item_ID = Is_Equipped and Item_ID or 0
    if self.Flying_Item_ID == Magic_Carpet_Item_ID then
        self:Apply_Magic_Carpet_Movement()
        self:Set_Flying_Movement_Enabled(true)
    end
    UnrealNetwork.RepLazyProperty(self, "Flying_Item_ID")
    ugcprint(string.format("[FlyingItem] 装备状态同步：物品ID=%s", tostring(self.Flying_Item_ID)))
end

--[[----------------------获取塔内累计停留时间------------------------]]
function UGCPlayerController:GetTowerRewardElapsedTime()
    local Elapsed_Time = self.Tower_Reward_Accumulated_Time -- 当前累计停留秒数

    if self.Tower_Reward_Is_Timing then
        local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
        Elapsed_Time = Elapsed_Time + math.max(0, Current_Time - self.Tower_Reward_Enter_Time)
    end

    return math.floor(Elapsed_Time)
end

--[[----------------------同步塔内计时状态------------------------]]
function UGCPlayerController:SyncTowerRewardState()
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Has_Started")
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Is_Timing")
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Enter_Time")
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Accumulated_Time")
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Claim_Mask")
end

--[[----------------------开始或继续塔内奖励计时------------------------]]
function UGCPlayerController:StartTowerRewardTimer()
    if not self:HasAuthority() or self.Tower_Reward_Is_Timing then
        return
    end

    self.Tower_Reward_Has_Started = true
    self.Tower_Reward_Is_Timing = true
    self.Tower_Reward_Enter_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime())
    self:SyncTowerRewardState()
end

--[[----------------------暂停塔内奖励计时------------------------]]
function UGCPlayerController:PauseTowerRewardTimer()
    if not self:HasAuthority() or not self.Tower_Reward_Is_Timing then
        return
    end

    self.Tower_Reward_Accumulated_Time = self:GetTowerRewardElapsedTime()
    self.Tower_Reward_Is_Timing = false
    self.Tower_Reward_Enter_Time = 0
    self:SyncTowerRewardState()
end

--[[----------------------领取塔内计时奖励------------------------]]
function UGCPlayerController:Claim_Tower_Reward(Reward_Index)
    if not self:HasAuthority() then
        return
    end

    local Reward_Time = L_Enum.Tower_Reward.Reward_Times[Reward_Index] -- 当前档位要求秒数
    local Reward_Item_ID = L_Enum.Tower_Reward.Reward_Item_IDs[Reward_Index] -- 当前档位物品ID
    if not Reward_Time or not Reward_Item_ID then
        return
    end

    local Reward_Flag = 2 ^ (Reward_Index - 1) -- 当前档位领取状态位
    local Has_Claimed = math.floor(self.Tower_Reward_Claim_Mask / Reward_Flag) % 2 == 1 -- 是否已经领取
    if Has_Claimed or self:GetTowerRewardElapsedTime() < Reward_Time then
        return
    end

    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not Virtual_Item_Manager:AddVirtualItem(self, Reward_Item_ID, L_Enum.Tower_Reward.Reward_Item_Count) then
        return
    end

    self.Tower_Reward_Claim_Mask = self.Tower_Reward_Claim_Mask + Reward_Flag
    UnrealNetwork.RepLazyProperty(self, "Tower_Reward_Claim_Mask")
    L_TipsTool.ShowTips_01("领取奖励成功", self, SoundMgr.SoundName.Reward_Ready)
end

--[[----------------------给当前玩家添加背包物品------------------------]]
function UGCPlayerController:Add_Backpack_Item(Item_ID, Item_Count)
    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager")
    Virtual_Item_Manager:AddVirtualItem(self, Item_ID, Item_Count)
end

--[[----------------------使用奖杯兑换道具------------------------]]
function UGCPlayerController:Exchange_Trophy_Item(Item_ID)
    if not self:HasAuthority() then
        return
    end

    local Trophy_Price = L_Enum.Trophy_Shop.Item_Price_Config[Item_ID] -- 兑换所需奖杯数量
    if not Trophy_Price then
        return
    end

    local Trophy_Item_ID = L_Enum.Trophy_Shop.Trophy_Item_ID -- 奖杯物品ID
    if UGCBackpackSystemV2.GetItemCountV2(self, Trophy_Item_ID) < Trophy_Price then
        L_TipsTool.ShowTips_01("数量不足", self, SoundMgr.SoundName.UI_Error)
        return
    end

    local Removed_Count = UGCBackpackSystemV2.RemoveItemV2(self, Trophy_Item_ID, Trophy_Price) -- 实际扣除奖杯数量
    if Removed_Count ~= Trophy_Price then
        if Removed_Count > 0 then
            UGCBackpackSystemV2.AddItemV2(self, Trophy_Item_ID, Removed_Count)
        end
        L_TipsTool.ShowTips_01("数量不足", self, SoundMgr.SoundName.UI_Error)
        return
    end

    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not Virtual_Item_Manager:AddVirtualItem(self, Item_ID, 1) then
        UGCBackpackSystemV2.AddItemV2(self, Trophy_Item_ID, Trophy_Price)
        L_TipsTool.ShowTips_01("兑换失败", self, SoundMgr.SoundName.UI_Error)
        return
    end

    L_TipsTool.ShowTips_01("兑换成功", self, SoundMgr.SoundName.Reward_Gold)
end

--[[----------------------使用金币购买道具------------------------]]
function UGCPlayerController:Buy_Gold_Item(Item_ID)
    if not self:HasAuthority() then
        return
    end

    local Gold_Price = L_Enum.Gold_Shop.Item_Price_Config[Item_ID] -- 购买所需金币数量
    if not Gold_Price then
        return
    end

    local Gold_Item_ID = L_Enum.Gold_Shop.Gold_Item_ID -- 金币物品ID
    if UGCBackpackSystemV2.GetItemCountV2(self, Gold_Item_ID) < Gold_Price then
        L_TipsTool.ShowTips_01("数量不足", self, SoundMgr.SoundName.UI_Error)
        return
    end

    local Removed_Count = UGCBackpackSystemV2.RemoveItemV2(self, Gold_Item_ID, Gold_Price) -- 实际扣除金币数量
    if Removed_Count ~= Gold_Price then
        if Removed_Count > 0 then
            UGCBackpackSystemV2.AddItemV2(self, Gold_Item_ID, Removed_Count)
        end
        L_TipsTool.ShowTips_01("数量不足", self, SoundMgr.SoundName.UI_Error)
        return
    end

    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not Virtual_Item_Manager:AddVirtualItem(self, Item_ID, 1) then
        UGCBackpackSystemV2.AddItemV2(self, Gold_Item_ID, Gold_Price)
        L_TipsTool.ShowTips_01("购买失败", self, SoundMgr.SoundName.UI_Error)
        return
    end

    L_TipsTool.ShowTips_01("购买成功", self, SoundMgr.SoundName.Reward_Gold)
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

--[[----------------------切换陷阽物品对应的技能槽技能------------------------]]
function UGCPlayerController:Switch_Trap_Item_Skill(Item_ID)
    ugcprint(string.format("[TrapSkillDebug][服务端] RPC进入：物品ID=%s，控制器=%s，HasAuthority=%s",
        tostring(Item_ID), tostring(self), tostring(self:HasAuthority())))
    if not self:HasAuthority() then
        ugcprint("[TrapSkillDebug][服务端] RPC终止：当前控制器没有服务端权限")
        return
    end

    local Trap_Skill_Paths = { -- 陷阽物品对应的技能路径
        [8310021] = UGCGameSystem.GetUGCResourcesFullPath(
            "Asset/Blueprint/Prefabs/Skills/Skill04.Skill04_C"),
        [8310007] = UGCGameSystem.GetUGCResourcesFullPath(
            "Asset/Blueprint/Prefabs/Skills/Skill05.Skill05_C"),
        [8310026] = UGCGameSystem.GetUGCResourcesFullPath(
            "Asset/Blueprint/Prefabs/Skills/Skill06.Skill06_C")
    }
    local Trap_Skill_Slot = "Skill.Slot.Slot0" -- 陷阱技能共用的技能UI槽位
    local Selected_Skill_Path = Trap_Skill_Paths[Item_ID] -- 本次选择的技能路径
    local Is_Clear_Slot = Item_ID == 0 -- 是否只清空陷阱技能槽
    local Item_Count = Is_Clear_Slot and 0 or UGCBackpackSystemV2.GetItemCountV2(self, Item_ID) -- 服务端背包物品数量
    ugcprint(string.format("[TrapSkillDebug][服务端] 参数检查：技能路径=%s，技能槽=%s，服务端数量=%s",
        tostring(Selected_Skill_Path), tostring(Trap_Skill_Slot), tostring(Item_Count)))
    if not Is_Clear_Slot and (not Selected_Skill_Path or Item_Count <= 0) then
        ugcprint("[TrapSkillDebug][服务端] RPC终止：物品ID不合法或服务端数量不足")
        return
    end

    local Player_Pawn = self:GetPlayerCharacterSafety() -- 当前玩家角色
    ugcprint(string.format("[TrapSkillDebug][服务端] 当前玩家角色=%s", tostring(Player_Pawn)))
    local All_Skills_Before = UGCPersistEffectSystem.GetSkillsByClass(Player_Pawn, nil) or {} -- 切换前全部技能实例
    ugcprint(string.format("[TrapSkillDebug][服务端] 切换前玩家技能实例总数=%s", tostring(#All_Skills_Before)))
    for Skill_Index, Skill_Instance in ipairs(All_Skills_Before) do
        ugcprint(string.format("[TrapSkillDebug][服务端] 切换前技能：序号=%s，实例=%s，名称=%s，是否启用=%s",
            tostring(Skill_Index), tostring(Skill_Instance), tostring(Skill_Instance:GetSkillName()),
            tostring(Skill_Instance:IsSkillEnable())))
    end

    for Trap_Item_ID, Trap_Skill_Path in pairs(Trap_Skill_Paths) do
        local Skill_Instances = UGCPersistEffectSystem.GetSkillsByClass(Player_Pawn, Trap_Skill_Path) or {} -- 已有陷阱技能实例
        ugcprint(string.format("[TrapSkillDebug][服务端] 清理旧技能：物品ID=%s，技能路径=%s，实例数量=%s",
            tostring(Trap_Item_ID), tostring(Trap_Skill_Path), tostring(#Skill_Instances)))
        for _, Skill_Instance in ipairs(Skill_Instances) do
            local Skill_Name = Skill_Instance:GetSkillName() -- 旧技能名称
            local Skill_Instance_Text = tostring(Skill_Instance) -- 旧技能实例文本
            local Remove_Result = UGCPersistEffectSystem.RemoveSkillInstance(Player_Pawn, Skill_Instance) -- 移除结果
            ugcprint(string.format("[TrapSkillDebug][服务端] 移除旧技能：实例=%s，名称=%s，结果=%s",
                Skill_Instance_Text, tostring(Skill_Name), tostring(Remove_Result)))
        end
    end

    if Is_Clear_Slot then
        ugcprint("[TrapSkillDebug][服务端] 陷阽物品已全部耗尽，技能槽清理完成")
    else
        local Selected_Skill_Instance = UGCPersistEffectSystem.AddSkillByClass(Player_Pawn, Selected_Skill_Path, -1,
                                            Trap_Skill_Slot) -- 新增并绑定到技能UI槽位的技能实例
        ugcprint(string.format(
            "[TrapSkillDebug][服务端] AddSkillByClass完成：物品ID=%s，技能路径=%s，技能槽=%s，实例=%s",
            tostring(Item_ID), tostring(Selected_Skill_Path), tostring(Trap_Skill_Slot),
            tostring(Selected_Skill_Instance)))
        if Selected_Skill_Instance then
            ugcprint(string.format("[TrapSkillDebug][服务端] 新技能状态：名称=%s，是否启用=%s",
                tostring(Selected_Skill_Instance:GetSkillName()), tostring(Selected_Skill_Instance:IsSkillEnable())))
        else
            ugcprint("[TrapSkillDebug][服务端] 关键异常：AddSkillByClass未返回技能实例")
        end
    end

    local All_Skills_After = UGCPersistEffectSystem.GetSkillsByClass(Player_Pawn, nil) or {} -- 切换后全部技能实例
    ugcprint(string.format("[TrapSkillDebug][服务端] 切换结束，玩家技能实例总数=%s", tostring(#All_Skills_After)))
    for Skill_Index, Skill_Instance in ipairs(All_Skills_After) do
        ugcprint(string.format("[TrapSkillDebug][服务端] 切换后技能：序号=%s，实例=%s，名称=%s，是否启用=%s",
            tostring(Skill_Index), tostring(Skill_Instance), tostring(Skill_Instance:GetSkillName()),
            tostring(Skill_Instance:IsSkillEnable())))
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
function UGCPlayerController:Tool_Msg_01(str, Sound_Name)
    TipsMgr.ShowTips_01(str)
    if Sound_Name then
        SoundMgr.PlaySound2D(Sound_Name)
    end
end

--[[----------------------显示房间密码界面------------------------]]
function UGCPlayerController:Show_Room_Pass_UI(Room_Pass)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.kj01, true)
    L_GloTools.UI_Map[L_Enum.Name_ClassPath.kj01]:SetRoomPass(Room_Pass)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end
--[[----------------------通知警示区域------------------------]] --

function UGCPlayerController:Mgr_Atten(bool)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_Attention, bool)
end
--[[----------------------请求复活当前玩家------------------------]]
function UGCPlayerController:RequestRespawn(Return_To_Death_Location)
    if Return_To_Death_Location then
        local Return_Scroll_Item_ID = 8310002 -- 返回卷背包物品ID
        if UGCBackpackSystemV2.GetItemCountV2(self, Return_Scroll_Item_ID) < 1 then
            UnrealNetwork.CallUnrealRPC(self, self, L_Enum.Name_RPC.Show_Respawn_UI)
            return
        end

        local Removed_Count = UGCBackpackSystemV2.RemoveItemV2(self, Return_Scroll_Item_ID, 1) -- 实际扣除返回卷数量
        if Removed_Count ~= 1 then
            UnrealNetwork.CallUnrealRPC(self, self, L_Enum.Name_RPC.Show_Respawn_UI)
            return
        end
    end

    self.Return_To_Death_Location = Return_To_Death_Location
    UGCPlayerPawnSystem.RespawnPlayer(self.PlayerKey, 0, false, 0.01)
end
--[[----------------------显示复活界面------------------------]]
function UGCPlayerController:ShowRespawnUI()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, true)
    L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI09]:RefreshReturnScrollCount()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_Attention, false)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
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

--[[----------------------刷新飞行物控制界面------------------------]]
function UGCPlayerController:OnRep_Flying_Item_ID()
    local UI_Path = L_Enum.Name_ClassPath.UI_Fly -- 飞行物控制界面路径
    L_GloTools.UIMgr(UI_Path, self.Flying_Item_ID ~= 0)

    local Fly_UI = L_GloTools.UI_Map[UI_Path] -- 已创建的飞行物控制界面
    if Fly_UI then
        Fly_UI:SetFlyingItem(self.Flying_Item_ID)
    end
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
