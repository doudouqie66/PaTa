local UIMgr = {}

local Flash_Start_Interval = 0.04 -- 开始时闪现间隔
local Flash_End_Interval = 0.25 -- 结束时闪现间隔
local Spin_Loop_Count = 12 -- 完整绕圈次数
local Lottery_Stop_Stay_Seconds = 1 -- 停在目标格子的停留秒数

UIMgr.Active_Lottery_Timer = nil -- 当前抽奖闪现计时器

--[[----------------------播放抽奖闪现动画------------------------]]
function UIMgr.PlayLotteryEffect(Reward_Panels, Move_Image, Target_Index, On_Finished, On_Position_Changed)
    local Move_Widgets = type(Move_Image) == "table" and Move_Image or {Move_Image} -- 需要移动的控件列表
    if not Reward_Panels or #Reward_Panels == 0 or #Move_Widgets == 0 then
        return
    end

    Target_Index = Target_Index or math.random(#Reward_Panels)
    Target_Index = math.max(1, math.min(#Reward_Panels, Target_Index))

    local Reward_Positions = {} -- 各奖励面板位置
    local Center_X = 0 -- 奖励面板中心横坐标
    local Center_Y = 0 -- 奖励面板中心纵坐标
    for Panel_Index, Reward_Panel in ipairs(Reward_Panels) do
        local Panel_Slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(Reward_Panel)
        local Panel_Position = Panel_Slot:GetPosition()
        Reward_Positions[Panel_Index] = UGCMathUtility.MakeVector(Panel_Position.X, Panel_Position.Y, 0)
        Center_X = Center_X + Panel_Position.X
        Center_Y = Center_Y + Panel_Position.Y
    end
    Center_X = Center_X / #Reward_Positions
    Center_Y = Center_Y / #Reward_Positions

    local Spin_Order = {}
    for Panel_Index = 1, #Reward_Positions do
        table.insert(Spin_Order, Panel_Index)
    end
    table.sort(Spin_Order, function(A, B)
        local Angle_A = UGCMathUtility.DegAtan2(Reward_Positions[A].Y - Center_Y, Reward_Positions[A].X - Center_X)
        local Angle_B = UGCMathUtility.DegAtan2(Reward_Positions[B].Y - Center_Y, Reward_Positions[B].X - Center_X)
        return Angle_A < Angle_B
    end)

    local Target_In_Spin_Order = nil -- 目标格子在转动顺序中的位置
    for Spin_Index, Spin_Panel_Index in ipairs(Spin_Order) do
        if Spin_Panel_Index == Target_Index then
            Target_In_Spin_Order = Spin_Index
            break
        end
    end

    local Loop_Spin_Order = {} -- 每次完整循环都以目标格子结尾
    for Loop_Index = 1, #Spin_Order do
        local Spin_Offset = (Target_In_Spin_Order or 0) + Loop_Index
        if Spin_Offset > #Spin_Order then
            Spin_Offset = Spin_Offset - #Spin_Order
        end
        table.insert(Loop_Spin_Order, Spin_Order[Spin_Offset])
    end

    local Spin_Path = {}
    for _ = 1, Spin_Loop_Count do
        for _, Panel_Index in ipairs(Loop_Spin_Order) do
            table.insert(Spin_Path, Reward_Positions[Panel_Index])
        end
    end

    UIMgr.StopLotteryEffect()

    local function Set_Move_Position(Move_Position)
        for _, Move_Widget in ipairs(Move_Widgets) do
            local Move_Slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(Move_Widget)
            if Move_Slot then
                Move_Slot:SetPosition(UGCMathUtility.MakeVector2D(Move_Position.X, Move_Position.Y))
            end
        end
        if On_Position_Changed then
            On_Position_Changed()
        end
    end

    Set_Move_Position(Spin_Path[1])

    local Path_Index = 2 -- 下一次要闪现到的路径下标
    local function Schedule_Next_Flash()
        local Step_Progress = (Path_Index - 1) / (#Spin_Path - 1) -- 当前闪现进度
        local Ease_Progress = Step_Progress * Step_Progress -- 减速进度
        local Next_Interval = Flash_Start_Interval +
            (Flash_End_Interval - Flash_Start_Interval) * Ease_Progress -- 下一次闪现间隔
        UIMgr.Active_Lottery_Timer = UGCTimerUtility.CreateLuaTimer(Next_Interval, function()
            UIMgr.Active_Lottery_Timer = nil
            Set_Move_Position(Spin_Path[Path_Index])

            Path_Index = Path_Index + 1
            if Path_Index > #Spin_Path then
                UIMgr.Active_Lottery_Timer = UGCTimerUtility.CreateLuaTimer(Lottery_Stop_Stay_Seconds, function()
                    UIMgr.Active_Lottery_Timer = nil
                    if On_Finished then
                        On_Finished(Target_Index)
                    end
                end, false)
                return
            end
            Schedule_Next_Flash()
        end, false)
    end
    Schedule_Next_Flash()
end

--[[----------------------停止抽奖闪现动画------------------------]]
function UIMgr.StopLotteryEffect()
    if UIMgr.Active_Lottery_Timer then
        UGCTimerUtility.RemoveLuaTimer(UIMgr.Active_Lottery_Timer)
        UIMgr.Active_Lottery_Timer = nil
    end
end

return UIMgr
