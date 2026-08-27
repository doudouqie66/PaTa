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
    if self:HasAuthority() then
        self.Stow_Weapon_Delegate = ObjectExtend.CreateDelegate(self, function() -- 延迟收枪委托
            UGCWeaponManagerSystem.CurrentWeaponAttachToBack(OwnerActor)
            ObjectExtend.DestroyDelegate(self.Stow_Weapon_Delegate)
            self.Stow_Weapon_Delegate = nil
        end)
        KismetSystemLibrary.K2_SetTimerDelegateForLua(self.Stow_Weapon_Delegate, self, 0.8, false)
    end
    if not self:HasAuthority() then
        -- 客户端开启Tick，Tick里敌方阵营需要检测距离，根据距离设置不同透明度
        self:SetTickEnable(true)       
        ugcprint("Buff03.OnApply_BP.  ")
        -- 隐藏头顶奖杯
        OwnerActor.HeadTop_UI_Component:SetVisibility(false, false, false)
        OwnerActor.HeadTop_UI_Component_Back:SetVisibility(false, false, false)
        -- 设置隐身材质
        self.Task = UGCGameplayTaskSystem.PlayerPawn.SetMaterial.NewTask(self, self:GetNetOwnerActor(), self.InvisibleMaterial)
        -- 设置隐身颜色
        self.Task:SetVectorParameterValue("Color", self.InvisibleColor)
        if self:IsAutonomous(true) then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OwnerActor) -- 本地玩家控制器
            PC.Is_Invisible_Weapon_Locked = true
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
        -- 恢复头顶奖杯
        OwnerActor.HeadTop_UI_Component:SetVisibility(true, false, false)
        OwnerActor.HeadTop_UI_Component_Back:SetVisibility(true, false, false)
        if self:IsAutonomous(true) then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OwnerActor) -- 本地玩家控制器
            PC.Is_Invisible_Weapon_Locked = false
        end
        if self.Task then
            self.Task:EndTask()
        end
        UGCPlayerPawnSystem.SetOutputBusVolume(self:GetNetOwnerActor(), 1)
    end
end


return Buff03
