---@class BP_Item_Jetpack_C:Item_Unuse_Tmp_C
--Edit Below--
local BP_Item_Jetpack = {} 

--[[V2背包事件]]--
--[[
--- func 能否更新此物品实例，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
---@return 是否允许物品数量更新，若不允许，物品添加或移除操作可能失败
-- function BP_Item_Jetpack:CanUpdateItemCountV2(NewItemCount, OldItemCount)
--     return BP_Item_Jetpack.SuperClass.CanUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 物品数量更新后回调，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
-- function BP_Item_Jetpack:OnUpdateItemCountV2(NewItemCount, OldItemCount)
--     BP_Item_Jetpack.SuperClass.OnUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 能否使用物品，可重载并自定义(服务端生效)
---@return 物品是否能够被使用
-- function BP_Item_Jetpack:CanUseV2()
--     return BP_Item_Jetpack.SuperClass.CanUseV2(self);
-- end

--- func 当物品被使用回调，可重载并自定义(服务端生效)
-- function BP_Item_Jetpack:OnUseV2()
--     BP_Item_Jetpack.SuperClass.OnUseV2(self);
-- end

--- func 当物品被取消使用，与UseItem对应，用于清理状态，应当支持多次调用，不产生额外副作用，移除物品时自动调用，可重载并自定义(服务端生效)
-- function BP_Item_Jetpack:OnDisuseV2()
--     BP_Item_Jetpack.SuperClass.OnDisuseV2(self);
-- end

--- func 其他物品能否附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_Jetpack:CanAttachToSlot(SlotName, ItemDefineID)
--     return BP_Item_Jetpack.SuperClass.CanAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当其他物品附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_Jetpack:OnAttachToSlot(SlotName, ItemDefineID)
--     BP_Item_Jetpack.SuperClass.OnAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当物品从此槽位移除(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function BP_Item_Jetpack:OnDetachBySlot(SlotName, ItemDefineID)
--     BP_Item_Jetpack.SuperClass.OnDetachBySlot(self, SlotName, ItemDefineID);
-- end

--- func 能否Attach到Parent物品上, 如果Parent为空物品, 说明将被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
---@return bool 能否Attach
-- function BP_Item_Jetpack:CanAttach(ParentDefineID, SlotName)
--     return BP_Item_Jetpack.SuperClass.CanAttach(self, ParentDefineID, SlotName);
-- end

--- func 当Attach到Parent物品上, 如果Parent为空物品, 说明是被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function BP_Item_Jetpack:OnAttach(ParentDefineID, SlotName)
--     BP_Item_Jetpack.SuperClass.OnAttach(self, ParentDefineID, SlotName);
-- end

--- func 当从Parent物品上解除Attach, 如果Parent为空物品, 说明是从背包装备槽位解除装备(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function BP_Item_Jetpack:OnDetach(ParentDefineID, SlotName)
--     BP_Item_Jetpack.SuperClass.OnDetach(self, ParentDefineID, SlotName);
-- end

--- func 当物品被装备前，检查能否装备(服务端生效)
---@return bool 能否装备
-- function BP_Item_Jetpack:CanEquip()
--     return BP_Item_Jetpack.SuperClass.CanEquip(self);
-- end

--- func 当物品被装备回调(服务端生效)
-- function BP_Item_Jetpack:OnEquip()
--     BP_Item_Jetpack.SuperClass.OnEquip(self);
-- end

--- func 当物品被卸下回调(服务端生效)
-- function BP_Item_Jetpack:OnUnEquip()
--     BP_Item_Jetpack.SuperClass.OnUnEquip(self);
-- end

--- func 当物品在背包中被交换槽位前，检查能否交换(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
---@return 能否交换到新槽位
-- function BP_Item_Jetpack:CanSwapEquipSlot(OldSlotName, NewSlotName)
--     return BP_Item_Jetpack.SuperClass.CanSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品被交换到新装备槽位后回调(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
-- function BP_Item_Jetpack:OnSwapEquipSlot(OldSlotName, NewSlotName)
--     BP_Item_Jetpack.SuperClass.OnSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品开始使用时回调，可重载并自定义(服务端生效)
-- function BP_Item_Jetpack:UGC_OnStartUse()
--     BP_Item_Jetpack.SuperClass.UGC_OnStartUse(self)
-- end

--- func 当物品停止使用时回调，可重载并自定义(服务端生效)，在OnUseV2后调用
-- function BP_Item_Jetpack:UGC_OnStopUse(Reason)
    BP_Item_Jetpack.SuperClass.UGC_OnStopUse(self, Reason)
-- end
]]--

local Jetpack_Item_ID = 8310037 -- 冲天炮物品ID
local Flying_Item_Slot_Name = "EquipmentSlot.Custom.Jetpack" -- 飞行物装备槽位

--[[----------------------装备冲天炮时显示飞行界面------------------------]]
function BP_Item_Jetpack:OnAttach(ParentDefineID, SlotName)
    BP_Item_Jetpack.SuperClass.OnAttach(self, ParentDefineID, SlotName)
    if SlotName == Flying_Item_Slot_Name then
        local Own_Backpack_Component = UGCItemSystemV2.GetOwnBackpackComponent(self) -- 所属背包组件
        local Player_Controller = Own_Backpack_Component:GetOwner() -- 所属玩家控制器
        Player_Controller:Update_Flying_Item(Jetpack_Item_ID, true, self:GetDefineID())
    end
end

--[[----------------------卸下冲天炮时隐藏飞行界面------------------------]]
function BP_Item_Jetpack:OnDetach(ParentDefineID, SlotName)
    local Own_Backpack_Component = UGCItemSystemV2.GetOwnBackpackComponent(self) -- 所属背包组件
    local Player_Controller = Own_Backpack_Component:GetOwner() -- 所属玩家控制器
    if SlotName == Flying_Item_Slot_Name then
        Player_Controller:Set_Jetpack_Flying(false)
    end
    BP_Item_Jetpack.SuperClass.OnDetach(self, ParentDefineID, SlotName)
    if SlotName == Flying_Item_Slot_Name then
        Player_Controller:Update_Flying_Item(Jetpack_Item_ID, false)
    end
end

return BP_Item_Jetpack
