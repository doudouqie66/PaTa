EventConfig_BackUp = EventConfig_BackUp or {}
local L_Enum = UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')

EventConfig_BackUp.CycleEvents = {{
    name = L_Enum.Name_Event.SpeedLow, -- 事件名字
    warnStartTime = 100, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 10 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.DoubleGold, -- 事件名字
    warnStartTime = 200, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 30 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.AllSpeedUp, -- 事件名字
    warnStartTime = 300, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 15 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.MonsterStop, -- 事件名字
    warnStartTime = 400, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 10 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.FullScreenNight, -- 事件名字
    warnStartTime = 500, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 10 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.AllFly, -- 事件名字
    warnStartTime = 600, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 10 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.ReverseMove, -- 事件名字
    warnStartTime = 700, -- 开始时间
    warnDuration = 10, -- 倒计时持续时间
    eventDuration = 10 -- 事件持续时间
}, {
    name = L_Enum.Name_Event.ShortNight, -- 事件名字
    warnStartTime = 800, -- 开始时间
    warnDuration = 5, -- 倒计时持续时间
    eventDuration = 5 -- 事件持续时间
}}

-- 一轮总时长 = 最后事件结束时间 = 800 + 5 + 5 = 810 秒
EventConfig_BackUp.CycleDuration = 810
return EventConfig_BackUp
