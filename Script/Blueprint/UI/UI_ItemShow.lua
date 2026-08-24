---@class UI_ItemShow_C:UUserWidget
---@field CanvasPanel_1 UCanvasPanel
---@field CanvasPanel_2 UCanvasPanel
---@field CanvasPanel_3 UCanvasPanel
---@field CanvasPanel_4 UCanvasPanel
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
--Edit Below--
local UI_ItemShow = {
    bInitDoOnce = false
}
local Item_Show_Config = {
    [L_Enum.ID_ItemShow.ZhaDan] = {
        Duration = 0.6,
        Last_Frame_Progress = 19 / 20,
        Start_Sound_Name = SoundMgr.SoundName.Boom
    }, -- 炸弹播放配置
    [L_Enum.ID_ItemShow.XiangJiao] = {
        Duration = 0.75,
        Last_Frame_Progress = 2 / 3,
        Start_Sound_Name = SoundMgr.SoundName.Banana
    }, -- 香蕉播放配置
    [L_Enum.ID_ItemShow.BaBa] = {
        Duration = 2.7,
        Last_Frame_Progress = 44 / 45,
        Start_Sound_Name = SoundMgr.SoundName.Freeze_Start
    }, -- 粑粑播放配置
    [L_Enum.ID_ItemShow.WinCup] = {
        Duration = 2.28,
        Last_Frame_Progress = 29 / 30
    } -- 奖杯播放配置
}

--[[----------------------初始化物品展示界面------------------------]]
function UI_ItemShow:Construct()
    local Trophy_Material = UGCObjectUtility.LoadObject(UGCGameSystem.GetUGCResourcesFullPath(
        'Asset/Blueprint/UI/Pic_Gif/M_UI_Pic_11_Flipbook.M_UI_Pic_11_Flipbook')) -- 奖杯材质
    self.Image_3:SetBrushFromMaterial(Trophy_Material)
    self.Material_Instance_Map = {
        [L_Enum.ID_ItemShow.ZhaDan] = self.Image_0:GetDynamicMaterial(),
        [L_Enum.ID_ItemShow.XiangJiao] = self.Image_1:GetDynamicMaterial(),
        [L_Enum.ID_ItemShow.BaBa] = self.Image_2:GetDynamicMaterial(),
        [L_Enum.ID_ItemShow.WinCup] = self.Image_3:GetDynamicMaterial()
    }
    self.Play_State_Map = { -- 各物品独立播放状态
        [L_Enum.ID_ItemShow.ZhaDan] = {
            Canvas_Panel = self.CanvasPanel_1,
            Material_Instance = self.Material_Instance_Map[L_Enum.ID_ItemShow.ZhaDan],
            Play_Elapsed_Time = 0,
            Is_Playing = false
        },
        [L_Enum.ID_ItemShow.XiangJiao] = {
            Canvas_Panel = self.CanvasPanel_2,
            Material_Instance = self.Material_Instance_Map[L_Enum.ID_ItemShow.XiangJiao],
            Play_Elapsed_Time = 0,
            Is_Playing = false
        },
        [L_Enum.ID_ItemShow.BaBa] = {
            Canvas_Panel = self.CanvasPanel_3,
            Material_Instance = self.Material_Instance_Map[L_Enum.ID_ItemShow.BaBa],
            Play_Elapsed_Time = 0,
            Is_Playing = false
        },
        [L_Enum.ID_ItemShow.WinCup] = {
            Canvas_Panel = self.CanvasPanel_4,
            Material_Instance = self.Material_Instance_Map[L_Enum.ID_ItemShow.WinCup],
            Play_Elapsed_Time = 0,
            Is_Playing = false
        }
    }
    self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
    self.CanvasPanel_2:SetVisibility(ESlateVisibility.Collapsed)
    self.CanvasPanel_3:SetVisibility(ESlateVisibility.Collapsed)
    self.CanvasPanel_4:SetVisibility(ESlateVisibility.Collapsed)
end

--[[----------------------播放指定物品屏幕特效------------------------]]
function UI_ItemShow:PlayOnce(Item_Show_ID)
    local Current_Config = Item_Show_Config[Item_Show_ID] -- 当前屏幕特效播放配置
    local Current_State = self.Play_State_Map[Item_Show_ID] -- 当前物品播放状态
    if not Current_Config or not Current_State then
        return
    end

    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Current_State.Canvas_Panel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Current_State.Play_Elapsed_Time = 0
    Current_State.Is_Playing = true
    if Current_State.Material_Instance then
        Current_State.Material_Instance:SetScalarParameterValue("FrameNumber", 0)
    end
    if Current_Config.Start_Sound_Name then
        SoundMgr.PlaySound2D(Current_Config.Start_Sound_Name)
    end
end

--[[----------------------更新所有物品序列帧播放进度------------------------]]
function UI_ItemShow:Tick(MyGeometry, InDeltaTime)
    local Has_Playing = false -- 是否还有正在播放的物品特效
    for Item_Show_ID, Current_Config in pairs(Item_Show_Config) do
        local Current_State = self.Play_State_Map[Item_Show_ID]
        if Current_State.Is_Playing then
            Current_State.Play_Elapsed_Time = Current_State.Play_Elapsed_Time + InDeltaTime
            local Raw_Frame_Progress = Current_State.Play_Elapsed_Time / Current_Config.Duration -- 当前屏幕特效原始播放进度
            if Raw_Frame_Progress >= 1 then
                Current_State.Is_Playing = false
                Current_State.Canvas_Panel:SetVisibility(ESlateVisibility.Collapsed)
            else
                Has_Playing = true
                if Current_State.Material_Instance then
                    local Frame_Progress = math.min(Raw_Frame_Progress, Current_Config.Last_Frame_Progress) -- 限制到最后有效帧
                    Current_State.Material_Instance:SetScalarParameterValue("FrameNumber", Frame_Progress)
                end
            end
        end
    end

    if not Has_Playing then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- function UI_ItemShow:Destruct()

-- end

return UI_ItemShow
