local GM = {}

local Project_Enum = UGCGameSystem.UGCRequire("Script.L_Com.L_Enum") -- 项目枚举配置
local Tower_Top_Location = Vector.New(15106.924804688, 37112.078125, 22335.98046875) -- 塔顶坐标

--[[----------------------注册自定义GM按钮------------------------]]
function GM:Register(DebugUI)
    local UGCGMUI = require("client.ingame.ugc.ugc_gmui")
    local Cur_Func_List = {} -- 自定义GM功能列表

    Cur_Func_List["调试"] = {
        ["快捷功能"] = {
            {UGCGMUI.ItemTypeEnum.Button, {{"移动到塔顶"}, {"将玩家移动到塔顶"}}, "S_Move_To_Tower_Top"},
            {UGCGMUI.ItemTypeEnum.Button, {{"添加所有物品"}, {"每种物品添加20个"}}, "S_Add_All_Items"},
            {UGCGMUI.ItemTypeEnum.Button, {{"塔内奖励到下一档"}, {"推进到下一档奖励时间"}}, "S_Advance_Tower_Reward"}
        }
    }

    return Cur_Func_List
end

--[[----------------------将玩家移动到塔顶------------------------]]
function GM:S_Move_To_Tower_Top(Param, PC)
    local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
    Player_Pawn:DSTeleportToLocationOrRotation(
        Tower_Top_Location, Rotator.New(0, 0, 0), true, false, true, false)
end

--[[----------------------给玩家添加所有物品------------------------]]
function GM:S_Add_All_Items(Param, PC)
    local Player_Pawn = PC:GetPlayerCharacterSafety() -- 当前玩家角色
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310000, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310033, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310035, 20)
    UGCBackpackSystemV2.AddItemV2(Player_Pawn, 8310036, 20)
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
end

--[[----------------------推进塔内奖励到下一档------------------------]]
function GM:S_Advance_Tower_Reward(Param, PC)
    local Current_Elapsed_Time = PC:GetTowerRewardElapsedTime() -- 当前塔内累计时间
    for _, Reward_Time in ipairs(Project_Enum.Tower_Reward.Reward_Times) do
        if Current_Elapsed_Time < Reward_Time then
            PC.Tower_Reward_Accumulated_Time = Reward_Time
            if PC.Tower_Reward_Is_Timing then
                PC.Tower_Reward_Enter_Time =
                    UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime())
            end
            PC:SyncTowerRewardState()
            return
        end
    end
end

return GM
