EventScheduler = EventScheduler or {}
local L_Enum = UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')

--[[---------------------启动事件循环-------------------------]] --
function EventScheduler.Start()
    EventScheduler.Elapsed = 0
    UGCTimerUtility.CreateLuaTimer(1, function()
        EventScheduler.Elapsed = EventScheduler.Elapsed + 1
        UGCGameSystem.GameState.EventElapsed = EventScheduler.Elapsed

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
    for _, PlayerController in ipairs(UGCGameSystem.GetAllPlayerController(false)) do
        L_TipsTool.ShowTips_01(tostring(event.name), PlayerController)
    end

end

--[[---------------------事件生效中-------------------------]] --
function EventScheduler:_OnStart(event)
    if event.name == L_Enum.Name_Event.SpeedLow then
        -- 开启移动减速效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Debuff01, event)
    elseif event.name == L_Enum.Name_Event.DoubleGold then
        -- 开启金币翻倍效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Buff09, event)
    elseif event.name == L_Enum.Name_Event.AllSpeedUp then
        -- 开启全体移动加速效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Buff05, event)
    elseif event.name == L_Enum.Name_Event.MonsterStop then
        -- 开启怪物静止效果
        EventScheduler:_AddBuffToAllMonsters(L_Enum.Name_BuffPath.Buff02, event)
    elseif event.name == L_Enum.Name_Event.FullScreenNight then
        -- 开启全屏黑夜效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Debuff02, event)
    elseif event.name == L_Enum.Name_Event.AllFly then
        -- 开启全体飞行效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Buff08, event)
    elseif event.name == L_Enum.Name_Event.ReverseMove then
        -- 开启移动反向效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Debuff04, event)
    elseif event.name == L_Enum.Name_Event.ShortNight then
        -- 开启短时间黑夜效果
        EventScheduler:_AddBuffToAllPlayers(L_Enum.Name_BuffPath.Debuff03, event)

    end

end

--[[--------------------事件结束，解除效果--------------------------]] --
function EventScheduler:_OnEnd(event)
    if event.name == L_Enum.Name_Event.SpeedLow then
        -- 解除移动减速效果
        -- EventScheduler:_RemoveBuffFromAllPlayers(L_Enum.Name_BuffPath.Debuff01)
    elseif event.name == L_Enum.Name_Event.DoubleGold then
        -- 解除金币翻倍效果
    elseif event.name == L_Enum.Name_Event.AllSpeedUp then
        -- 解除全体移动加速效果
    elseif event.name == L_Enum.Name_Event.MonsterStop then
        -- 解除怪物静止效果
    elseif event.name == L_Enum.Name_Event.FullScreenNight then
        -- 解除全屏黑夜效果
    elseif event.name == L_Enum.Name_Event.AllFly then
        -- 解除全体飞行效果
    elseif event.name == L_Enum.Name_Event.ReverseMove then
        -- 解除移动反向效果
    elseif event.name == L_Enum.Name_Event.ShortNight then
        -- 解除短时间黑夜效果
    end
end

--[[----------------------给全体玩家添加事件Buff------------------------]]
function EventScheduler:_AddBuffToAllPlayers(Buff_Path, Active_Event)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    for _, Player_Pawn in ipairs(UGCGameSystem.GetAllPlayerPawn()) do
        UGCPersistEffectSystem.AddBuffByClass(Player_Pawn, Buff_Class, nil, Active_Event.eventDuration, 1)
    end
end

--[[----------------------移除全体玩家的Buff------------------------]]
function EventScheduler:_RemoveBuffFromAllPlayers(Buff_Path)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    for _, Player_Pawn in ipairs(UGCGameSystem.GetAllPlayerPawn()) do
        UGCPersistEffectSystem.RemoveBuffByClass(Player_Pawn, Buff_Class, -1)
    end
end

--[[----------------------给全体怪物添加事件Buff------------------------]]
function EventScheduler:_AddBuffToAllMonsters(Buff_Path, Active_Event)
    local Buff_Class = UGCObjectUtility.LoadClass(Buff_Path) -- Buff类
    for _, Monster in ipairs(UGCActorComponentUtility.GetAllActorsWithTag(UGCGameSystem.GameState, "Monster")) do
        UGCPersistEffectSystem.AddBuffByClass(Monster, Buff_Class, nil, Active_Event.eventDuration, 1)
    end
end

return EventScheduler
