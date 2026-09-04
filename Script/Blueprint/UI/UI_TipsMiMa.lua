---@class UI_TipsMiMa_C:UUserWidget
---@field Move UWidgetAnimation
---@field Image_0 UImage
---@field UTRichTextBlock_6 UUTRichTextBlock
--Edit Below--
local UI_TipsMiMa = {
    bInitDoOnce = false
}

function UI_TipsMiMa:Construct()
    self:PlayAnimation(self.Move, 0, 0, EUMGSequencePlayMode.Forward, 1);

end

-- function UI_TipsMiMa:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI_TipsMiMa:Destruct()

-- end

return UI_TipsMiMa