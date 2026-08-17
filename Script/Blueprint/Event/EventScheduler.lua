EventScheduler = EventScheduler or {}
local L_Enum = UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')
local L_TipsTool = UGCGameSystem.UGCRequire('Script.L_Com.L_TipsTool')
EventScheduler.Tower_Players = EventScheduler.Tower_Players or {} -- 当前在塔内的玩家
local Ammo_Grant_Interval = 30 -- 火箭弹发放间隔秒数
local SQ_Ammo_Item_ID = 8310046 -- RPG火箭弹物品ID

--[[---------------------启动事件循环-------------------------]] --
function EventScheduler.Start()
    EventScheduler.Elapsed = 0
    UGCTimerUtility.CreateLuaTimer(1, function()
        EventScheduler.Elapsed = EventScheduler.Elapsed + 1
        UGCGameSystem.GameState.EventElapsed = EventScheduler.Elapsed

        if EventScheduler.Elapsed % Ammo_Grant_Interval == 0 then
            EventScheduler:GrantRPGAmmo()
        end

        EventScheduler:_CheckEvent(EventScheduler.Elapsed)
    end, true, "EventSchedulerTick")
end

--[[--------------------获取当前的秒数，方便后面的玩家同步--------------------------]] --
function EventScheduler.GetCurrentElapsed()
    return EventScheduler.Elapsed or 0
end
--[[------------------获取当前活跃事件,方便后面玩家同步----------------------------]] --
function EventScheduler.GetActiveEvent()
    local cycleTime = (EventScheduler.Elapsed - 1) % EventConfig.CycleDuration + 1
    for _, event in ipairs(EventConfig.CycleEvents) do
        local eventStart = event.warnStartTime + event.warnDuration
        local eventEnd = eventStart + event.eventDuration
        if cycleTime >= eventStart and cycleTime < eventEnd then
            return event
        end
    end
    return nil
end

--[[----------------------获取当前预警事件和剩余倒计时------------------------]]
function EventScheduler.GetWarningEvent()
    local Cycle_Time = (EventScheduler.Elapsed - 1) % EventConfig.CycleDuration + 1 -- 当前周期秒数
    for _, Event in ipairs(EventConfig.CycleEvents) do
        local Event_Start = Event.warnStartTime + Event.warnDuration -- 当前事件开始时间
        if Cycle_Time >= Event.warnStartTime and Cycle_Time < Event_Start then
            return Event, Event_Start - Cycle_Time
        end
    end
    return nil
end

--[[----------------------给房间玩家发放RPG火箭弹------------------------]]
function EventScheduler:GrantRPGAmmo()
    local Player_Controllers = UGCGameSystem.GetAllPlayerController(false) -- 房间玩家控制器
    for _, Player_Controller in ipairs(Player_Controllers) do
        local Added_Count = UGCBackpackSystemV2.AddItemV2(Player_Controller, SQ_Ammo_Item_ID, 1) -- 实际添加数量
    end
    L_TipsTool.ShowTips_Broadcast("发放手枪子弹一个")
end

--[[---------------------检测当前是否有活跃事件，方便后面玩家-------------------------]] --
function EventScheduler:_CheckEvent(elapsed)
    --[[--------------------周期取秒数，一轮结束后从头开始--------------------------]] --
    local cycleTime = (elapsed - 1) % EventConfig.CycleDuration + 1
    for _, event in ipairs(EventConfig.CycleEvents) do
        local eventStart = event.warnStartTime + event.warnDuration

        if cycleTime == event.warnStartTime then
            EventScheduler:_OnWarn(event)
        elseif cycleTime == eventStart then
            EventScheduler:_OnStart(event)
        elseif cycleTime == eventStart + event.eventDuration then
            EventScheduler:_OnEnd(event)
        end
    end
end
--[[----------------------倒计时提醒------------------------]] --
function EventScheduler:_OnWarn(event)
    for Player_Pawn in pairs(EventScheduler.Tower_Players) do
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Player_Pawn) -- 塔内玩家控制器
        if Player_Controller then
            UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Event_Countdown,
                event.warnDuration, event.name)
        end
    end

end

--[[---------------------事件生效中-------------------------]] --
function EventScheduler:_OnStart(event)
    if event.name == L_Enum.Name_Event.MonsterStop then
        -- 开启怪物静止效果
        EventScheduler:_AddBuffToAllMonsters(L_Enum.Name_BuffPath.Buff02, event)
        return
    end

    local Buff_Path = EventScheduler:_GetPlayerEventBuffPath(event) -- 当前事件对应的玩家Buff路径
    if Buff_Path then
        EventScheduler:_AddBuffToTowerPlayers(Buff_Path, event)
    end
end

