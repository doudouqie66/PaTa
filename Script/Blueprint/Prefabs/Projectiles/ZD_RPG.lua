---@class ZD_RPG_C:BP_PEProjectile_RPGBullet_C
--Edit Below--

--require('UGCDebugSystem')

local ZD_RPG = {}


function ZD_RPG:Damage_Range(DamageContext)

    print("自定义伤害开始")
    print(ExportText(DamageContext))

    local DamageTarget = UGCAttributeSystem.GetVictimFromContext(DamageContext)
    print(tostring(DamageTarget))

    local SrcPos = self:K2_GetActorLocation()
    local TargetPos = DamageTarget:K2_GetActorLocation()

    print("源位置 " .. tostring(SrcPos))
    print("目标位置 " .. tostring(TargetPos))

    -- 计算距离
    local Dist = UGCMathUtility.VSize(
        UGCMathUtility.SubtractVector(SrcPos, TargetPos)
    )
    print("目标距离: " .. tostring(Dist))

    -------------------------------------------------------
    -- 伤害参数
    -------------------------------------------------------
    local BaseDamage      = 140
    local MinimumDamage   = 20
    local InnerRadius     = 80
    local OuterRadius     = 1000
    local DamageFalloff   = 2

    -------------------------------------------------------
    -- 计算伤害缩放
    -------------------------------------------------------

    local DamageScale = 0.0

    if Dist >= OuterRadius then
        DamageScale = 0.0
    elseif Dist <= InnerRadius then
        DamageScale = 1.0
    else
        local t = (Dist - InnerRadius) / (OuterRadius - InnerRadius)
        DamageScale = (1.0 - t) ^ DamageFalloff
    end

    print("伤害系数: " .. tostring(DamageScale))

    -- 计算最终伤害
    local ActualDamage = BaseDamage * DamageScale

    -- 在范围内就至少给最小伤害
    if DamageScale > 0 then
        ActualDamage = math.max(ActualDamage, MinimumDamage)
    end

    print("最终伤害: " .. tostring(ActualDamage))
    print("自定义伤害结束")

    return ActualDamage
end



return ZD_RPG