---@class HeadTop_UI_C:UUserWidget
---@field TextBlock_0 UTextBlock
-- Edit Below--
local HeadTop_UI = {
    bInitDoOnce = false
}

--[[----------------------刷新头顶奖杯数量------------------------]]
function HeadTop_UI:RefreshTrophyCount(Trophy_Count)
    self.TextBlock_0:SetText(tostring(Trophy_Count))
end
--[==[ Construct
function HeadTop_UI:Construct()
	
end
-- Construct ]==]

-- function HeadTop_UI:Tick(MyGeometry, InDeltaTime)

-- end

-- function HeadTop_UI:Destruct()

-- end

return HeadTop_UI
