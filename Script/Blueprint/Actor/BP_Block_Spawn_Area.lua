---@class BP_Block_Spawn_Area_C:AActor
---@field  Area_Point_09 USceneComponent
---@field  Area_Point_08 USceneComponent
---@field Area_Point_07 USceneComponent
---@field Area_Point_06 USceneComponent
---@field Area_Point_05 USceneComponent
---@field Area_Point_04 USceneComponent
---@field Area_Point_03 USceneComponent
---@field Area_Point_02 USceneComponent
---@field Area_Point_01 USceneComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local BP_Block_Spawn_Area = {}
local Block_Size = 100 -- 方块尺寸及网格间距

--[[----------------------判断点是否位于区域多边形内------------------------]]
local function Is_Point_Inside_Area(Point_X, Point_Y, Area_Points)
    local Is_Inside = false -- 点是否位于区域内
    local Previous_Index = #Area_Points -- 上一个边界点索引

    for Current_Index, Current_Point in ipairs(Area_Points) do -- 遍历多边形边界
        local Previous_Point = Area_Points[Previous_Index] -- 上一个边界点
        local Crosses_Y = (Current_Point.Y > Point_Y) ~= (Previous_Point.Y > Point_Y) -- 边是否跨过检测点水平线

        if Crosses_Y then
            local Intersection_X = (Previous_Point.X - Current_Point.X) * (Point_Y - Current_Point.Y) /
                (Previous_Point.Y - Current_Point.Y) + Current_Point.X -- 边与水平线的交点
            if Point_X < Intersection_X then
                Is_Inside = not Is_Inside
            end
        end

        Previous_Index = Current_Index
    end

    return Is_Inside
end
 
--[[
function BP_Block_Spawn_Area:ReceiveBeginPlay()
    BP_Block_Spawn_Area.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_Block_Spawn_Area:ReceiveTick(DeltaTime)
    BP_Block_Spawn_Area.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_Block_Spawn_Area:ReceiveEndPlay()
    BP_Block_Spawn_Area.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_Block_Spawn_Area:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_Block_Spawn_Area:GetAvailableServerRPCs()
    return
end
--]]

--[[----------------------初始化区域方块生成网格------------------------]]
function BP_Block_Spawn_Area:ReceiveBeginPlay()
    BP_Block_Spawn_Area.SuperClass.ReceiveBeginPlay(self)

    if not UGCGameSystem.IsServer() then
        return
    end

    local Area_Point_Components = { -- 区域边界点组件列表
        self.Area_Point_01, self.Area_Point_02, self.Area_Point_03, self.Area_Point_04,
        self.Area_Point_05, self.Area_Point_06, self.Area_Point_07, self.Area_Point_08
    }
    local Area_Points = {} -- 区域边界点世界坐标列表

    for Point_Index, Area_Point in ipairs(Area_Point_Components) do -- 遍历区域边界点
        local Point_Location = Area_Point:K2_GetComponentLocation() -- 边界点世界坐标
        table.insert(Area_Points, Point_Location)
        print(string.format("BlockSpawnArea Point[%d]: X=%.2f Y=%.2f Z=%.2f", Point_Index, Point_Location.X,
            Point_Location.Y, Point_Location.Z))
    end

    local Min_X = Area_Points[1].X -- 区域最小X坐标
    local Max_X = Area_Points[1].X -- 区域最大X坐标
    local Min_Y = Area_Points[1].Y -- 区域最小Y坐标
    local Max_Y = Area_Points[1].Y -- 区域最大Y坐标

    for Point_Index = 2, #Area_Points do -- 计算区域外接矩形
        local Point_Location = Area_Points[Point_Index] -- 当前边界点坐标
        Min_X = math.min(Min_X, Point_Location.X)
        Max_X = math.max(Max_X, Point_Location.X)
        Min_Y = math.min(Min_Y, Point_Location.Y)
        Max_Y = math.max(Max_Y, Point_Location.Y)
    end

    local Half_Block_Size = Block_Size * 0.5 -- 方块半尺寸
    local First_X = math.ceil((Min_X + Half_Block_Size) / Block_Size) * Block_Size -- 首个网格X坐标
    local First_Y = math.ceil((Min_Y + Half_Block_Size) / Block_Size) * Block_Size -- 首个网格Y坐标
    self.Available_Spawn_Points = {} -- 可用方块生成位置

    for Point_X = First_X, Max_X - Half_Block_Size, Block_Size do -- 遍历X轴网格
        for Point_Y = First_Y, Max_Y - Half_Block_Size, Block_Size do -- 遍历Y轴网格
            local Is_Fully_Inside =
                Is_Point_Inside_Area(Point_X - Half_Block_Size, Point_Y - Half_Block_Size, Area_Points) and
                Is_Point_Inside_Area(Point_X + Half_Block_Size, Point_Y - Half_Block_Size, Area_Points) and
                Is_Point_Inside_Area(Point_X - Half_Block_Size, Point_Y + Half_Block_Size, Area_Points) and
                Is_Point_Inside_Area(Point_X + Half_Block_Size, Point_Y + Half_Block_Size, Area_Points) -- 四角是否都在区域内

            if Is_Fully_Inside then
                table.insert(self.Available_Spawn_Points, {
                    X = Point_X,
                    Y = Point_Y,
                    Z = Area_Points[1].Z + Half_Block_Size
                })
            end
        end
    end

    print(string.format("BlockSpawnArea Grid: BlockSize=%.2f Count=%d", Block_Size, #self.Available_Spawn_Points))
end

--[[----------------------在随机可用位置生成方块------------------------]]
function BP_Block_Spawn_Area:Spawn_Random_Block()
    if #self.Available_Spawn_Points == 0 then
        print("BlockSpawnArea Spawn Failed: NoAvailablePoint")
        return
    end

    local Random_Index = math.random(#self.Available_Spawn_Points) -- 随机位置索引
    local Spawn_Location = self.Available_Spawn_Points[Random_Index] -- 本次生成位置
    local Block_Path = UGCGameSystem.GetUGCResourcesFullPath(
        "Asset/Blueprint/Actor/AC_WH.AC_WH_C") -- 方块蓝图完整路径
    local Block_Class = UE.LoadClass(Block_Path) -- 方块蓝图类
    local Spawned_Block = ScriptGameplayStatics.SpawnActor(self, Block_Class, Spawn_Location,
        {Roll = 0, Pitch = 0, Yaw = 0}, {X = 1, Y = 1, Z = 1}) -- 生成的方块Actor

    if not Spawned_Block then
        print("BlockSpawnArea Spawn Failed: SpawnActor")
        return
    end

    Spawned_Block:SetReplicates(true)
    print(string.format("BlockSpawnArea Spawn Success: X=%.2f Y=%.2f Z=%.2f Available=%d", Spawn_Location.X,
        Spawn_Location.Y, Spawn_Location.Z, #self.Available_Spawn_Points))
end

return BP_Block_Spawn_Area
