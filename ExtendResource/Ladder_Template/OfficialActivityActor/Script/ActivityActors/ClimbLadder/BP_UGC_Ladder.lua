---@class BP_UGC_Ladder_C:ActivityBaseActor
---@field StaticMesh47 UStaticMeshComponent
---@field StaticMesh46 UStaticMeshComponent
---@field StaticMesh45 UStaticMeshComponent
---@field StaticMesh44 UStaticMeshComponent
---@field StaticMesh43 UStaticMeshComponent
---@field StaticMesh42 UStaticMeshComponent
---@field StaticMesh41 UStaticMeshComponent
---@field StaticMesh40 UStaticMeshComponent
---@field StaticMesh39 UStaticMeshComponent
---@field StaticMesh38 UStaticMeshComponent
---@field StaticMesh37 UStaticMeshComponent
---@field StaticMesh36 UStaticMeshComponent
---@field StaticMesh35 UStaticMeshComponent
---@field StaticMesh34 UStaticMeshComponent
---@field StaticMesh33 UStaticMeshComponent
---@field StaticMesh32 UStaticMeshComponent
---@field StaticMesh31 UStaticMeshComponent
---@field StaticMesh30 UStaticMeshComponent
---@field StaticMesh29 UStaticMeshComponent
---@field StaticMesh28 UStaticMeshComponent
---@field StaticMesh27 UStaticMeshComponent
---@field StaticMesh26 UStaticMeshComponent
---@field StaticMesh25 UStaticMeshComponent
---@field StaticMesh24 UStaticMeshComponent
---@field StaticMesh23 UStaticMeshComponent
---@field StaticMesh22 UStaticMeshComponent
---@field StaticMesh21 UStaticMeshComponent
---@field StaticMesh20 UStaticMeshComponent
---@field StaticMesh19 UStaticMeshComponent
---@field StaticMesh18 UStaticMeshComponent
---@field StaticMesh17 UStaticMeshComponent
---@field StaticMesh16 UStaticMeshComponent
---@field StaticMesh15 UStaticMeshComponent
---@field StaticMesh14 UStaticMeshComponent
---@field StaticMesh13 UStaticMeshComponent
---@field StaticMesh12 UStaticMeshComponent
---@field StaticMesh11 UStaticMeshComponent
---@field StaticMesh10 UStaticMeshComponent
---@field StaticMesh9 UStaticMeshComponent
---@field StaticMesh8 UStaticMeshComponent
---@field StaticMesh7 UStaticMeshComponent
---@field StaticMesh6 UStaticMeshComponent
---@field StaticMesh5 UStaticMeshComponent
---@field StaticMesh4 UStaticMeshComponent
---@field StaticMesh3 UStaticMeshComponent
---@field StaticMesh2 UStaticMeshComponent
---@field StaticMesh1 UStaticMeshComponent
---@field CanClimbDownBoxCheckArea UOverlapCheckAreaComponent
---@field CanClimbUpBoxCheckArea UOverlapCheckAreaComponent
---@field CanClimbDownBoxCheckCollision UBoxComponent
---@field CanClimbUpBoxCheckCollision UBoxComponent
---@field DownBoxOverlapCheckArea UOverlapCheckAreaComponent
---@field UpBoxOverlapCheckArea UOverlapCheckAreaComponent
---@field DownBox UBoxComponent
---@field UpPositionCheckSphere USphereComponent
---@field DownPositionCheckSphere USphereComponent
---@field UpBox UBoxComponent
---@field Arrow1 UArrowComponent
---@field Arrow UArrowComponent
---@field DownAttachScene1 USceneComponent
---@field UpAttachScene1 USceneComponent
---@field DownPositionOverlapCheckArea UOverlapCheckAreaComponent
---@field UpPositionOverlapCheckArea UOverlapCheckAreaComponent
---@field ClickActorComponentBaseDown UClickActorComponentBase
---@field ClickActorComponentBaseUp UClickActorComponentBase
---@field StaticMesh UStaticMeshComponent
---@field DownAttachScene USceneComponent
---@field UpAttachScene USceneComponent
---@field DefaultSceneRoot USceneComponent
---@field ClimbSpeed float
---@field DeattachPositionUp FVector
---@field DeattachPositionDown FVector
---@field ChildClass UClass
---@field bTeleportToEndLocation bool
--Edit Below--
local BP_UGC_Ladder = {
    CurrentInterActivePC = nil,
    InterActivePCList = {},--?????洢???????????????ｻ????PC
    DownLocation = nil,
    UpLocation = nil,
    bAttachDir_UpAttachScene1_DownAttachScene1_Free = false,
    bAttachDir_UpAttachScene_DownAttachScene_Free = false,
    AttachSceneComp = nil,
    CheckedLocationList = {},
    bUpBlock = false,
    bDownBlock = false,
    UpChildActorNumRemember = 0,
    DownChildActorNumRemember = 0,
    InDownCheckAreaList = {},--?????????ϻ?????????????????ʱ???ᴥ?????????ӵļ?????????Ҫ?ֶ???һ???ڼ??????????뽻????????
    InUpCheckAreaList = {},
}

