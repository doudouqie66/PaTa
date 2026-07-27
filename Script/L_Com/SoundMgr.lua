SoundMgr = SoundMgr or {}

local RootPath = UGCMapInfoLib.GetRootLongPackagePath()
local Sound_Cache = {}

SoundMgr.SoundName = {
    UI_Click = "UI_Click", -- 通用按钮点击
    UI_Switch = "UI_Switch", -- UI界面打开切换
    UI_Keypad = "UI_Keypad", -- 密码键盘点击
    UI_Error = "UI_Error", -- 输入或操作错误
    Door_Open = "Door_Open", -- 密码门开启
    Reward_Gold = "Reward_Gold", -- 金币或购买到账
    Reward_Ready = "Reward_Ready", -- 奖励可以领取
    Event_Notice = "Event_Notice", -- 普通事件通知
    Event_Countdown = "Event_Countdown", -- 事件倒计时
    Event_Alarm = "Event_Alarm", -- 危险事件警报
    Trap_Explosion = "Trap_Explosion", -- 炸弹陷阱爆炸
    Freeze_Start = "Freeze_Start", -- 冰冻效果生效
    Freeze_Break = "Freeze_Break", -- 冰冻效果破碎
    Monster_Voice = "Monster_Voice", -- 怪物声音
    Hit_Punch = "Hit_Punch", -- 拳击命中
    Fly_Start = "Fly_Start" -- 飞行效果生效
}

SoundMgr.SoundPath = {
    UI_Click = RootPath .. "Asset/WwiseEvent/UIClick.UIClick", -- 通用按钮点击
    UI_Switch = RootPath .. "Asset/WwiseEvent/UISwitch.UISwitch", -- UI界面打开切换
    UI_Keypad = RootPath .. "Asset/WwiseEvent/UIKeypad.UIKeypad", -- 密码键盘点击
    UI_Error = RootPath .. "Asset/WwiseEvent/UIError.UIError", -- 输入或操作错误
    Door_Open = RootPath .. "Asset/WwiseEvent/DoorOpen.DoorOpen", -- 密码门开启
    Reward_Gold = RootPath .. "Asset/WwiseEvent/RewardGold.RewardGold", -- 金币或购买到账
    Reward_Ready = RootPath .. "Asset/WwiseEvent/RewardReady.RewardReady", -- 奖励可以领取
    Event_Notice = RootPath .. "Asset/WwiseEvent/EventNotice.EventNotice", -- 普通事件通知
    Event_Countdown = RootPath .. "Asset/WwiseEvent/EventCountdown.EventCountdown", -- 事件倒计时
    Event_Alarm = RootPath .. "Asset/WwiseEvent/EventAlarm.EventAlarm", -- 危险事件警报
    Trap_Explosion = RootPath .. "Asset/WwiseEvent/TrapExplosion.TrapExplosion", -- 炸弹陷阱爆炸
    Freeze_Start = RootPath .. "Asset/WwiseEvent/FreezeStart.FreezeStart", -- 冰冻效果生效
    Freeze_Break = RootPath .. "Asset/WwiseEvent/FreezeBreak.FreezeBreak", -- 冰冻效果破碎
    Monster_Voice = RootPath .. "Asset/WwiseEvent/MonsterVoice.MonsterVoice", -- 怪物声音
    Hit_Punch = RootPath .. "Asset/WwiseEvent/HitPunch.HitPunch", -- 拳击命中
    Fly_Start = RootPath .. "Asset/WwiseEvent/FlyStart.FlyStart" -- 飞行效果生效
}

--[[----------------------播放2D音效------------------------]]
function SoundMgr.PlaySound2D(Sound_Name)
    if UGCGameSystem.IsServer() then
        return
    end

    local Sound_Path = SoundMgr.SoundPath[Sound_Name] -- 音效资源路径
    if not Sound_Path then
        ugcprint("SoundMgr找不到音效配置：" .. tostring(Sound_Name))
        return
    end

    local Sound_Asset = Sound_Cache[Sound_Name] -- 已加载的音效资源
    if not Sound_Asset then
        Sound_Asset = UE.LoadObject(Sound_Path)
        Sound_Cache[Sound_Name] = Sound_Asset
    end

    if not Sound_Asset then
        ugcprint("SoundMgr加载音效失败：" .. Sound_Path)
        return
    end

    return UGCSoundManagerSystem.PlaySound2D(Sound_Asset)
end

return SoundMgr
