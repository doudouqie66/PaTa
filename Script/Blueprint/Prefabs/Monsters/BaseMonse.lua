---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
---@field CustomParticleSystem1 UCustomParticleSystemComponent
---@field CustomParticleSystem UCustomParticleSystemComponent
---@field InnerBox UBoxComponent
---@field OutBox UBoxComponent
---@field HitBox UCapsuleComponent
--Edit Below--
---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
---@field InnerBox UBoxComponent
---@field OutBox UBoxComponent
---@field HitBox UCapsuleComponent
-- Edit Below--
---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
---@field InnerBox UBoxComponent
---@field OutBox UBoxComponent
---@field HitBox UCapsuleComponent
-- Edit Below--
---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
---@field InnerBox UBoxComponent
---@field OutBox UBoxComponent
---@field HitBox UCapsuleComponent
-- Edit Below--
---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
---@field InnerBox UBoxComponent
---@field OutBox UBoxComponent
---@field HitBox UCapsuleComponent
-- Edit Below--
local BaseMonse = {}
local Pistol_Item_ID = 8310045 -- 手枪物品ID
local Force_Hatred_Duration = 10 -- 强制追击持续时间

--[[----------------------初始化怪物逻辑------------------------]]
function BaseMonse:ReceiveBeginPlay()
    BaseMonse.SuperClass.ReceiveBeginPlay(self)
    self.Alert_Player_Count = {} -- 警报范围内玩家重叠次数
    self.Alert_Hatred_Target = nil -- 当前警报随机仇恨目标
    self.Is_Blinded = false -- 是否处于致盲状态
    BaseMonse.BindOverlapEvent(self)
end

--[[----------------------绑定怪物碰撞事件------------------------]]
function BaseMonse:BindOverlapEvent()
    if self.bOverlapEventBinded then
        return
    end

    if self.OutBox == nil or self.InnerBox == nil then
        return
    end

    self.bOverlapEventBinded = true

    self.OutBox.OnComponentBeginOverlap:Add(BaseMonse.OutBox_OnComponentBeginOverlap, self);
    self.OutBox.OnComponentEndOverlap:Add(BaseMonse.OutBox_OnComponentEndOverlap, self);
    self.InnerBox.OnComponentBeginOverlap:Add(BaseMonse.InnerBox_OnComponentBeginOverlap, self);
    self.InnerBox.OnComponentEndOverlap:Add(BaseMonse.InnerBox_OnComponentEndOverlap, self);
end

--[[----------------------设置警报范围内玩家的警告显示------------------------]]
function BaseMonse:SetAlertVisible(Is_Visible)
    for Player, Overlap_Count in pairs(self.Alert_Player_Count) do
        if UE.IsValid(Player) and Overlap_Count > 0 and
            (not Is_Visible or not Player.Is_In_Monster_Safe_Area) then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(Player)
            if PC then
                local Monster_Actor = nil -- 警告音效附着的怪物
                if Is_Visible then
                    Monster_Actor = self
                end
                UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, Is_Visible, Monster_Actor)
            end
        end
    end
end

