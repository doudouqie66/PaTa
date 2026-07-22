EventConfig = EventConfig or {}
local L_Enum = UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')

EventConfig.CycleEvents = {{
    name = L_Enum.Name_Event.SpeedLow, -- 事件名字
    warnStartTime = 5, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.DoubleGold, -- 事件名字
    warnStartTime = 10, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.AllSpeedUp, -- 事件名字
    warnStartTime = 15, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.MonsterStop, -- 事件名字
    warnStartTime = 20, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.FullScreenNight, -- 事件名字
    warnStartTime = 25, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.AllFly, -- 事件名字
    warnStartTime = 30, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 40 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.ReverseMove, -- 事件名字
    warnStartTime = 73, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.ShortNight, -- 事件名字
    warnStartTime = 78, -- 开始时间
    warnDuration = 2, -- 倒计时持续时间
    eventDuration = 2 -- 事件持续时间
}}

-- 一轮总时长 = 最后事件结束时间 = 78 + 2 + 2 = 82 秒
EventConfig.CycleDuration = 82
return EventConfig
