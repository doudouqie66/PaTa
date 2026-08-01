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
    UI09 = RootPath .. "Asset/Blueprint/Yan/UI/UI09.UI09_C",
    UI10 = RootPath .. "Asset/Blueprint/Yan/UI/UI10.UI10_C",
    UI_Black = RootPath .. "Asset/Blueprint/UI/UI_Black.UI_Black_C",
    UI_CountDownAttnetion = RootPath .. "Asset/Blueprint/UI/UI_CountDownAttnetion.UI_CountDownAttnetion_C",
    BP_Jetpack_AttachActor = RootPath .. "Asset/Blueprint/Actor/BP_Jetpack_AttachActor.BP_Jetpack_AttachActor_C", -- 冲天炮附加Actor
    kj01 = RootPath .. "Asset/Blueprint/Yan/UI/kj01.kj01_C",
    UI_Fly = RootPath .. "Asset/Blueprint/Yan/UI/UI_Fly.UI_Fly_C"

}

--[[----------------------材质的路径-----------------------]] --
L_Enum.Name_Material = {
    Men_YuanLai = '/Game/Arts_Timeliness/CG005_Concert/Arts_Prop/LightStick/M_Prop_LightStick_Colorful',
    Men_CanEnter = '/Game/UMG/UI_Effect/Materials/DX_FlowLight_09.DX_FlowLight_09'

}

--[[----------------------特效的路径-----------------------]] --
L_Enum.Name_Particle = {
    P_Fireworks_01 = '/Game/Arts_Effect/ParticleSystems/Share/P_Fireworks_01.P_Fireworks_01',
    Jetpack_Smoke = '/Game/Arts_Effect/ParticleSystems/Share/P_SC_jump_smoke_B001_02.P_SC_jump_smoke_B001_02', -- 冲天炮上升烟雾
    Jetpack_Spark = '/Game/Actor_Timeliness/CG030/CG030_TangDao/Arts_Effect/Particle/P_030_HuoXing_01.P_030_HuoXing_01' -- 冲天炮上升火星
}

--[[----------------------蒙太奇资源路径------------------------]]
L_Enum.Name_AnimMontagePath = {
    Run_Area_Sprint = RootPath .. "Asset/Blueprint/Animation/Run_Area_Sprint_Montage.Run_Area_Sprint_Montage", -- 区域跑步动作
    CTP_Fly = "/Game/Arts_Timeliness/CG005_Hero/Arts_Player/Anim/AgileSoldier/AgileSoldier_Umarmed_Fly_Montage.AgileSoldier_Umarmed_Fly_Montage", -- 冲天炮动作
    MoTan_Fly = "/Game/Arts_Player/Characters/Animation/Shared_Anim/Parachute_Anim/Glider/Lobby_FlyingDevice_Montage.Lobby_FlyingDevice_Montage" -- 魔毯
}

--[[----------------------Buff名字------------------------]] --

L_Enum.Name_BuffPath = {
    Debuff01 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff01.DeBuff01_C",
    Debuff02 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff02.DeBuff02_C",
    Debuff03 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff03.DeBuff03_C",
    Debuff04 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff04.DeBuff04_C",

    Buff02 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff02.Buff02_C",
    Buff04 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff04.Buff04_C",
    Buff05 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff05.Buff05_C",
    Buff07 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff07.Buff07_C",
    Buff08 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff08.Buff08_C",
    Buff09 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff09.Buff09_C",
    Buff10 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff10.Buff10_C",
    Buff07_2 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/Buff07_2.Buff07_2_C"
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
    Switch_View = "Switch_View", -- 切换视角
    New_Pass = "New_Pass", -- 重新生成随机密码
    Add_Backpack_Item = "Add_Backpack_Item", -- 添加背包物品
    Men_State = "Men_State", -- 切换门的状态
    Show_Room_Pass_UI = "Show_Room_Pass_UI", -- 显示房间密码界面
    Claim_Tower_Reward = "Claim_Tower_Reward", -- 领取塔内计时奖励
    Exchange_Trophy_Item = "Exchange_Trophy_Item", -- 奖杯兑换道具RPC名称
    Buy_Gold_Item = "Buy_Gold_Item", -- 金币购买道具RPC名称
    Tele_To_Point = "TeleToPoint", -- 传送到指定出生点RPC名称
    Switch_Trap_Item_Skill = "Switch_Trap_Item_Skill", -- 切换陷阽物品技能RPC名称
    Set_Jetpack_Flying = "Set_Jetpack_Flying", -- 设置冲天炮飞行状态RPC名称
    Event_Countdown = "Event_Countdown", -- 事件倒计时RPC名称
    Set_Anim_Montage = "MulticastRPC_SetAnimMontage", -- 广播播放或停止蒙太奇RPC名称
    Set_Jetpack_Particles = "MulticastRPC_SetJetpackParticles", -- 广播播放或停止冲天炮粒子RPC名称
    Broadcast_Tips = "MulticastRPC_ShowTips" -- 广播提示RPC名称
    -- Client_RefUI_Level = "Client_RefUI_Level"
}

L_Enum.Gold_Shop = {
    Gold_Item_ID = 8310003, -- 金币物品ID
    Item_Price_Config = {
        [1023] = 500, -- 香蕉皮
        [1009] = 500, -- 粑粑
        [1028] = 800, -- 炸弹
        [1022] = 10000, -- 无敌药水
        [1016] = 2000, -- 加速药水
        [1020] = 3000, -- 跳高药水
        [1012] = 4500, -- 护盾药水
        [1025] = 4500, -- 隐身药水
        [1013] = 4500, -- 喷射钩爪
        [1011] = 5000, -- 冲天炮
        [1010] = 7600, -- 冰冻锤
        [1006] = 7600 -- 大力拳套
    }
}

L_Enum.Trophy_Shop = {
    Trophy_Item_ID = 8310012, -- 奖杯物品ID
    Item_Price_Config = {
        [1023] = 5, -- 香蕉皮
        [1009] = 5, -- 粑粑
        [1028] = 8, -- 炸弹
        [1022] = 88, -- 无敌药水
        [1016] = 10, -- 加速药水
        [1020] = 20, -- 跳高药水
        [1012] = 30, -- 护盾药水
        [1025] = 45, -- 隐身药水
        [1013] = 45, -- 喷射钩爪
        [1011] = 50, -- 冲天炮
        [1010] = 66, -- 冰冻锤
        [1006] = 68 -- 大力拳套
    }
}

L_Enum.Tower_Reward = {
    Reward_Times = {360, 720, 1080, 1560, 2100}, -- 五档奖励所需累计停留秒数
    -- Reward_Times = {30, 60, 90, 120, 150}, -- 五档奖励所需累计停留秒数

    Reward_Item_IDs = {1017, 1023, 1028, 1013, 1011}, -- 五档奖励虚拟物品ID
    Reward_Item_Count = 1 -- 每档奖励数量
}

L_Enum.Ranking_List = {
    Tower_Climb_Time_ID = 2 -- 最短爬塔时间排行榜ID
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
    WeekdGift = 1030,
    StarterGift = 1033

}
--[[------------------------商品ID----------------------]] --
L_Enum.ID_ShopProduct = {
    WeekdGift = 9000029,
    StarterGift = 9000032

}
return L_Enum