function BP_UGC_Ladder:RemoveInterActivePCList(PC)
    local PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(PC))
    self.InterActivePCList[PlayerKey] = false
    if self.InDownCheckAreaList[PlayerKey] then
        self.InDownCheckAreaList[PlayerKey] = false
        self.DownChildActorNumRemember = self.DownChildActorNumRemember - 1
    end
    if self.InUpCheckAreaList[PlayerKey] then
        self.InUpCheckAreaList[PlayerKey] = false
        self.UpChildActorNumRemember = self.UpChildActorNumRemember - 1
    end
end
function BP_UGC_Ladder:CanUpTrigger(ClickParams)
    print_dev("BP_UGC_Ladder:CanUpTrigger")
    local  PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(ClickParams.PlayerController))
    local Character = ClickParams.PlayerController:GetPlayerCharacterSafety()
    --print_dev("BP_UGC_Ladder:CanUpTrigger--self.UpChildActorNumRemember = "..tostring(self.UpChildActorNumRemember))
    if self.UpChildActorNumRemember>0 then
        return false
    end
    if not UGCObjectUtility.IsObjectValid(Character)  then
        return false
    end
    if Character:HasState(EPawnState.Dead) or Character:HasState(EPawnState.Dying) or Character:HasState(EPawnState.InVehicle) then
        return false
    end
    if self.InterActivePCList[PlayerKey] == true then
       return false
    else
        return true
    end
    return false
end
function BP_UGC_Ladder:SetActiveParam(PC,bClimbUp)
    local Character = PC:GetPlayerCharacterSafety()
    local LocationScene = UGCMathUtility.VSize(UGCMathUtility.SubtractVector(Character:K2_GetActorLocation() , self.UpAttachScene:K2_GetComponentLocation()))
    local LocationScene1 = UGCMathUtility.VSize(UGCMathUtility.SubtractVector(Character:K2_GetActorLocation() , self.UpAttachScene1:K2_GetComponentLocation()))
    --????????????????û???ϰ????ʹ???????ҽϽ?????һ??Ϊ??????
    if self.bAttachDir_UpAttachScene_DownAttachScene_Free and self.bAttachDir_UpAttachScene1_DownAttachScene1_Free then
        if LocationScene > LocationScene1 then
            self.DownLocation = self.DownAttachScene1:K2_GetComponentLocation()
            self.UpLocation = self.UpAttachScene1:K2_GetComponentLocation()
            if bClimbUp then
                self.AttachSceneComp = self.DownAttachScene1
            else
                self.AttachSceneComp = self.UpAttachScene1
            end
        else
            self.DownLocation = self.DownAttachScene:K2_GetComponentLocation()
            self.UpLocation = self.UpAttachScene:K2_GetComponentLocation()
            if bClimbUp then
                self.AttachSceneComp = self.DownAttachScene
            else
                self.AttachSceneComp = self.UpAttachScene
            end
        end
    else
        --??????????????????????һ?????ϰ????ʹ???ϰ???????һ??Ϊ??????
        if self.bAttachDir_UpAttachScene_DownAttachScene_Free then
            self.DownLocation = self.DownAttachScene:K2_GetComponentLocation()
            self.UpLocation = self.UpAttachScene:K2_GetComponentLocation()
            if bClimbUp then
                self.AttachSceneComp = self.DownAttachScene
            else
                self.AttachSceneComp = self.UpAttachScene
            end
            
        elseif self.bAttachDir_UpAttachScene1_DownAttachScene1_Free then
            self.DownLocation = self.DownAttachScene1:K2_GetComponentLocation()
            self.UpLocation = self.UpAttachScene1:K2_GetComponentLocation()
            if bClimbUp then
                self.AttachSceneComp = self.DownAttachScene1
            else
                self.AttachSceneComp = self.UpAttachScene1
            end
        else
            --???????඼???ϰ???????????
            print_dev("BP_UGC_Ladder:OnUpClick--???඼???ϰ???")
            return false
        end
    end
    return true
