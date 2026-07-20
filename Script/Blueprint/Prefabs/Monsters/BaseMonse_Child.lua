---@class BaseMonse_Child_C:BaseMonse_C
-- Edit Below--
---@class BaseMonse_Child_C:BaseMonse_C
-- Edit Below--
local BaseMonse_Child = {}

--[[----------------------初始化怪物碰撞逻辑------------------------]]
function BaseMonse_Child:ReceiveBeginPlay()
    -- BaseMonse_Child.SuperClass.ReceiveBeginPlay(self)
    BaseMonse_Child.BindOverlapEvent(self)
end

--[[----------------------绑定怪物碰撞事件------------------------]]
function BaseMonse_Child:BindOverlapEvent()
    if self.bOverlapEventBinded then
        return
    end

    if self.OutBox == nil or self.InnerBox == nil then
        return
    end

    self.bOverlapEventBinded = true

    self.OutBox.OnComponentBeginOverlap:Add(self.OutBox_OnComponentBeginOverlap, self);
    self.OutBox.OnComponentEndOverlap:Add(self.OutBox_OnComponentEndOverlap, self);
    self.InnerBox.OnComponentBeginOverlap:Add(self.InnerBox_OnComponentBeginOverlap, self);
    self.InnerBox.OnComponentEndOverlap:Add(self.InnerBox_OnComponentEndOverlap, self);
end

-- function BaseMonse_Child:ReceiveTick(DeltaTime)
--     BaseMonse_Child.SuperClass.ReceiveTick(self, DeltaTime)
-- end

-- function BaseMonse_Child:ReceiveEndPlay()
--     BaseMonse_Child.SuperClass.ReceiveEndPlay(self) 
-- end

-- function BaseMonse_Child:GetReplicatedProperties()
--     return
-- end

-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonse_Child:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end

-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonse_Child:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end

-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonse_Child:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonse_Child:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

---角色死亡事件
---生效范围：服务器&客户端
---@param Damage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param FDamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
function BaseMonse_Child:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    if self:HasAuthority() then
        -- 只有服务端才可以掉落
        self.UGCPresetCommonDropItemComponent:StartDrop(self, EventInstigator, {})
    end
end

-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function BaseMonse_Child:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function BaseMonse_Child:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function BaseMonse_Child:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
-- end

-- ---行为树消息
-- ---生效范围：服务器
-- ---@param NotifyMsg string 消息
-- function BaseMonse_Child:OnBehaviorNotify_BP(NotifyMsg)
-- end

-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
-- function BaseMonse_Child:OnTargetChange_BP(NewTarget, OldTarget)

-- end

--[[----------------------进入警示区域------------------------]]
function BaseMonse_Child:OutBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end

    self.Attention_Player_Map = self.Attention_Player_Map or {}  -- 记录本怪物警示范围内的玩家
    if self.Attention_Player_Map[PC] then
        return
    end

    self.Attention_Player_Map[PC] = true
    PC.Attention_Overlap_Count = (PC.Attention_Overlap_Count or 0) + 1  -- 记录玩家处于警示范围的怪物数量
    if PC.Attention_Overlap_Count == 1 then
        -- 通知进入警示区域
        UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, true)
    end
end

--[[----------------------离开警示区域------------------------]]
function BaseMonse_Child:OutBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end

    if self.Attention_Player_Map == nil or not self.Attention_Player_Map[PC] then
        return
    end

    self.Attention_Player_Map[PC] = nil
    PC.Attention_Overlap_Count = math.max((PC.Attention_Overlap_Count or 1) - 1, 0)  -- 减少玩家处于警示范围的怪物数量
    if PC.Attention_Overlap_Count == 0 then
        -- 通知退出警示区域
        UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, false)
    end
end

--[[----------------------进入内部碰撞区域------------------------]]
function BaseMonse_Child:InnerBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
end

--[[----------------------离开内部碰撞区域------------------------]]
function BaseMonse_Child:InnerBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
end

return BaseMonse_Child
