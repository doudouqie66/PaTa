---@class Buff03_C:PersistEffectBuff
---@field InvisibleMaterial UMaterialInterface
---@field SelfAlpha float
---@field EnemyAlpha float
---@field FriendlyApha float
---@field InvisibleColor FLinearColor
---@field EnemyVisibleDistance float
---@field SelfSoundVolumeRate float
--Edit Below--
local Buff03 = {}
 
-- buff开始
function Buff03:OnApply_BP(OwnerActor)
    Buff03.SuperClass.OnApply_BP(self, OwnerActor) 
    if not self:HasAuthority() then
        -- 客户端开启Tick，Tick里敌方阵营需要检测距离，根据距离设置不同透明度
        self:SetTickEnable(true)       
        ugcprint("Buff03.OnApply_BP.  ")
        -- 设置隐身材质
        self.Task = UGCGameplayTaskSystem.PlayerPawn.SetMaterial.NewTask(self, self:GetNetOwnerActor(), self.InvisibleMaterial)
        -- 设置隐身颜色
        self.Task:SetVectorParameterValue("Color", self.InvisibleColor)
        if self:IsAutonomous(true) then
            -- 设置自身隐身时透明度
            self.Task:SetScalarParameterValue("Alpha_Base", self.SelfAlpha)
            UGCPlayerPawnSystem.SetOutputBusVolume(self:GetNetOwnerActor(), self.SelfSoundVolumeRate)
        else
            -- 非主端根据模拟端阵营进行处理
            local LocalPlayerPawn = UGCGameSystem.GetLocalPlayerPawn()
            if UGCCampSystem.GetCampRelationWithActor(LocalPlayerPawn, OwnerActor) == ECampRelation.Same then
                -- 友方阵营设置友方透明度
                self.Task:SetScalarParameterValue("Alpha_Base", self.FriendlyApha)
            else
                -- 敌方阵营设置敌方透明度
                self.Task:SetScalarParameterValue("Alpha_Base", self.EnemyAlpha)
            end
            UGCPlayerPawnSystem.SetOutputBusVolume(self:GetNetOwnerActor(), 0)
        end        
    end
end

function Buff03:Tick_BP(OwnerActor, DeltaTime)
    if not self:HasAuthority() and self.Task then
        if not self:IsAutonomous(true) then
            local LocalPlayerPawn = UGCGameSystem.GetLocalPlayerPawn()
            if not (UGCCampSystem.GetCampRelationWithActor(LocalPlayerPawn, OwnerActor) == ECampRelation.Same) then
                -- 敌方阵营如果距离小于一定值，也需要可见（设置为友方透明度）               
                local LocalPlayerPawnPosition = LocalPlayerPawn:K2_GetActorLocation()
                local OwnerActorPosition = OwnerActor:K2_GetActorLocation()
                local DistanceVector = UGCMathUtility.SubtractVector(LocalPlayerPawnPosition, OwnerActorPosition)
                if UGCMathUtility.VSize(DistanceVector) <= self.EnemyVisibleDistance then
                    self.Task:SetScalarParameterValue("Alpha_Base", self.FriendlyApha)
                else
                    self.Task:SetScalarParameterValue("Alpha_Base", self.EnemyAlpha)
                end                
            end
        end
    end
end


function Buff03:OnUnApply_BP(OwnerActor, Reason)
    if not self:HasAuthority() then
        if self.Task then
            self.Task:EndTask()
        end
        UGCPlayerPawnSystem.SetOutputBusVolume(self:GetNetOwnerActor(), 1)
    end
end


return Buff03