end
function BP_UGC_Ladder:OnUpClick(ClickParams)
    print_dev("BP_UGC_Ladder:OnUpClick")
    local  PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(ClickParams.PlayerController))
    if not UGCGameSystem.IsServer() then
        return
    end
    if not self:SetActiveParam(ClickParams.PlayerController,true) then
        return
    end
    local Exit_Location_Up, Exit_Location_Down = self:CheckAndResetExitLocation()  -- 本次攀爬的安全离梯位置
    local SpawnTarget = UGCGameSystem.SpawnActor(self, self.ChildClass, self.AttachSceneComp:K2_GetComponentLocation(), self.AttachSceneComp:K2_GetComponentRotation(), Vector.New(1, 1, 1), self)
    print_dev("BP_UGC_Ladder:OnUpClick--SpawnTarget = "..KismetSystemLibrary.GetDisplayName(SpawnTarget))
    self.UpChildActorNumRemember = self.UpChildActorNumRemember + 1
    SpawnTarget:PossessWithAttach(ClickParams.PlayerController)
    SpawnTarget.DownPosition = self.DownLocation
    SpawnTarget.UpPosition = self.UpLocation
    SpawnTarget:ResetUpLocationAndDownLocation()
    SpawnTarget.OwnerLadder = self
    SpawnTarget.ClimbSpeed = self.ClimbSpeed
    SpawnTarget.bDyingTeleportToEndPostion = self.bTeleportToEndLocation
    if self.bUpBlock then
        SpawnTarget.DeattachPositionUp = nil
    else
        SpawnTarget.DeattachPositionUp = Exit_Location_Up
    end
    if self.bDownBlock then
        SpawnTarget.DeattachPositionDown = nil
    else
        SpawnTarget.DeattachPositionDown = Exit_Location_Down
    end
    self.InterActivePCList[PlayerKey] = true
    self.InUpCheckAreaList[PlayerKey] = true
end
function BP_UGC_Ladder:CanDownTrigger(ClickParams)
    print("BP_UGC_Ladder:CanDownTrigger")
    local  PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(ClickParams.PlayerController))
    local Character = ClickParams.PlayerController:GetPlayerCharacterSafety()
    print_dev("BP_UGC_Ladder:CanDownTrigger--self.DownChildActorNumRemember = "..tostring(self.DownChildActorNumRemember))
    if not UGCObjectUtility.IsObjectValid(Character)  then
        return false
    end
    if self.DownChildActorNumRemember>0 then
        return false
    end
    if Character:HasState(EPawnState.Dead) or Character:HasState(EPawnState.Dying) or Character:HasState(EPawnState.InVehicle) then
        return false
    end
    if self.InterActivePCList[PlayerKey] == true then
       return false
    else
        return true
    end
    return false
end
-- function BP_UGC_Ladder:Get(ClickParams)
-- end
function BP_UGC_Ladder:AreaBlockadeDetect(BeginLocation,EndLocation)
    local IgnoreActors = {self}
    local bHit,HitResult = 
    KismetSystemLibrary.SphereTraceSingle(self, 
    BeginLocation,
    EndLocation,
    40, 
    ECollisionChannel.ECC_WorldDynamic, 
    false,
    IgnoreActors,
    EDrawDebugTrace.None,
    {},
    true,
    {R = 1, G = 0, B = 0, A = 1},
    {R = 0, G = 1, B = 0, A = 1},
    0
    )
    if not bHit then
        print_dev("BP_UGC_Ladder:AreaBlockadeDetect--true")
        return true
    end
    print_dev("BP_UGC_Ladder:AreaBlockadeDetect--false--HitResult.Actor:Get() = "..KismetSystemLibrary.GetDisplayName(HitResult.Actor:Get()))
    return false
