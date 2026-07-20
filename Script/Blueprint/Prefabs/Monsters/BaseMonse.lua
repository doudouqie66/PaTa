---@class BaseMonse_C:BP_UGC_GenericMobPawn_Base_C
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
local BaseMonse = {}

-- --[[----------------------初始化怪物逻辑------------------------]]
function BaseMonse:ReceiveBeginPlay()
    BaseMonse.SuperClass.ReceiveBeginPlay(self)
    BaseMonse.BindOverlapEvent(self)
end

--[[----------------------绑定怪物碰撞事件------------------------]]
function BaseMonse:BindOverlapEvent()
    -- if self.bOverlapEventBinded then
    --     return
    -- end

    -- if self.OutBox == nil or self.InnerBox == nil then
    --     return
    -- end

    -- self.bOverlapEventBinded = true

    self.OutBox.OnComponentBeginOverlap:Add(BaseMonse.OutBox_OnComponentBeginOverlap, self);
    self.OutBox.OnComponentEndOverlap:Add(BaseMonse.OutBox_OnComponentEndOverlap, self);
    self.InnerBox.OnComponentBeginOverlap:Add(BaseMonse.InnerBox_OnComponentBeginOverlap, self);
    self.InnerBox.OnComponentEndOverlap:Add(BaseMonse.InnerBox_OnComponentEndOverlap, self);
end

-- function BaseMonse:ReceiveTick(DeltaTime)
--     BaseMonse.SuperClass.ReceiveTick(self, DeltaTime)
-- end

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

-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonse:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end

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
function BaseMonse:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
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
-- function BaseMonse:OnTargetChange_BP(NewTarget, OldTarget)

-- end

-- [Editor Generated Lua] function define Begin:
function BaseMonse:LuaInit()
    -- if self.bInitDoOnce then
    --     return;
    -- end
    -- self.bInitDoOnce = true;

    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

--[[--------------------开始碰撞，警示--------------------------]] --
function BaseMonse:OutBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end
    -- 通知进入警示区域
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, true)
end

--[[--------------------离开碰撞，取消警示--------------------------]] --

function BaseMonse:OutBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if not self:HasAuthority() then
        return
    end

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end
    -- 通知退出警示区域
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Mgr_Atten, false)
end

--[[----------------------内部碰撞体，死亡------------------------]] --
function BaseMonse:InnerBox_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
end

function BaseMonse:InnerBox_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
end

-- [Editor Generated Lua] function define End;

return BaseMonse
