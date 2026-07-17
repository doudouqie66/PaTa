L_TipsTool = L_TipsTool or {}
local LastToastTime = 0

--[[----------------------显示小提示------------------------]]
function L_TipsTool.ShowTips_01(text)
    local NowTime = os.time()
    if NowTime - LastToastTime < 1 then
        return
    end
    LastToastTime = NowTime
    TipsMgr.ShowTips_01(text)
end
--[[---------------------官方Api-------------------------]] --
function L_TipsTool.ShowOfficialTips(str)
    UGCWidgetManagerSystem.ShowTipsUI(str)
end

return L_TipsTool
