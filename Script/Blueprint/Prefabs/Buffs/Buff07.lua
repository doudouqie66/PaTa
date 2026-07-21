---@class Buff07_C:PersistEffectBuff
-- Edit Below--
local Buff07 = {}

-- buff开始
--[[----------------------Buff挂载时开启Debuff无效------------------------]]
function Buff07:OnApply_BP(OwnerActor)
end

-- buff结束
--[[----------------------Buff移除时关闭Debuff无效------------------------]]
function Buff07:OnUnApply_BP(OwnerActor, Reason)
end
-- buff启动条件
--[[
function Buff07:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff开始
--[[
function Buff07:OnApply_BP(OwnerActor)

end
--]]

-- buff结束
--[[
function Buff07:OnUnApply_BP(OwnerActor, Reason)

end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff07:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff07:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff07:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff07:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff07:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff07:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff07:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff07:OnTrigger_BP(Delta)

end
--]]

return Buff07
