---@class Test01_C:PESkillTemplate_Active_C
---@field ChainRadius float
---@field ChainInfernoClass UClass


local Test01 = {

}

function Test01:OnActivateSkill_BP()
    Test01.SuperClass.OnActivateSkill_BP(self)
    local PlayerPawn = self:GetNetOwnerActor()
    self.CacheTask = UGCGameplayTaskSystem.PlayerPawn.ReplaceAnim.NewTask(self, PlayerPawn, self.AnimLists)
end

function Test01:OnDeActivateSkill_BP()
    Test01.SuperClass.OnDeActivateSkill_BP(self)
    if self.CacheTask then
        self.CacheTask:EndTask()
    end
end


function Test01:StartChain()
    if not UGCGameSystem.IsServer() then
        print('StartChain=============')
        local TargetList = self:GetSelectTargetActor(EPESkillSelectTarget.E_PESKILL_PickerType_AllTarget)
        if TargetList ~= nil and TargetList[1] ~= nil and self.CableActor == nil then
            print('SelectTarget--------------------')
            local Offset = UGCMathUtility.MakeVector(55.0, -15.0, 60.0)

            local OwnerActorForward = self:GetOwnerActor():GetActorForwardVector()
            local OwnerActorRight = self:GetOwnerActor():GetActorRightVector()

            local OffsetForward = UGCMathUtility.MultiplyVector(OwnerActorForward, Offset.X)
            local OffsetRight = UGCMathUtility.MultiplyVector(OwnerActorRight, Offset.Y)
            local OffsetUp = UGCMathUtility.MultiplyVector(UGCMathUtility.GetUpVector(), Offset.Z)

            local OffsetVector = UGCMathUtility.AddVector(OffsetForward, OffsetRight)
            OffsetVector = UGCMathUtility.AddVector(OffsetVector, OffsetUp)

            self.CableStartLocation = UGCMathUtility.AddVector(self:GetOwnerActor():K2_GetActorLocation(), OffsetVector)           
            local TargetActorLocation = TargetList[1]:K2_GetActorLocation()
            local TargetOffset = UGCMathUtility.MakeVector(0.0, 0.0, 20.0)

            TargetActorLocation = UGCMathUtility.AddVector(TargetActorLocation, TargetOffset)

            local CableForward = UGCMathUtility.SubtractVector(TargetActorLocation, self.CableStartLocation)
            local CableRot = UGCMathUtility.MakeRotFromX(CableForward)
            self.TargetDistance = UGCMathUtility.VSize(UGCMathUtility.SubtractVector(TargetActorLocation, self.CableStartLocation))
            self.CacheTarget = TargetList[1]

            self.CableActor = UGCActorComponentUtility.SpawnActor(self, self.ChainActorClass, self.CableStartLocation, CableRot)
            self.StartTime = UGCGameSystem.GetTimeSeconds(self)
            self.CableTimer = Timer.InsertTimer(0, function()
                self:TickCable() 
            end, true)
        end
    end
end

function Test01:TickCable()
    if not UGCGameSystem.IsServer() then
        if self.CableActor ~= nil then
            local ElapsedTime = UGCGameSystem.GetTimeSeconds(self) - self.StartTime
            local LerpValue = ElapsedTime / 0.1
            local NowDistance = LerpValue * self.TargetDistance
            print('TickCable' .. tostring(NowDistance))
            self.CableActor.Cable.EndLocation = UGCMathUtility.MakeVector(NowDistance, 0.0, 0.0)
        end
    end
end


function Test01:EndChain()
    if not UGCGameSystem.IsServer() then
        if self.CableTimer ~= nil then
            Timer.RemoveTimer(self.CableTimer)
            self.CableTimer = nil
        end
    end
end

function Test01:StartPull()
    if not UGCGameSystem.IsServer() then
        self.PullTimer = Timer.InsertTimer(0, function()
            self:UpdateTargetLocation() 
        end, true)
    end
end

function Test01:UpdateTargetLocation()
    if not UGCGameSystem.IsServer() and self.CacheTarget ~= nil and self.CableActor ~= nil then
        local TargetActorLocation = self.CacheTarget:K2_GetActorLocation()
        local TargetOffset = UGCMathUtility.MakeVector(0.0, 0.0, 20.0)
        TargetActorLocation = UGCMathUtility.AddVector(TargetActorLocation, TargetOffset)
        self.TargetDistance = UGCMathUtility.VSize(UGCMathUtility.SubtractVector(TargetActorLocation, self.CableStartLocation))
        self.TargetDistance = UGCMathUtility.Clamp(self.TargetDistance, 150.0, 1000000.0)
        local TargetOffsetDistance = UGCMathUtility.MakeVector(self.TargetDistance, 0.0, 0.0)
        if UGCMathUtility.EqualVector(TargetOffsetDistance, self.CableActor.Cable.EndLocation) then
            UGCActorComponentUtility.DestroyActor(self.CableActor)
            self.CableActor = nil
        else
            self.CableActor.Cable.EndLocation = TargetOffsetDistance
        end
    end
end

function Test01:EndPull()
    if not UGCGameSystem.IsServer() then
        if self.CableActor ~= nil then
            UGCActorComponentUtility.DestroyActor(self.CableActor)
            self.CableActor = nil
        end
        self.CacheTarget = nil
        if self.PullTimer ~= nil then
            Timer.RemoveTimer(self.PullTimer)
            self.PullTimer = nil
        end
    end
end

return Test01