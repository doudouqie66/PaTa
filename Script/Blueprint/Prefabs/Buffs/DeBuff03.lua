---@class DeBuff03_C:PersistEffectBuff
--Edit Below--
local DeBuff03 = {}
 
-- buff启动条件
--[[
function DeBuff03:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff开始
--[[
function DeBuff03:OnApply_BP(OwnerActor)

end
--]]

-- buff结束
--[[
function DeBuff03:OnUnApply_BP(OwnerActor, Reason)

end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function DeBuff03:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function DeBuff03:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function DeBuff03:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function DeBuff03:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function DeBuff03:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function DeBuff03:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function DeBuff03:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function DeBuff03:OnTrigger_BP(Delta)

end
--]]

return DeBuff03