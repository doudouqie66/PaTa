local GM = {}

local Project_Enum = UGCGameSystem.UGCRequire("Script.L_Com.L_Enum") -- 项目枚举配置
local Tower_Top_Location = Vector.New(15106.924804688, 37112.078125, 22335.98046875) -- 塔顶坐标
UGCGameSystem.UGCRequire("ExtendResource.GiftPack.OfficialPackage.Script.GiftPack.GiftPackManager")

local GM_Backpack_Item_Config = { -- GM背包物品配置
{8310000, "喷射钩爪"}, {8310033, "击飞手指", 1}, {8310035, "大力拳套", 1}, {8310036, "冰冻锤", 1},
{8310037, "飞行背囊"}, {8310002, "返回卷"}, {8310014, "加速药水"}, {8310016, "每日登陆礼包"},
{8310018, "跳高药水"}, {8310020, "无敌药水"}, {8310021, "香蕉皮"}, {8310023, "隐身药水"},
{8310024, "金币宝箱"}, {8310026, "炸弹"}, {8310027, "密码纸条"}, {8310007, "粑粑"},
{8310010, "护盾药水"}, {8310003, "金币"}, {8310012, "塔顶奖杯"}, {8310044, "火箭弹"},
{8310046, "手枪子弹"}}

--[[----------------------创建指定物品的GM发放函数------------------------]]
local function Create_Grant_Item_Function(Item_ID, Item_Count)
    local Grant_Item_ID = Item_ID -- 需要发放的背包物品ID
    local Grant_Item_Count = Item_Count or 10 -- 单次发放数量
    --[[----------------------给玩家发放指定数量物品------------------------]]
    return function(Self, Param, PC)
        local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
        UGCBackpackSystemV2.AddItemV2(Player_Pawn, Grant_Item_ID, Grant_Item_Count)
    end
end

for _, Item_Config in ipairs(GM_Backpack_Item_Config) do
    local Function_Name = "S_Grant_Item_" .. tostring(Item_Config[1]) -- 当前物品GM函数名
    GM[Function_Name] = Create_Grant_Item_Function(Item_Config[1], Item_Config[3])
end

--[[----------------------注册自定义GM按钮------------------------]]
function GM:Register(DebugUI)
    local UGCGMUI = require("client.ingame.ugc.ugc_gmui")
    local Cur_Func_List = {} -- 自定义GM功能列表

    Cur_Func_List["GM"] = {
        ["数值与权益"] = {{UGCGMUI.ItemTypeEnum.Button, {{"移动到塔顶"}, {"将玩家移动到塔顶"}},
                                "S_Move_To_Tower_Top"},
                               {UGCGMUI.ItemTypeEnum.Button,
                                {{"添加所有物品"}, {"三把武器各1把，其余各20个"}}, "S_Add_All_Items"},
                               {UGCGMUI.ItemTypeEnum.Button,
                                {{"塔内奖励到下一档"}, {"推进到下一档奖励时间"}},
                                "S_Advance_Tower_Reward"},
                               {UGCGMUI.ItemTypeEnum.TextInput,
                                {{"设置金币数量", "输入非负整数"}, {"直接设置当前金币总数"}},
                                "S_Set_Gold_Count"}, {UGCGMUI.ItemTypeEnum.TextInput,
                                                      {{"增加通关奖杯", "输入正整数"},
                                                       {"调用玩家控制器的奖杯增加流程"}}, "S_Add_Win_Cup"},
                               {UGCGMUI.ItemTypeEnum.TextInput,
                                {{"设置福利累计时长", "输入累计秒数"},
                                 {"设置塔内在线福利累计时长"}}, "S_Set_Reward_Elapsed_Time"},
                               {UGCGMUI.ItemTypeEnum.TextInput,
                                {{"设置跑步机产出周期", "输入大于0的秒数"},
                                 {"修改当前玩家跑步机金币产出周期"}}, "S_Set_Run_Area_Gold_Interval"},
                               {UGCGMUI.ItemTypeEnum.Button, {{"激活周卡"}, {"发放并打开周卡礼包"}},
                                "S_Activate_Week_Card"},
                               {UGCGMUI.ItemTypeEnum.Button, {{"过期周卡"}, {"立即将周卡设置为过期"}},
                                "CS_Expire_Week_Card"}},
        ["发放道具"] = {}
    }
    for _, Item_Config in ipairs(GM_Backpack_Item_Config) do
        local Function_Name = "S_Grant_Item_" .. tostring(Item_Config[1]) -- 当前物品GM函数名
        local Grant_Item_Count = Item_Config[3] or 10 -- 单次发放数量
        table.insert(Cur_Func_List["GM"]["发放道具"],
            {UGCGMUI.ItemTypeEnum.Button,
             {{Item_Config[2]}, {"发放" .. tostring(Grant_Item_Count) .. "个" .. Item_Config[2]}}, Function_Name})
    end

    return Cur_Func_List
end

