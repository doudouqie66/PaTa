---@class Mons_Spawner_C:BP_UGCMobSpawner_C
--Edit Below--
---@class Mons_Spawner_C:BP_UGCMobSpawner_C
-- Edit Below--
---@class Mons_Spawner_C:BP_UGCMobSpawner_C
-- Edit Below--
local Mons_Spawner = {}

--[[
function Mons_Spawner:ReceiveBeginPlay()
    Mons_Spawner.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[----------------------怪物生成后绑定碰撞事件------------------------]]
-- function Mons_Spawner:OnMobSpawn(MobPawn)
--     if Mons_Spawner.SuperClass.OnMobSpawn then
--         Mons_Spawner.SuperClass.OnMobSpawn(self, MobPawn)
--     end

-- end

--[[
function Mons_Spawner:CustomSpawnMob(InCustomParam)
    
end
--]]

return Mons_Spawner
