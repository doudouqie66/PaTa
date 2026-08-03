---@class BP_Item_MoTan_C:Template_Equipment_C
--Edit Below--
local BP_Item_MoTan = {} 

--[[V2背包事件]]--
--[[
--- func 能否更新此物品实例，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
---@return 是否允许物品数量更新，若不允许，物品添加或移除操作可能失败
-- function BP_Item_MoTan:CanUpdateItemCountV2(NewItemCount, OldItemCount)
--     return BP_Item_MoTan.SuperClass.CanUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 物品数量更新后回调，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
-- function BP_Item_MoTan:OnUpdateItemCountV2(NewItemCount, OldItemCount)
--     BP_Item_MoTan.SuperClass.OnUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 能否使用物品，可重载并自定义(服务端生效)
---@return 物品是否能够被使用
-- function BP_Item_MoTan:CanUseV2()
--     return BP_Item_MoTan.SuperClass.CanUseV2(self);
-- end

--- func 当物品被使用回调，可重载并自定义(服务端生效)
-- function BP_Item_MoTan:OnUseV2()
--     BP_Item_MoTan.SuperClass.OnUseV2(self);
-- end

--- func 当物品被取消使用，与UseItem对应，用于清理状态，应当支持多次调用，不产生额外副作用，移除物品时自动调用，可重载并自定义(服务端生效)
-- function BP_Item_MoTan:OnDisuseV2()
--     BP_Item_MoTan.SuperClass.OnDisuseV2(self);
-- end

--- func 其他物品能否附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_MoTan:CanAttachToSlot(SlotName, ItemDefineID)
--     return BP_Item_MoTan.SuperClass.CanAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当其他物品附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_MoTan:OnAttachToSlot(SlotName, ItemDefineID)
--     BP_Item_MoTan.SuperClass.OnAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当物品从此槽位移除(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_MoTan:OnDetachBySlot(SlotName, ItemDefineID)
--     BP_Item_MoTan.SuperClass.OnDetachBySlot(self, SlotName, ItemDefineID);
-- end

--- func 能否Attach到Parent物品上, 如果Parent为空物品, 说明将被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
---@return bool 能否Attach
-- function BP_Item_MoTan:CanAttach(ParentDefineID, SlotName)
--     return BP_Item_MoTan.SuperClass.CanAttach(self, ParentDefineID, SlotName);
-- end

--- func 当Attach到Parent物品上, 如果Parent为空物品, 说明是被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function BP_Item_MoTan:OnAttach(ParentDefineID, SlotName)
--     BP_Item_MoTan.SuperClass.OnAttach(self, ParentDefineID, SlotName);
-- end

--- func 当从Parent物品上解除Attach, 如果Parent为空物品, 说明是从背包装备槽位解除装备(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function BP_Item_MoTan:OnDetach(ParentDefineID, SlotName)
--     BP_Item_MoTan.SuperClass.OnDetach(self, ParentDefineID, SlotName);
-- end

--- func 当物品被装备前，检查能否装备(服务端生效)
---@return bool 能否装备
-- function BP_Item_MoTan:CanEquip()
--     return BP_Item_MoTan.SuperClass.CanEquip(self);
-- end

--- func 当物品被装备回调(服务端生效)
-- function BP_Item_MoTan:OnEquip()
--     BP_Item_MoTan.SuperClass.OnEquip(self);
-- end

--- func 当物品被卸下回调(服务端生效)
-- function BP_Item_MoTan:OnUnEquip()
--     BP_Item_MoTan.SuperClass.OnUnEquip(self);
-- end

--- func 当物品在背包中被交换槽位前，检查能否交换(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
---@return 能否交换到新槽位
-- function BP_Item_MoTan:CanSwapEquipSlot(OldSlotName, NewSlotName)
--     return BP_Item_MoTan.SuperClass.CanSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品被交换到新装备槽位后回调(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
-- function BP_Item_MoTan:OnSwapEquipSlot(OldSlotName, NewSlotName)
--     BP_Item_MoTan.SuperClass.OnSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品开始使用时回调，可重载并自定义(服务端生效)
-- function BP_Item_MoTan:UGC_OnStartUse()
--     BP_Item_MoTan.SuperClass.UGC_OnStartUse(self)
-- end

--- func 当物品停止使用时回调，可重载并自定义(服务端生效)，在OnUseV2后调用
-- function BP_Item_MoTan:UGC_OnStopUse(Reason)
    BP_Item_MoTan.SuperClass.UGC_OnStopUse(self, Reason)
-- end
]]--

local Magic_Carpet_Item_ID = 8310038 -- 魔毯物品ID
local Flying_Item_Slot_Name = "EquipmentSlot.Custom.Jetpack" -- 飞行物装备槽位

--[[----------------------装备魔毯时开启飞行控制------------------------]]
function BP_Item_MoTan:OnAttach(ParentDefineID, SlotName)
    BP_Item_MoTan.SuperClass.OnAttach(self, ParentDefineID, SlotName)
    if SlotName == Flying_Item_Slot_Name then
        local Own_Backpack_Component = UGCItemSystemV2.GetOwnBackpackComponent(self) -- 所属背包组件
        local Player_Controller = Own_Backpack_Component:GetOwner() -- 所属玩家控制器
        Player_Controller:Update_Flying_Item(Magic_Carpet_Item_ID, true, self:GetDefineID())
        L_GloTools.SetAnimMontage(Player_Controller, L_Enum.Name_AnimMontagePath.MoTan_Fly, true)
    end
end

--[[----------------------卸下魔毯时关闭飞行控制------------------------]]
function BP_Item_MoTan:OnDetach(ParentDefineID, SlotName)
    local Own_Backpack_Component = UGCItemSystemV2.GetOwnBackpackComponent(self) -- 所属背包组件
    local Player_Controller = Own_Backpack_Component:GetOwner() -- 所属玩家控制器
    BP_Item_MoTan.SuperClass.OnDetach(self, ParentDefineID, SlotName)
    if SlotName == Flying_Item_Slot_Name then
        Player_Controller:Update_Flying_Item(Magic_Carpet_Item_ID, false)
        L_GloTools.SetAnimMontage(Player_Controller, L_Enum.Name_AnimMontagePath.MoTan_Fly, false)
    end
end

return BP_Item_MoTan
