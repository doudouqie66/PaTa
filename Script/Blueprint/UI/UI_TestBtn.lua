---@class UI_TestBtn_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
    self.Button_1.OnClicked:Add(self.Button_1_OnClicked, self);
end
function UI_TestBtn:Button_0_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, false, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, true, true)
end
function UI_TestBtn:Button_1_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, false, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, true, true)
end
return UI_TestBtn