--[[--------------------事件结束，解除效果--------------------------]] --
function EventScheduler:_OnEnd(event)
    local Buff_Path = EventScheduler:_GetPlayerEventBuffPath(event) -- 当前事件对应的玩家Buff路径
    if Buff_Path then
        EventScheduler:_RemoveBuffFromTowerPlayers(Buff_Path)
    end
end

--[[----------------------获取玩家事件对应的Buff路径------------------------]]
function EventScheduler:_GetPlayerEventBuffPath(Event)
    if Event.name == L_Enum.Name_Event.SpeedLow then
        return L_Enum.Name_BuffPath.Debuff01
    elseif Event.name == L_Enum.Name_Event.DoubleGold then
        -- 改成跳高的buff咯
        return L_Enum.Name_BuffPath.Buff06
    elseif Event.name == L_Enum.Name_Event.AllSpeedUp then
        return L_Enum.Name_BuffPath.Buff05
    elseif Event.name == L_Enum.Name_Event.FullScreenNight then
        return L_Enum.Name_BuffPath.Debuff02
    elseif Event.name == L_Enum.Name_Event.AllFly then
        return L_Enum.Name_BuffPath.Buff08
    elseif Event.name == L_Enum.Name_Event.ReverseMove then
        return L_Enum.Name_BuffPath.Debuff04
    elseif Event.name == L_Enum.Name_Event.ShortNight then
        return L_Enum.Name_BuffPath.Debuff03
    end
end

--[[----------------------给塔内玩家添加事件Buff------------------------]]
function EventScheduler:_AddBuffToTowerPlayers(Buff_Path, Active_Event)
    for Player_Pawn in pairs(EventScheduler.Tower_Players) do
        EventScheduler:_AddBuffToOnePlayers(Player_Pawn, Buff_Path, Active_Event.eventDuration)
        EventScheduler.Tower_Players[Player_Pawn] = Buff_Path
    end
end

--[[----------------------移除塔内玩家的事件Buff------------------------]]
function EventScheduler:_RemoveBuffFromTowerPlayers(Buff_Path)
    for Player_Pawn in pairs(EventScheduler.Tower_Players) do
        EventScheduler:_RemoveBuffFromOnePlayers(Player_Pawn, Buff_Path)
        EventScheduler.Tower_Players[Player_Pawn] = false
    end
end

--[[----------------------给全体怪物添加事件Buff------------------------]]
function EventScheduler:_AddBuffToAllMonsters(Buff_Path, Active_Event)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    for _, Monster in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(UGCGameSystem.GameState, "Monster")) do
        UGCPersistEffectSystem.AddBuffByClass(Monster, Buff_Class, nil, Active_Event.eventDuration, 1)
    end
end

--[[----------------------登记进入塔内的玩家并添加当前事件Buff------------------------]]
function EventScheduler:RegisterTowerPlayer(Pawn)
    EventScheduler.Tower_Players[Pawn] = false
    local Warning_Event, Countdown_Remaining = EventScheduler.GetWarningEvent() -- 当前预警事件和剩余秒数
    if Warning_Event then
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Pawn) -- 进入区域的玩家控制器
        UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Event_Countdown,
            Countdown_Remaining, Warning_Event.name)
    end

    local Active_Event = EventScheduler.GetActiveEvent() -- 当前生效事件
    if Active_Event then
        local Buff_Path = EventScheduler:_GetPlayerEventBuffPath(Active_Event) -- 当前事件对应的玩家Buff路径
        if Buff_Path then
            EventScheduler:_AddBuffToOnePlayers(Pawn, Buff_Path, Active_Event.eventDuration)
            EventScheduler.Tower_Players[Pawn] = Buff_Path
        end
    end
end

--[[----------------------注销离开塔内的玩家并移除当前事件Buff------------------------]]
function EventScheduler:UnregisterTowerPlayer(Pawn)
    local Buff_Path = EventScheduler.Tower_Players[Pawn] -- 区域给该玩家施加的Buff路径
    EventScheduler.Tower_Players[Pawn] = nil
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Pawn) -- 离开区域的玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Event_Countdown, 0, "")
    if Buff_Path then
        EventScheduler:_RemoveBuffFromOnePlayers(Pawn, Buff_Path)
    end
end

--[[----------------------给单个玩家添加事件Buff------------------------]]
function EventScheduler:_AddBuffToOnePlayers(Pawn, Buff_Path, Duration)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    local Buff_Instances = UGCPersistEffectSystem.GetBuffsByClass(Pawn, Buff_Class) -- 已有Buff实例
    if #Buff_Instances > 0 then
        return
    end
    UGCPersistEffectSystem.AddBuffByClass(Pawn, Buff_Class, nil, Duration or -1, 1)
end

--[[----------------------移除单个玩家的事件Buff------------------------]]
function EventScheduler:_RemoveBuffFromOnePlayers(Pawn, Buff_Path)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    UGCPersistEffectSystem.RemoveBuffByClass(Pawn, Buff_Class, -1)
end

return EventScheduler
