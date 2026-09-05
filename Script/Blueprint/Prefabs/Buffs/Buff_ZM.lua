---@class Buff_ZM_C:PersistEffectBuff
--Edit Below--
local Base_Monse = require("Script.Blueprint.Prefabs.Monsters.BaseMonse") -- 基础怪物逻辑
local Buff_ZM = {}

--[[----------------------Buff生效时致盲怪物并清除仇恨------------------------]]
function Buff_ZM:OnApply_BP(OwnerActor)
    if not self:HasAuthority() then
        return
    end

    OwnerActor.Is_Blinded = true
    Base_Monse.SetAlertVisible(OwnerActor, false)
    if OwnerActor.Force_Hatred_Timer then
        UGCTimerUtility.RemoveLuaTimer(OwnerActor.Force_Hatred_Timer)
        OwnerActor.Force_Hatred_Timer = nil -- 清空强制追击计时器
    end
    OwnerActor.Last_Hit_Target = nil
    OwnerActor.Alert_Hatred_Target = nil -- 清空警报仇恨目标
    OwnerActor:RemoveForceHatredTarget()
end

--[[----------------------Buff结束时恢复怪物寻敌------------------------]]
function Buff_ZM:OnUnApply_BP(OwnerActor, Reason)
    if not self:HasAuthority() then
        return
    end

    OwnerActor.Is_Blinded = false
    Base_Monse.SetAlertVisible(OwnerActor, true)
    Base_Monse.RefAlertHatred(OwnerActor)
end

-- buff启动条件
--[[
function Buff_ZM:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff_ZM:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff_ZM:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff_ZM:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff_ZM:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff_ZM:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff_ZM:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff_ZM:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff_ZM:OnTrigger_BP(Delta)

end
--]]

return Buff_ZM
