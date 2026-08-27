---@class RunArea_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
---@field Type int32
---@field Num_PassNeed int32
--Edit Below--
local RunArea = {}

--[[----------------------初始化并绑定区域碰撞事件------------------------]]
function RunArea:ReceiveBeginPlay()
    RunArea.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
        self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self)
    end
end

--[[
function RunArea:ReceiveTick(DeltaTime)
    RunArea.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function RunArea:ReceiveEndPlay()
    RunArea.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function RunArea:GetReplicatedProperties()
    return
end
--]]

--[[
function RunArea:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function RunArea:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:

    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------将不符合条件的玩家弹出区域------------------------]]
function RunArea:EjectPlayer(Player_Pawn)
    local Area_Location = self.Box:K2_GetComponentLocation() -- 区域中心位置
    local Player_Location = Player_Pawn:K2_GetActorLocation() -- 玩家当前位置
    Area_Location.Z = Player_Location.Z
    local Eject_Direction = UGCMathUtility.GetDirectionUnitVector(Area_Location, Player_Location) -- 区域向外弹飞方向
    local Eject_Skill_Slot = "Skill.Slot.RunArea" -- 区域弹飞技能专用隐藏槽位
    local Eject_Skill = UGCPersistEffectSystem.AddSkillByClass(Player_Pawn, L_Enum.Name_SkillPath.Skill_RunArea, 1,
        Eject_Skill_Slot) -- 区域弹飞技能实例
    if Eject_Skill then
        Eject_Skill:SetSelectTargetOneActor(Player_Pawn)
        Eject_Skill:SetSelectDirection(Eject_Direction)
        Eject_Skill:ActivateSkill()
    end
end

--[[----------------------玩家进入区域时添加金币Buff------------------------]]
function RunArea:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 触碰玩家控制器
    if Player_Controller == nil then
        return
    end

    if Player_Controller.WinCup < self.Num_PassNeed then
        L_TipsTool.ShowTips_01("通关次数不足", Player_Controller)
        self:EjectPlayer(OtherActor)
        return
    end

    local Current_Time = UGCGameSystem.GetServerTimeSec() -- 当前服务器时间
    local Is_Week_Card_Member = Player_Controller.WeekEndTime and Current_Time < Player_Controller.WeekEndTime -- 是否为周卡会员
    if self.Type == 2 and not Is_Week_Card_Member then
        L_TipsTool.ShowTips_01("您不是周卡会员", Player_Controller)
        self:EjectPlayer(OtherActor)
        return
    end

    Player_Controller.Run_Area_Type = self.Type -- 当前金币区域类型
    Player_Controller.Run_Area_Num_PassNeed = self.Num_PassNeed -- 当前金币区域要求的通关次数
    L_TipsTool.ShowTips_01("进入区域")
    EventScheduler:_AddBuffToOnePlayers(OtherActor, L_Enum.Name_BuffPath.Buff10)
    L_GloTools.SetAnimMontage(Player_Controller, L_Enum.Name_AnimMontagePath.Run_Area_Sprint, true)
end

--[[----------------------玩家离开区域时移除金币Buff------------------------]]
function RunArea:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 触碰玩家控制器
    if Player_Controller == nil then
        return
    end

    if Player_Controller.Run_Area_Type ~= self.Type or
        Player_Controller.Run_Area_Num_PassNeed ~= self.Num_PassNeed then
        return
    end

    L_TipsTool.ShowTips_01("离开区域")
    EventScheduler:_RemoveBuffFromOnePlayers(OtherActor, L_Enum.Name_BuffPath.Buff10)
    Player_Controller.Run_Area_Type = 0 -- 清除当前金币区域类型
    Player_Controller.Run_Area_Num_PassNeed = 0 -- 清除当前金币区域要求的通关次数
    L_GloTools.SetAnimMontage(Player_Controller, L_Enum.Name_AnimMontagePath.Run_Area_Sprint, false)
end

-- [Editor Generated Lua] function define End;

return RunArea