--[[----------------------刷新警报范围内随机仇恨目标------------------------]]
function BaseMonse:RefAlertHatred()
    if not self:HasAuthority() or self.Is_Blinded or self.Force_Hatred_Timer then
        return
    end

    local Available_Players = {} -- 可成为仇恨目标的玩家
    for Player, Overlap_Count in pairs(self.Alert_Player_Count) do
        if not UE.IsValid(Player) then
            self.Alert_Player_Count[Player] = nil
        elseif Overlap_Count > 0 and not Player.Is_In_Monster_Safe_Area then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(Player)
            if PC then
                local Player_Key = UGCGameSystem.GetPlayerKeyByPlayerController(PC) -- 玩家唯一标识
                if Player_Key ~= -1 and UGCPlayerStateSystem.IsAlive(Player_Key) then
                    table.insert(Available_Players, Player)
                end
            end
        end
    end

    if #Available_Players == 0 then
        self.Alert_Hatred_Target = nil
        self:RemoveForceHatredTarget()
        return
    end

    local Random_Target = Available_Players[math.random(#Available_Players)] -- 随机仇恨目标
    self.Alert_Hatred_Target = Random_Target
    self:SetForceHatredTarget(Random_Target)
end

--[[----------------------检查仇恨目标是否进入安全区------------------------]]
function BaseMonse:ReceiveTick(DeltaTime)
    BaseMonse.SuperClass.ReceiveTick(self, DeltaTime)
    if not self:HasAuthority() then
        return
    end

    if self.Last_Hit_Target ~= nil and
        (not UE.IsValid(self.Last_Hit_Target) or self.Last_Hit_Target.Is_In_Monster_Safe_Area) then
        if self.Force_Hatred_Timer then
            UGCTimerUtility.RemoveLuaTimer(self.Force_Hatred_Timer)
            self.Force_Hatred_Timer = nil -- 清空强制追击计时器
        end
        self.Last_Hit_Target = nil
        BaseMonse.RefAlertHatred(self)
        if self.Alert_Hatred_Target == nil then
            UGCGenericCharacterSystem.StopMove(self)
        end
        return
    end

    if self.Alert_Hatred_Target ~= nil and
        (not UE.IsValid(self.Alert_Hatred_Target) or self.Alert_Hatred_Target.Is_In_Monster_Safe_Area) then
        self.Alert_Hatred_Target = nil
        BaseMonse.RefAlertHatred(self)
        if self.Alert_Hatred_Target == nil then
            UGCGenericCharacterSystem.StopMove(self)
        end
    end
end

-- function BaseMonse:ReceiveEndPlay()
--     BaseMonse.SuperClass.ReceiveEndPlay(self) 
-- end

-- function BaseMonse:GetReplicatedProperties()
--     return
-- end

-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonse:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end

---受击后置事件
---生效范围：服务器
---@param Damage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param DamageContext FGameMagnitudeContext  伤害上下文
--[[----------------------将手枪命中的玩家设为最新仇恨目标------------------------]]
function BaseMonse:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
    if self.Is_Blinded or Damage <= 0 or EventInstigator == nil then
        return
    end

    local Hit_Player = EventInstigator:K2_GetPawn() -- 本次命中的玩家
    if Hit_Player == nil or Hit_Player.Is_In_Monster_Safe_Area then
        return
    end

    local Current_Weapon = UGCWeaponManagerSystem.GetCurrentWeapon(Hit_Player) -- 玩家当前武器
    if Current_Weapon == nil or UGCWeaponManagerSystem.GetWeaponItemID(Current_Weapon) ~= Pistol_Item_ID then
        return
    end

    self.Last_Hit_Target = Hit_Player -- 记录最后命中的玩家
    self.Alert_Hatred_Target = nil -- 枪击仇恨覆盖警报随机仇恨
    self:SetForceHatredTarget(Hit_Player)

    if self.Force_Hatred_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Force_Hatred_Timer)
    end

    local Chase_Target = Hit_Player -- 本次强制追击目标
    self.Force_Hatred_Timer = UGCTimerUtility.CreateLuaTimer(Force_Hatred_Duration, function()
        self.Force_Hatred_Timer = nil -- 清空强制追击计时器
        if self.Last_Hit_Target ~= Chase_Target then
            return
        end

        self.Last_Hit_Target = nil
        BaseMonse.RefAlertHatred(self)
    end, false)
end

-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonse:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonse:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

---角色死亡事件
---生效范围：服务器&客户端
---@param Damage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param FDamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
--[[----------------------处理怪物死亡与掉落------------------------]]
function BaseMonse:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    if self.Force_Hatred_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Force_Hatred_Timer)
        self.Force_Hatred_Timer = nil -- 清空强制追击计时器
    end
    self.Alert_Player_Count = {} -- 清空警报范围玩家
    self.Alert_Hatred_Target = nil -- 清空警报仇恨目标

    if self:HasAuthority() then
        -- 只有服务端才可以掉落
        self.UGCPresetCommonDropItemComponent:StartDrop(self, EventInstigator, {})
    end
