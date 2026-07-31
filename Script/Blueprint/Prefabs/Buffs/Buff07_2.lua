---@class Buff07_2_C:PersistEffectBuff
--Edit Below--
local Buff07_2 = {}

--[[----------------------Buff挂载时开启控制和陷阱免疫------------------------]]
function Buff07_2:OnApply_BP(OwnerActor)
    if self:HasAuthority() then
        OwnerActor.Control_Immune_Buff_Count = (OwnerActor.Control_Immune_Buff_Count or 0) + 1 -- 控制免疫Buff数量
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.Debuff.Dizzy", true, true)
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.AddtiveState.OnStun", true, true)
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.AddtiveState.HitFly", true, true)
        self.Hit_Back_Resist_Operation_ID = UGCAttributeSystem.AddGameAttributeOperation(OwnerActor, "HitBackResist",
            EAttrOperator.Plus, 1) -- 击退抗性修改ID
    end
end

--[[----------------------Buff移除时关闭控制和陷阱免疫------------------------]]
function Buff07_2:OnUnApply_BP(OwnerActor, Reason)
    if self:HasAuthority() then
        OwnerActor.Control_Immune_Buff_Count = math.max((OwnerActor.Control_Immune_Buff_Count or 1) - 1, 0) -- 剩余控制免疫Buff数量
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.Debuff.Dizzy", false, false)
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.AddtiveState.OnStun", false, false)
        UGCPersistEffectSystem.SetDynamicStateDisabled(OwnerActor, "PawnState.AddtiveState.HitFly", false, false)
        if self.Hit_Back_Resist_Operation_ID then
            UGCAttributeSystem.RemoveGameAttributeOperation(OwnerActor, self.Hit_Back_Resist_Operation_ID)
        end
    end
end
-- buff启动条件
--[[
function Buff07_2:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff开始
--[[
function Buff07_2:OnApply_BP(OwnerActor)

end
--]]

-- buff结束
--[[
function Buff07_2:OnUnApply_BP(OwnerActor, Reason)

end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff07_2:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff07_2:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff07_2:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff07_2:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff07_2:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff07_2:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff07_2:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff07_2:OnTrigger_BP(Delta)

end
--]]

return Buff07_2
