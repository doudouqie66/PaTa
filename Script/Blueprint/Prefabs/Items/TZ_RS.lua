---@class TZ_RS_C:Template_Throwable_Burning_C
--Edit Below--
local TZ_RS = {} 

--[[经典背包事件]]--
--[[
--- func 处理物品的拾取(服务端生效)
---@return bool @是否拾取该物品, 返回true才能拾取进背包
-- function TZ_RS:HandlePickup(ItemContainer, PickupInfo, Reason)
--    return TZ_RS.SuperClass.HandlePickup(self, ItemContainer, PickupInfo, Reason)
-- end

--- func 处理物品的丢弃(服务端生效)
---@return bool @是否丢弃该物品, 返回true才会丢弃
-- function TZ_RS:HandleDrop(InCount, Reason)
--    return TZ_RS.SuperClass.HandleDrop(self, InCount, Reason)
-- end

--- func 处理物品的取出(服务端生效)
---@return number @可取出物品数量
-- function TZ_RS:HandleTake(TakeCount, TotalCount)
--    return TZ_RS.SuperClass.HandleTake(self, TakeCount, TotalCount)
-- end

--- func 处理物品的使用(服务端生效)
---@return bool @使用是否成功
-- function TZ_RS:HandleUse(Target, Reason)
--    return TZ_RS.SuperClass.HandleUse(self, Target, Reason) 
-- end

--- func 处理物品的取消使用(服务端生效)
---@return bool @取消使用是否成功
-- function TZ_RS:HandleDisuse(Reason)
--    return TZ_RS.SuperClass.HandleDisuse(self, Reason) 
-- end

--- func 尝试取消使用物品，仅尝试(服务端生效)
---@return bool @物品能否取消使用
-- function TZ_RS:HandleTryDisuse(Reason)
--    return TZ_RS.SuperClass.HandleTryDisuse(self, Reason)
-- end

--- func 处理物品的有效性(服务端生效)
-- function TZ_RS:HandleEnable(bEnable)
--    TZ_RS.SuperClass.HandleEnable(self, bEnable)
-- end

--- func 处理物品的清除(服务端生效)
---@return bool @清除物品是否成功
-- function TZ_RS:HanldeCleared()
--    return TZ_RS.SuperClass.HanldeCleared(self)
-- end
]]--

--[[V2背包事件]]--
--[[
--- func 其他物品能否附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function TZ_RS:CanAttachToSlot(SlotName, ItemDefineID)
--     return TZ_RS.SuperClass.CanAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当其他物品附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function TZ_RS:OnAttachToSlot(SlotName, ItemDefineID)
--     TZ_RS.SuperClass.OnAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当物品从此槽位移除(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function TZ_RS:OnDetachBySlot(SlotName, ItemDefineID)
--     TZ_RS.SuperClass.OnDetachBySlot(self, SlotName, ItemDefineID);
-- end

--- func 能否Attach到Parent物品上, 如果Parent为空物品, 说明将被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
---@return bool 能否Attach
-- function TZ_RS:CanAttach(ParentDefineID, SlotName)
--     return TZ_RS.SuperClass.CanAttach(self, ParentDefineID, SlotName);
-- end

--- func 当Attach到Parent物品上, 如果Parent为空物品, 说明是被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function TZ_RS:OnAttach(ParentDefineID, SlotName)
--     TZ_RS.SuperClass.OnAttach(self, ParentDefineID, SlotName);
-- end

--- func 当从Parent物品上解除Attach, 如果Parent为空物品, 说明是从背包装备槽位解除装备(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function TZ_RS:OnDetach(ParentDefineID, SlotName)
--     TZ_RS.SuperClass.OnDetach(self, ParentDefineID, SlotName);
-- end

--- func 当物品被装备前，检查能否装备(服务端生效)
---@return bool 能否装备
-- function TZ_RS:CanEquip()
--     return TZ_RS.SuperClass.CanEquip(self);
-- end

--- func 当物品被装备回调(服务端生效)
-- function TZ_RS:OnEquip()
--     TZ_RS.SuperClass.OnEquip(self);
-- end

--- func 当物品被卸下回调(服务端生效)
-- function TZ_RS:OnUnEquip()
--     TZ_RS.SuperClass.OnUnEquip(self);
-- end

--- func 当物品在背包中被交换槽位前，检查能否交换(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
---@return 能否交换到新槽位
-- function TZ_RS:CanSwapEquipSlot(OldSlotName, NewSlotName)
--     return TZ_RS.SuperClass.CanSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品被交换到新装备槽位后回调(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
-- function TZ_RS:OnSwapEquipSlot(OldSlotName, NewSlotName)
        TZ_RS.SuperClass.OnSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end
]]--

return TZ_RS