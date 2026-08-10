---@class UI_TipsToutch_C:UUserWidget
---@field Move UWidgetAnimation
---@field Image_0 UImage
---@field UIParticleEmitter_0 UUIParticleEmitter
---@field UTRichTextBlock_6 UUTRichTextBlock
--Edit Below--
local UI_TipsToutch = {
    bInitDoOnce = false
}

function UI_TipsToutch:Construct()
    self:PlayAnimation(self.Move, 0, 0, EUMGSequencePlayMode.Forward, 1);

end

-- function UI_TipsToutch:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI_TipsToutch:Destruct()

-- end

return UI_TipsToutch