end
function BP_UGC_Ladder:OnDownClick(ClickParams)
    print_dev("BP_UGC_Ladder:OnDownClick")
    if not UGCGameSystem.IsServer() then
        return
    end
    if not self:SetActiveParam(ClickParams.PlayerController,false) then
        return
    end
    local Exit_Location_Up, Exit_Location_Down = self:CheckAndResetExitLocation()  -- 本次攀爬的安全离梯位置
    --self.DownChildActorNumRemember = self.DownChildActorNumRemember + 1
    local  PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(ClickParams.PlayerController))
    local SpawnTarget = UGCGameSystem.SpawnActor(self, self.ChildClass, self.AttachSceneComp:K2_GetComponentLocation(), self.AttachSceneComp:K2_GetComponentRotation(), Vector.New(1, 1, 1), self)
    SpawnTarget:PossessWithAttach(ClickParams.PlayerController)
    SpawnTarget.DownPosition = self.DownLocation
    SpawnTarget.UpPosition = self.UpLocation
    SpawnTarget:ResetUpLocationAndDownLocation()
    SpawnTarget.OwnerLadder = self
    SpawnTarget.ClimbSpeed = self.ClimbSpeed
    SpawnTarget.bDyingTeleportToEndPostion = self.bTeleportToEndLocation
    if self.bUpBlock then
        print_dev("BP_UGC_Ladder:OnDownClick--DeattachPositionUp is nil")
        SpawnTarget.DeattachPositionUp = nil
    else
        SpawnTarget.DeattachPositionUp = Exit_Location_Up
    end
    if self.bDownBlock then
        print_dev("BP_UGC_Ladder:OnDownClick--DeattachPositionDown is nil")
        SpawnTarget.DeattachPositionDown = nil
    else
        SpawnTarget.DeattachPositionDown = Exit_Location_Down
        print_dev("BP_UGC_Ladder:OnDownClick--self.DeattachPositionDown x= "..tostring(self.DeattachPositionDown.x).."y= "..tostring(self.DeattachPositionDown.y).."z= "..tostring(self.DeattachPositionDown.z))
    end
    self.InterActivePCList[PlayerKey] = true
    self.InUpCheckAreaList[PlayerKey] = false
end
function BP_UGC_Ladder:ReceiveBeginPlay()
    BP_UGC_Ladder.SuperClass.ReceiveBeginPlay(self)
    self.CanClimbDownBoxCheckArea.OnOverlapCheckChange:Add(self.DownBoxOverlapCheckArea_OnOverlapCheckChange, self);
	self.CanClimbUpBoxCheckArea.OnOverlapCheckChange:Add(self.UpBoxOverlapCheckArea_OnOverlapCheckChange, self);
    self.DownPositionOverlapCheckArea.OnOverlapCheckChange:Add(self.DownPositionOverlapCheckArea_OnOverlapCheckChange, self);
    self.UpPositionOverlapCheckArea.OnOverlapCheckChange:Add(self.UpPositionOverlapCheckArea_OnOverlapCheckChange, self);
    self.bAttachDir_UpAttachScene_DownAttachScene_Free = self:AreaBlockadeDetect(Vector.New(self.UpAttachScene:K2_GetComponentLocation().X,self.UpAttachScene:K2_GetComponentLocation().Y,self.UpPositionCheckSphere:K2_GetComponentLocation().Z),self.DownAttachScene:K2_GetComponentLocation())
    self.bAttachDir_UpAttachScene1_DownAttachScene1_Free = self:AreaBlockadeDetect(Vector.New(self.UpAttachScene1:K2_GetComponentLocation().X,self.UpAttachScene1:K2_GetComponentLocation().Y,self.UpPositionCheckSphere:K2_GetComponentLocation().Z),self.DownAttachScene1:K2_GetComponentLocation())
