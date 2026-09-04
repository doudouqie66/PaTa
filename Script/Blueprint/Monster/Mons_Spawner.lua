---@class Mons_Spawner_C:BP_UGCMobSpawner_C
---@field Layer_Index  int32
--Edit Below--
local Mons_Spawner = {}

local First_Patrol_Speed = 150 -- 第一层巡逻速度
local Last_Patrol_Speed = 300 -- 最后一层巡逻速度
local Base_Patrol_Speed = 150 -- 怪物蓝图中的基础速度
local Total_Layer_Count = 10 -- 总层数

--[[
function Mons_Spawner:ReceiveBeginPlay()
    Mons_Spawner.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[----------------------计算当前层巡逻速度------------------------]]
local function Calc_Patrol_Speed(Layer_Index)
    if Total_Layer_Count <= 1 then
        return First_Patrol_Speed
    end

    local Progress = (Layer_Index - 1) / (Total_Layer_Count - 1)
    local Speed = First_Patrol_Speed
        + (Last_Patrol_Speed - First_Patrol_Speed) * Progress

    return math.floor(Speed + 0.5)
end

--[[----------------------怪物生成后设置巡逻速度------------------------]]
function Mons_Spawner:OnMobSpawn(MobPawn)
    if Mons_Spawner.SuperClass.OnMobSpawn then
        Mons_Spawner.SuperClass.OnMobSpawn(self, MobPawn)
    end

    local Target_Speed = Calc_Patrol_Speed(self.Layer_Index)
    local Speed_Scale = Target_Speed / Base_Patrol_Speed

    -- 该接口需要在服务器调用
    UGCSimpleCharacterSystem.SetSpeedScale(MobPawn, Speed_Scale)
end

--[[
function Mons_Spawner:CustomSpawnMob(InCustomParam)
    
end
--]]

return Mons_Spawner