end

-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function BaseMonse:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function BaseMonse:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function BaseMonse:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---行为树消息
-- ---生效范围：服务器
-- ---@param NotifyMsg string 消息
-- function BaseMonse:OnBehaviorNotify_BP(NotifyMsg)
-- end

-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
--[[----------------------仇恨目标丢失后重新选择目标------------------------]]
function BaseMonse:OnTargetChange_BP(NewTarget, OldTarget)
    if not self:HasAuthority() or NewTarget ~= nil then
        return
    end

    if self.Force_Hatred_Timer and self.Last_Hit_Target == OldTarget then
        UGCTimerUtility.RemoveLuaTimer(self.Force_Hatred_Timer)
        self.Force_Hatred_Timer = nil -- 清空已失效的枪击仇恨计时器
        self.Last_Hit_Target = nil
        BaseMonse.RefAlertHatred(self)
        return
    end

    if self.Force_Hatred_Timer == nil and self.Alert_Hatred_Target == OldTarget then
        self.Alert_Hatred_Target = nil
        BaseMonse.RefAlertHatred(self)
    end
end

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化Lua绑定------------------------]]
function BaseMonse:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;

    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

local Inner_Box_Death_Damage = 9999999 -- 内部碰撞体致命伤害

--[[----------------------玩家进入警报范围------------------------]]
function BaseMonse:OutBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end

    if OtherActor.Is_In_Monster_Safe_Area then
        return
    end

    local Overlap_Count = self.Alert_Player_Count[OtherActor] or 0 -- 当前玩家重叠次数
    self.Alert_Player_Count[OtherActor] = Overlap_Count + 1
    if Overlap_Count > 0 then
        return
    end

    if not self.Is_Blinded then
        UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, true, self)
    end
    BaseMonse.RefAlertHatred(self)
end

--[[----------------------玩家离开警报范围------------------------]]
function BaseMonse:OutBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end

    local Overlap_Count = self.Alert_Player_Count[OtherActor]
    if Overlap_Count == nil then
        return
    end

    if Overlap_Count > 1 then
        self.Alert_Player_Count[OtherActor] = Overlap_Count - 1
        return
    end

    self.Alert_Player_Count[OtherActor] = nil
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, false)
    if self.Force_Hatred_Timer == nil and self.Alert_Hatred_Target == OtherActor then
        BaseMonse.RefAlertHatred(self)
    end
end

--[[----------------------内部碰撞体，死亡------------------------]] --
function BaseMonse:InnerBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end

    if OtherActor.Is_In_Monster_Safe_Area then
        return
    end

    local Buff04_Class = UGCObjectUtility.LoadClass(L_Enum.Name_BuffPath.Buff04) -- 无敌Buff类
    if #UGCPersistEffectSystem.GetBuffsByClass(OtherActor, Buff04_Class) > 0 then
        return
    end

    PC.Death_Location = OtherActor:K2_GetActorLocation() -- 玩家死亡位置
    PC.Is_Monster_Death = true -- 标记为怪物内部碰撞体致死
    UGCPlayerPawnSystem.SetIsDirectlyDie(OtherActor, true)
    UGCGameSystem.ApplyDamage(OtherActor, Inner_Box_Death_Damage, nil, self, {})
    if PC.Is_Monster_Death then
        PC.Is_Monster_Death = false -- 伤害未致死时重置怪物致死标记
    end

end

--[[----------------------结束内部碰撞------------------------]]
function BaseMonse:InnerBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
end

-- [Editor Generated Lua] function define End;

return BaseMonse