end
--[[----------------------检查并计算梯子两端的安全离开位置------------------------]]
function BP_UGC_Ladder:CheckAndResetExitLocation()
    print_dev("BP_UGC_Ladder:CheckAndResetExitLocation")
    self.bUpBlock = false
    self.bDownBlock = false

    local Ladder_Location = self:K2_GetActorLocation()  -- 梯子世界位置
    local Ladder_Rotation = self:K2_GetActorRotation()  -- 梯子世界旋转
    local Check_Location_Up = UGCMathUtility.AddVector(UGCMathUtility.RotateVector(self.DeattachPositionUp, Ladder_Rotation), Ladder_Location)  -- 顶部配置位置
    local Check_Location_Down = UGCMathUtility.AddVector(UGCMathUtility.RotateVector(self.DeattachPositionDown, Ladder_Rotation), Ladder_Location)  -- 底部配置位置
    local Exit_Location_Up = Check_Location_Up  -- 顶部实际离开位置
    local Exit_Location_Down = Check_Location_Down  -- 底部实际离开位置

    local Is_Up_Location_Free = self:TeleportAreaBlockadeDetect({Check_Location_Up})  -- 顶部位置是否可用
    if not Is_Up_Location_Free then
        local Has_Up_Location, Up_Location = self:TeleportAreaBlockadeDetect(self:GenerateCheckpoint(Check_Location_Up))  -- 顶部备用位置
        if Has_Up_Location then
            Exit_Location_Up = Up_Location
        else
            self.bUpBlock = true
            Exit_Location_Up = nil
        end
    end

    local Is_Down_Location_Free = self:TeleportAreaBlockadeDetect({Check_Location_Down})  -- 底部位置是否可用
    if not Is_Down_Location_Free then
        local Has_Down_Location, Down_Location = self:TeleportAreaBlockadeDetect(self:GenerateCheckpoint(Check_Location_Down))  -- 底部备用位置
        if Has_Down_Location then
            Exit_Location_Down = Down_Location
        else
            self.bDownBlock = true
            Exit_Location_Down = nil
        end
    end

    return Exit_Location_Up, Exit_Location_Down
end

function BP_UGC_Ladder:DownPositionOverlapCheckArea_OnOverlapCheckChange(CheckActorArray)
    print_dev("BP_UGC_Ladder:DownPositionOverlapCheckArea_OnOverlapCheckChange")
    for k, CheckActor in pairs(CheckActorArray.InActorList) do
        if UGCObjectUtility.IsA(CheckActor,self.ChildClass) then
            CheckActor:AttachLadderEndPosition(false)
        end
    end
    for k, CheckActor in pairs(CheckActorArray.OutActorList) do
        if UGCObjectUtility.IsA(CheckActor,self.ChildClass) then
            CheckActor:DeAttachLadderEndPosition(false)
        end
    end
end
function BP_UGC_Ladder:UpPositionOverlapCheckArea_OnOverlapCheckChange(CheckActorArray)
    print_dev("BP_UGC_Ladder:UpPositionOverlapCheckArea_OnOverlapCheckChange")
    for k, CheckActor in pairs(CheckActorArray.InActorList) do
        if UGCObjectUtility.IsA(CheckActor,self.ChildClass) then
            CheckActor:AttachLadderEndPosition(true)
        end
    end
    for k, CheckActor in pairs(CheckActorArray.OutActorList) do
        if UGCObjectUtility.IsA(CheckActor,self.ChildClass) then
            CheckActor:DeAttachLadderEndPosition(true)
        end
    end
end
function BP_UGC_Ladder:GenerateCheckpoint(CheckTargetLocation)
	local CurrentCheckRound = 0
	local CheckRoundRemember = 0
	local CheckLengthRemember = 0
	local RotatableCheckPointList = {}
	local AngleRemember = 60
	self.CheckedLocationList = {CheckTargetLocation}
	while CheckLengthRemember<=200 do
		CheckRoundRemember = CurrentCheckRound
		CurrentCheckRound = CurrentCheckRound + 1
		CheckLengthRemember = CurrentCheckRound*80
	end
	local rotatedDir =   UGCMathUtility.RotateAngleAxis(Vector.New(-80, 0, 0),-60, Vector.New(0, 0, 1))
	for i = 1, CheckRoundRemember do
		table.insert(self.CheckedLocationList,UGCMathUtility.AddVector(CheckTargetLocation,Vector.New(80*i, 0, 0)))
	end
	if CheckRoundRemember >=2 then
		for i = 2, CheckRoundRemember do
			for j = 1,i-1 do
				local Location = UGCMathUtility.AddVector(self.CheckedLocationList[i+1],UGCMathUtility.MultiplyVector(rotatedDir, j))
				table.insert(self.CheckedLocationList,Location)
			end
		end
	end
	local CheckLocationListLength = #self.CheckedLocationList
	if CheckLocationListLength < 2 then
        log_tree("BP_UGC_Ladder:GenerateCheckpoint1",self.CheckedLocationList)
		return self.CheckedLocationList
	end
	for i = 1, 5 do
		for j = 2, CheckLocationListLength do
			local Dir = UGCMathUtility.RotateAngleAxis(UGCMathUtility.SubtractVector(self.CheckedLocationList[j], CheckTargetLocation),AngleRemember*i, Vector.New(0, 0, 1) )
			table.insert(RotatableCheckPointList,UGCMathUtility.AddVector(CheckTargetLocation,Dir))
		end
	end
	for _, v in pairs(RotatableCheckPointList) do
		table.insert(self.CheckedLocationList,v)
	end
    log_tree("BP_UGC_Ladder:GenerateCheckpoint",self.CheckedLocationList)
	return self.CheckedLocationList
