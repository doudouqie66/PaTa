---@class Buff10_C:PersistEffectBuff
--Edit Below--
---@class Buff10_C:PersistEffectBuff
-- Edit Below--
local Buff10 = {}
local L_Enum = UGCGameSystem.UGCRequire("Script.L_Com.L_Enum") -- 枚举配置

-- buff启动条件
--[[
function Buff10:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff10:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff10:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff10:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff10:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff10:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff10:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff10:CanTrigger_BP()
	return true
end
--]]

--[[----------------------根据增益状态给玩家添加金币------------------------]]
function Buff10:GiveGold(Delta)
    if self:HasAuthority() then
        local Owner_Actor = self:GetOwnerActor() -- Buff所属玩家角色
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Owner_Actor) -- 获取玩家控制器
        local Pass_Need = Player_Controller.Run_Area_Num_PassNeed -- 当前区域要求的通关次数
        local Gold_Count = 2 -- 本次获得的金币数量
        local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
        local Is_Week_Card_Member = Player_Controller.WeekEndTime and Current_Time < Player_Controller.WeekEndTime -- 是否为周卡会员
        if Player_Controller.Run_Area_Type == 2 and not Is_Week_Card_Member then
            L_TipsTool.ShowTips_01("您不是周卡会员", Player_Controller, SoundMgr.SoundName.UI_Error)
            return
        end
        if Player_Controller.Run_Area_Type == 2 then
            if Pass_Need == 10 then
                Gold_Count = 15
            elseif Pass_Need == 5 then
                Gold_Count = 10
            elseif Pass_Need == 2 then
                Gold_Count = 8
            else
                Gold_Count = 3
            end
        elseif Pass_Need == 10 then
            Gold_Count = 10
        elseif Pass_Need == 5 then
            Gold_Count = 8
        elseif Pass_Need == 2 then
            Gold_Count = 5
        end
        local Double_Gold_Buff_Class = UGCObjectUtility.LoadClass(L_Enum.Name_BuffPath.Buff09) -- 金币翻倍Buff类
        if #UGCPersistEffectSystem.GetBuffsByClass(Owner_Actor, Double_Gold_Buff_Class) > 0 then
            Gold_Count = Gold_Count * 2
        end
        UGCBackpackSystemV2.AddItemV2(Owner_Actor, 8310003, Gold_Count)
        L_TipsTool.ShowTips_01("金币加" .. Gold_Count, Player_Controller, SoundMgr.SoundName.Reward_Gold)
    end
end

return Buff10
