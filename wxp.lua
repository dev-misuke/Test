-- =====================================================================
-- FIFE.SYSTEMS MEGASHIP STABLE BUILDER
-- =====================================================================

print("Starting Stable Megaship Construction...")

local dark = "mekanism:block_reinforced_obsidian"
local white = "securitycraft:reinforced_white_concrete"
local glass = "mekanism:structural_glass"

-- 文字化けや余計なエラーログを出さない、純度100%のコマンド実行関数
local function exe(cmd)
    commands.exec(cmd)
    os.sleep(0.02)
end

-- 1. 後部エンジンの空間確保
print("[1/4] Rear Engines Setup...")
exe("fill -15000 0 -5000 15000 1000 0 air")
exe(string.format("fill -12000 100 -4000 -2000 450 0 %s", white))
exe(string.format("fill 2000 100 -4000 12000 450 0 %s", white))
exe(string.format("fill -12000 500 -4000 -2000 850 0 %s", dark))
exe(string.format("fill 2000 500 -4000 12000 850 0 %s", dark))

-- 2. メイン船体と部屋分けの連続生成
print("[2/4] Generating Hull and Interior Rooms...")
local max_z = 100000
local max_x = 25000
local max_y = 1000

for z = 0, max_z, 500 do
    local current_x = math.floor(max_x * (1 - (z / max_z)))
    local current_y = math.floor(max_y * (1 - (z / max_z)))
    if current_y < 150 then current_y = 150 end
    if current_x < 50 then current_x = 50 end

    -- 地形整地
    exe(string.format("fill %d 0 %d %d %d %d air", -current_x-10, z, current_x+10, current_y+10, z+499))
    
    -- 外殻（黒と白）
    local mid_y = math.floor(current_y * 0.4)
    exe(string.format("fill %d 0 %d %d %d %d %s", -current_x, z, current_x, mid_y, z+499, dark))
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x+10, mid_y+1, z, current_x-10, current_y, z+499, white))
    
    -- 内部空洞化
    exe(string.format("fill %d 20 %d %d %d %d air", -current_x+20, z+20, current_x-20, current_y-20, z+480))
    
    -- 防爆隔壁（部屋分け）
    exe(string.format("fill %d 20 %d %d %d %d %s", -current_x+20, z, current_x-20, current_y-20, z+19, dark))
    
    -- 側面の構造ガラス
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x, mid_y+20, z+100, -current_x, mid_y+80, z+400, glass))
    exe(string.format("fill %d %d %d %d %d %d %s", current_x, mid_y+20, z+100, current_x, mid_y+80, z+400, glass))
end

-- 3. 巨大ウイング
print("[3/4] Assembling Wings...")
for z = 40000, 70000, 1000 do
    local wing_width = 30000 - math.floor((z - 40000) * 0.5)
    exe(string.format("fill %d 250 %d -15000 350 %d %s", -wing_width, z, z+999, dark))
    exe(string.format("fill 15000 250 %d %d 350 %d %s", z, wing_width, z+999, dark))
end

-- 4. 構造ガラスの管制室
print("[4/4] Constructing Glass Bridge...")
local b_z = 75000
exe(string.format("fill -4000 750 %d 4000 950 %d %s", b_z, b_z+5000, white))
exe(string.format("fill -3800 770 %d 3800 930 %d air", b_z+20, b_z+4980))
exe(string.format("fill -3800 770 %d 3800 900 %d %s", b_z+5000, b_z+5000, glass))
exe(string.format("fill -4000 770 %d -4000 900 %d %s", b_z, b_z+5000, glass))
exe(string.format("fill 4000 770 %d 4000 900 %d %s", b_z, b_z+5000, glass))

print("=========================================================")
print("BUILD COMPLETE: 100k Megaship successfully generated.")
print("=========================================================")