--[[----------------------将玩家移动到塔顶------------------------]]
function GM:S_Move_To_Tower_Top(Param, PC)
    local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
    Player_Pawn:DSTeleportToLocationOrRotation(Tower_Top_Location, Rotator.New(0, 0, 0), true, false, true, false)
end

--[[----------------------给玩家添加所有物品------------------------]]
function GM:S_Add_All_Items(Param, PC)
    local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310000, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310033, 1)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310035, 1)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310036, 1)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310037, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310002, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310014, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310016, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310018, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310020, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310021, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310023, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310024, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310026, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310027, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310007, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310010, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310003, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310012, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310044, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310046, 20)
end

--[[----------------------推进塔内奖励到下一档------------------------]]
function GM:S_Advance_Tower_Reward(Param, PC)
    local Current_Elapsed_Time = PC:GetTowerRewardElapsedTime() -- 当前塔内累计时间
    for _, Reward_Time in ipairs(Project_Enum.Tower_Reward.Reward_Times) do
        if Current_Elapsed_Time < Reward_Time then
            PC.Tower_Reward_Accumulated_Time = Reward_Time
            if PC.Tower_Reward_Is_Timing then
                PC.Tower_Reward_Enter_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime())
            end
            PC:SyncTowerRewardState()
            return
        end
    end
end

--[[----------------------设置玩家金币总数------------------------]]
function GM:S_Set_Gold_Count(Param, PC)
    local Target_Count = tonumber(Param) -- 目标金币数量
    if not Target_Count or Target_Count < 0 then
        return
    end
    Target_Count = math.floor(Target_Count)
    local Gold_Item_ID = Project_Enum.Gold_Shop.Gold_Item_ID -- 金币物品ID
    local Current_Count = UGCBackpackSystemV2.GetItemCountV2(PC, Gold_Item_ID) -- 当前金币数量
    if Target_Count > Current_Count then
        UGCBackpackSystemV2.AddItemV2(PC, Gold_Item_ID, Target_Count - Current_Count)
    elseif Target_Count < Current_Count then
        UGCBackpackSystemV2.RemoveItemV2(PC, Gold_Item_ID, Current_Count - Target_Count)
    end
end

--[[----------------------通过玩家控制器增加通关奖杯------------------------]]
function GM:S_Add_Win_Cup(Param, PC)
    local Add_Count = tonumber(Param) -- 增加的通关奖杯数量
    if not Add_Count or Add_Count <= 0 then
        return
    end
    PC:Add_WinCup(math.floor(Add_Count))
end

--[[----------------------设置玩家福利累计时长------------------------]]
function GM:S_Set_Reward_Elapsed_Time(Param, PC)
    local Elapsed_Time = tonumber(Param) -- 目标累计时长秒数
    if not Elapsed_Time or Elapsed_Time < 0 then
        return
    end
    PC.Tower_Reward_Accumulated_Time = math.floor(Elapsed_Time)
    if PC.Tower_Reward_Is_Timing then
        PC.Tower_Reward_Enter_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime())
    end
    PC:SyncTowerRewardState()
end

--[[----------------------设置跑步机金币产出周期------------------------]]
function GM:S_Set_Run_Area_Gold_Interval(Param, PC)
    local Gold_Interval = tonumber(Param) -- 金币产出周期秒数
    if not Gold_Interval or Gold_Interval <= 0 then
        return
    end
    PC.Run_Area_Gold_Interval = Gold_Interval
    local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
    local Gold_Buff_Class = UGCObjectUtility.LoadClass(Project_Enum.Name_BuffPath.Buff10) -- 跑步机金币Buff类
    for _, Gold_Buff in ipairs(UGCPersistEffectSystem.GetBuffsByClass(Player_Pawn, Gold_Buff_Class) or {}) do
        Gold_Buff.BuffInfo.BuffEffects[1].Interval = Gold_Interval
    end
end

--[[----------------------激活玩家周卡------------------------]]
function GM:S_Activate_Week_Card(Param, PC)
    if GiftPackManager:AddGiftPackage(Project_Enum.ID_Gift.WeekdGift, 1, PC) then
        GiftPackManager:OpenNormalGiftPackage(Project_Enum.ID_Gift.WeekdGift, 1, PC)
        PC:Activate_Week_Card(1)
    end
end

--[[----------------------将玩家周卡设置为过期------------------------]]
function GM:CS_Expire_Week_Card(Param, PC)
    local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
    if UGCGameSystem.IsServer() then
        PC.WeekEndTime = Current_Time - 1
        UnrealNetwork.RepLazyProperty(PC, "WeekEndTime")
        PC:SaveArchive()
        return
    end

    local Local_PC = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    Local_PC.WeekEndTime = Current_Time - 1
    local Week_Card_UI = L_GloTools.UI_Map[Project_Enum.Name_ClassPath.UI03] -- 已创建的周卡页面
    if Week_Card_UI then
        Week_Card_UI:RefreshWeekGiftPurchased(Local_PC)
    end
end

return GM
