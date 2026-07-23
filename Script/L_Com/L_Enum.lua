L_Enum = L_Enum or {}

--[[-----------------------资源路径-----------------------]] --
local RootPath = UGCMapInfoLib.GetRootLongPackagePath()

L_Enum.Name_ClassPath = {
    MainUI = RootPath .. "Asset/Blueprint/UI/MainUI.MainUI_C",
    Tips_01 = RootPath .. "Asset/Blueprint/L_Com/Tips/Tips_01.Tips_01_C",
    UI_Attention = RootPath .. "Asset/Blueprint/Yan/UI/UI_Attention.UI_Attention_C",
    UI01 = RootPath .. "Asset/Blueprint/Yan/UI/UI01.UI01_C",
    UI02 = RootPath .. "Asset/Blueprint/Yan/UI/UI02.UI02_C",
    UI03 = RootPath .. "Asset/Blueprint/Yan/UI/UI03.UI03_C",
    UI04 = RootPath .. "Asset/Blueprint/Yan/UI/UI04.UI04_C",
    UI05 = RootPath .. "Asset/Blueprint/Yan/UI/UI05.UI05_C",
    UI06 = RootPath .. "Asset/Blueprint/Yan/UI/UI06.UI06_C",
    UI07 = RootPath .. "Asset/Blueprint/Yan/UI/UI07.UI07_C",
    UI08 = RootPath .. "Asset/Blueprint/Yan/UI/UI08.UI08_C",
    UI09 = RootPath .. "Asset/Blueprint/Yan/UI/UI09.UI09_C"

}
--[[----------------------Buff名字------------------------]] --

L_Enum.Name_BuffPath = {
    Debuff01 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff01.DeBuff01_C",
    Debuff02 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff02.DeBuff02_C",
    Debuff03 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff03.DeBuff03_C",
    Debuff04 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff04.DeBuff04_C",

    Buff02 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff02.Buff02_C",
    Buff05 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff05.Buff05_C",
    Buff08 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff08.Buff08_C",
    Buff09 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff09.Buff09_C",
    Buff10 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff10.Buff10_C"

}

--[[------------------CTRl那里的RPC方法名字----------------------------]] --
L_Enum.Name_RPC = {
    AddLevel = "AddLevel",
    UseRedemptionCode = "UseRedemptionCode",
    Mgr_Atten = "Mgr_Atten",
    Tool_Msg_01 = "Tool_Msg_01",
    Request_Respawn = "RequestRespawn", -- 复活请求RPC名称
    Show_Respawn_UI = "ShowRespawnUI", -- 显示复活界面RPC名称
    Open_Gift_Pack = "OpenGiftPack", -- 打开礼包界面RPC名称
    Add_WinCup = "Add_WinCup", -- 添加奖杯
    Switch_View = "Switch_View" -- 切换视角

    -- Client_RefUI_Level = "Client_RefUI_Level"
}

L_Enum.Name_Event = {
    SpeedLow = "移动减速", -- 移动减速事件
    DoubleGold = "金币翻倍", -- 金币翻倍事件
    AllSpeedUp = "全体移动加速", -- 全体移动加速事件
    MonsterStop = "怪物静止", -- 怪物静止事件
    FullScreenNight = "全屏黑夜", -- 全屏黑夜事件
    AllFly = "全体飞行", -- 全体飞行事件
    ReverseMove = "移动反向", -- 移动反向事件
    ShortNight = "短时间黑夜" -- 短时间黑夜事件

}

--[[-----------------------属性名字-----------------------]] --
L_Enum.Name_RepPts = {
    PlayerGameLevel = "PlayerGameLevel",
    PlayerAttack = "PlayerAttack",
    PlayerMaxHP = "PlayerMaxHP"

}

--[[------------------------礼包ID----------------------]] --
L_Enum.ID_Gift = {
    WeekdGift = 1030

}
return L_Enum
