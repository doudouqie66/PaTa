---@class Item_04_C:UUserWidget
---@field Button_5 UButton
---@field CanvasPanel_3 UCanvasPanel
---@field Image_5 UImage
---@field Image_6 UImage
--Edit Below--
local Item_04 = { bInitDoOnce = false } 

--[[----------------------初始化物品四控件------------------------]]
function Item_04:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_5.OnClicked:Add(self.Button_5_OnClicked, self)
end

--[[----------------------点击后折叠物品四按钮------------------------]]
function Item_04:Button_5_OnClicked()
    self.Button_5:SetVisibility(ESlateVisibility.Collapsed)
end

-- function Item_04:Tick(MyGeometry, InDeltaTime)

-- end

-- function Item_04:Destruct()

-- end

return Item_04
