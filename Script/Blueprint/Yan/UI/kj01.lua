---@class kj01_C:UUserWidget
---@field Button_88 UButton
---@field Image_16 UImage
---@field Image_18 UImage
---@field TextBlock_81 UTextBlock
--Edit Below--
---@class kj01_C:UUserWidget
---@field Button_88 UButton
---@field Image_16 UImage
---@field Image_18 UImage
---@field TextBlock_81 UTextBlock
-- Edit Below--
local kj01 = {
    bInitDoOnce = false
}

--[[----------------------初始化密码界面------------------------]]
function kj01:Construct()
    self:LuaInit();

end

-- function kj01:Tick(MyGeometry, InDeltaTime)

-- end

-- function kj01:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
--[[----------------------绑定密码界面事件------------------------]]
function kj01:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_88.OnClicked:Add(self.Button_88_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------关闭密码界面------------------------]]
function kj01:Button_88_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.kj01, false)
end

--[[----------------------刷新房间密码------------------------]]
function kj01:SetRoomPass(Room_Pass)
    self.TextBlock_81:SetText(tostring(Room_Pass))
end

-- [Editor Generated Lua] function define End;

return kj01