end
function BP_UGC_Ladder:TeleportAreaBlockadeDetect(LocationList)
	if LocationList == nil then
		return false,nil
	end
	for _, Location in pairs(LocationList) do
		local bHit,HitResult = 
		KismetSystemLibrary.SphereTraceSingle(self, 
		UGCMathUtility.AddVector(Location,Vector.New(0, 0, 160)), 
		UGCMathUtility.AddVector(Location,Vector.New(0, 0, 50)), 
		40, 
		ECollisionChannel.ECC_WorldDynamic, 
		false,
		{self},
		EDrawDebugTrace.None,
		{},
		true,
		{R = 1, G = 0, B = 0, A = 1},
		{R = 0, G = 1, B = 0, A = 1},
		0
		)
		if not bHit then
			return true,Location
		end
	end
	return false,nil
end
---]]

--[[
function BP_UGC_Ladder:ReceiveTick(DeltaTime)
    BP_UGC_Ladder.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_UGC_Ladder:ReceiveEndPlay()
    BP_UGC_Ladder.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_UGC_Ladder:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_UGC_Ladder:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function BP_UGC_Ladder:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	
	-- [Editor Generated Lua] BindingEvent End;
end

function BP_UGC_Ladder:DownBoxOverlapCheckArea_OnOverlapCheckChange(CheckActorArray)
    print_dev("BP_UGC_Ladder:DownBoxOverlapCheckArea_OnOverlapCheckChange")
    for _,CheckActor in pairs(CheckActorArray.InActorList) do
        print_dev("BP_UGC_Ladder:DownBoxOverlapCheckArea_OnOverlapCheckChange--InActorList+1")
        local PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(CheckActor:GetPlayerControllerSafety()))
        if self.InterActivePCList[PlayerKey] == true then
            self.DownChildActorNumRemember = self.DownChildActorNumRemember + 1
            self.InDownCheckAreaList[PlayerKey] = true
            return nil
        end
    end
    for _,CheckActor in pairs(CheckActorArray.OutActorList) do
        print_dev("BP_UGC_Ladder:DownBoxOverlapCheckArea_OnOverlapCheckChange--OutActorList-1")
        local PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(CheckActor:GetPlayerControllerSafety()))
        if self.InterActivePCList[PlayerKey] == true then
            self.DownChildActorNumRemember = self.DownChildActorNumRemember - 1
            if self.InDownCheckAreaList[PlayerKey] then
                self.InDownCheckAreaList[PlayerKey] = false
            end
            return nil
        end
    end
	return nil;
end

function BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange(CheckActorArray)
    print_dev("BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange")
    for _,CheckActor in pairs(CheckActorArray.InActorList) do
        print_dev("BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange--InActorList--CheckActor = "..KismetSystemLibrary.GetDisplayName(CheckActor))
        local PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(CheckActor:GetPlayerControllerSafety()))
        print_dev("BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange--InActorList--self.InterActivePCList[PlayerKey] = "..tostring(self.InterActivePCList[PlayerKey]))
        if self.InterActivePCList[PlayerKey] == true then
            print_dev("BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange--true Return")
            self.UpChildActorNumRemember = self.UpChildActorNumRemember + 1
            self.InUpCheckAreaList[PlayerKey] = true
            return nil
        end
    end
    for _,CheckActor in pairs(CheckActorArray.OutActorList) do
        local PlayerKey = tostring(UGCGameSystem.GetPlayerKeyByPlayerController(CheckActor:GetPlayerControllerSafety()))
        if self.InterActivePCList[PlayerKey] == true then
            print_dev("BP_UGC_Ladder:UpBoxOverlapCheckArea_OnOverlapCheckChange--true Return")
            self.UpChildActorNumRemember = self.UpChildActorNumRemember -1
            if self.InUpCheckAreaList[PlayerKey] == true then
                self.InUpCheckAreaList[PlayerKey] = false
            end
            return nil
        end
    end
	return nil;
end

-- [Editor Generated Lua] function define End;

return BP_UGC_Ladder
