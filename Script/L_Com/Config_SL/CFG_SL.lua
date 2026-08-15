local CFG_SL = CFG_SL or {}

CFG_SL.Total_Grid_Count = 18 -- 总格子数量

CFG_SL.All = {
    Normal_Gold = {
        Name = "普通金币", -- 道具名称
        Grid_Count = 9, -- 分配格数
        Effect_Value = 8 -- 增加金币数量
    },
    Add_Ten_Gold = {
        Name = "金币+10", -- 道具名称
        Grid_Count = 4, -- 分配格数
        Effect_Value = 10 -- 增加金币数量
    },
    Double_Gold = {
        Name = "金币翻倍", -- 道具名称
        Grid_Count = 2, -- 分配格数
        Effect_Value = 2 -- 当前局内金币倍率
    },
    Banana_Peel = {
        Name = "香蕉皮", -- 道具名称
        Grid_Count = 2, -- 分配格数
        Effect_Value = 10 -- 扣除金币数量
    },
    Explosive = {
        Name = "炸药", -- 道具名称
        Grid_Count = 1, -- 分配格数
        Effect_Value = 0 -- 清零后的局内金币
    }
}

return CFG_SL
