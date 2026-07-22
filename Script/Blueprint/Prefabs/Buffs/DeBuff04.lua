---@class DeBuff04_C:PersistEffectBuff
--Edit Below--
local DeBuff04 = {}
 
-- buff启动条件
--[[
function DeBuff04:CanApply_BP(OwnerActor)
-- return true
end
--]]

--[[----------------------Buff挂载时开启反向移动------------------------]]
function DeBuff04:OnApply_BP(OwnerActor)
    if not self:HasAuthority() and self:IsAutonomous(true) then
        OwnerActor:SetReverseMoveEnabled(true)
    end
end

--[[----------------------Buff移除时关闭反向移动------------------------]]
function DeBuff04:OnUnApply_BP(OwnerActor, Reason)
    if not self:HasAuthority() and self:IsAutonomous(true) then
        OwnerActor:SetReverseMoveEnabled(false)
    end
end

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function DeBuff04:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function DeBuff04:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function DeBuff04:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function DeBuff04:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function DeBuff04:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function DeBuff04:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function DeBuff04:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function DeBuff04:OnTrigger_BP(Delta)

end
--]]

return DeBuff04
