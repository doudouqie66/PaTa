---@class Buff06_C:PersistEffectBuff
-- Edit Below--
---@class Buff06_C:PersistEffectBuff
-- Edit Below--
---@class Buff04_C:PersistEffectBuff
-- Edit Below--
local Buff06 = {}

-- buff启动条件
--[[
function Buff06:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff开始
--[[----------------------Buff挂载时增加0.5的跳跃高度------------------------]]
function Buff06:OnApply_BP(OwnerActor)
    if self:HasAuthority() then
        self.Jump_Z_Speed_Operation_ID = UGCAttributeSystem.AddGameAttributeOperation(OwnerActor, "JumpZSpeed",
            EAttrOperator.Plus, 600)
    end
end

-- buff结束
--[[----------------------Buff移除时回复跳跃高度------------------------]]
function Buff06:OnUnApply_BP(OwnerActor, Reason)
    if self:HasAuthority() and self.Jump_Z_Speed_Operation_ID then
        UGCAttributeSystem.RemoveGameAttributeOperation(OwnerActor, self.Jump_Z_Speed_Operation_ID)
    end
end

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff06:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff06:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff06:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff06:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff06:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff06:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff06:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff06:OnTrigger_BP(Delta)

end
--]]

return Buff06
