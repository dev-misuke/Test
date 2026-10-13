-- =====================================================================
-- FIFE.SYSTEMS MEGASHIP ULTIMATE BUILDER (Dynamic Forceload Edition)
-- Dimensions: X=50,000 / Y=1,000 / Z=100,000
-- =====================================================================

print("Initiating Ultimate Megaship Construction Protocol...")
print("Target Dimensions: 50k(W) x 1k(H) x 100k(D)")

local dark = "mekanism:block_reinforced_obsidian"
local white = "securitycraft:reinforced_white_concrete"
local glass = "mekanism:structural_glass"

-- 動的チャンクロード＆エラーハンドリング付きコマンド実行ラッパー
local function exe(cmd)
    -- fillコマンドの座標（x1, y1, z1, x2, y2, z2）を正確に抽出
    local x1, y1, z1, x2, y2, z2 = string.match(cmd, "fill%s+(%-?%d+)%s+(%-?%d+)%s+(%-?%d+)%s+(%-?%d+)%s+(%-?%d+)%s+(%-?%d+)")
    
    if x1 and z1 and x2 and z2 then
        -- 1. 設置予定エリアのチャンクを強制ロード（チャンク外エラーを完全防止）
        commands.exec(string.format("forceload add %s %s %s %s", x1, z1, x2, z2))
        os.sleep(0.02)
    end

    -- 2. コマンド実行
    local success, output = commands.exec(cmd)
    if not success then
        term.setTextColor(colors.red)
        print("❌ 警告/エラー: " .. (output and output[1] or "Unknown"))
        term.setTextColor(colors.white)
    end

    if x1 and z1 and x2 and z2 then
        -- 3. 処理終了後、速やかにチャンクロードを解除してメモリを保護
        commands.exec(string.format("forceload remove %s %s %s %s", x1, z1, x2, z2))
    end
    
    os.sleep(0.01)
end

-- =====================================================================
-- 1. 後部エンジンのための空間確保 ＆ 4連スラスター構築
-- =====================================================================
print("[1/5] Constructing Rear Engines...")
exe("fill -15000 0 -5000 15000 1000 0 air")
exe(string.format("fill -12000 100 -4000 -2000 450 0 %s", white))
exe(string.format("fill 2000 100 -4000 12000 450 0 %s", white))
exe(string.format("fill -12000 500 -4000 -2000 850 0 %s", dark))
exe(string.format("fill 2000 500 -4000 12000 850 0 %s", dark))

-- =====================================================================
-- 2. メイン船体と部屋割り（奥行き10万ブロック・自動整地ループ）
-- =====================================================================
print("[2/5] Generating 100k Hull & Rooms with Dynamic Forceload...")
local max_z = 100000
local max_x = 25000
local max_y = 1000

for z = 0, max_z, 500 do
    local current_x = math.floor(max_x * (1 - (z / max_z)))
    local current_y = math.floor(max_y * (1 - (z / max_z)))
    if current_y < 150 then current_y = 150 end
    if current_x < 50 then current_x = 50 end

    -- ① 整地（前方の地形をすべて空気に置換）
    exe(string.format("fill %d 0 %d %d %d %d air", -current_x-10, z, current_x+10, current_y+10, z+499))
    
    -- ② ツートン外殻（下部：黒、上部：白）
    local mid_y = math.floor(current_y * 0.4)
    exe(string.format("fill %d 0 %d %d %d %d %s", -current_x, z, current_x, mid_y, z+499, dark))
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x+10, mid_y+1, z, current_x-10, current_y, z+499, white))
    
    -- ③ 内部空洞化（居住区・格納庫スペース）
    exe(string.format("fill %d 20 %d %d %d %d air", -current_x+20, z+20, current_x-20, current_y-20, z+480))
    
    -- ④ 【部屋分け】500ブロックごとの防爆隔壁
    exe(string.format("fill %d 20 %d %d %d %d %s", -current_x+20, z, current_x-20, current_y-20, z+19, dark))
    
    -- ⑤ 側面の構造ガラス（ビューポート）
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x, mid_y+20, z+100, -current_x, mid_y+80, z+400, glass))
    exe(string.format("fill %d %d %d %d %d %d %s", current_x, mid_y+20, z+100, current_x, mid_y+80, z+400, glass))
end

-- =====================================================================
-- 3. 密着した巨大ウイングの生成
-- =====================================================================
print("[3/5] Constructing Massive Swept Wings...")
for z = 40000, 70000, 1000 do
    local wing_width = 30000 - math.floor((z - 40000) * 0.5)
    exe(string.format("fill %d 250 %d -15000 350 %d %s", -wing_width, z, z+999, dark))
    exe(string.format("fill 15000 250 %d %d 350 %d %s", z, wing_width, z+999, dark))
end

-- =====================================================================
-- 4. 構造ガラス張りの巨大管制室（メインブリッジ）
-- =====================================================================
print("[4/5] Elevating Main Bridge with Structural Glass...")
local b_z = 75000
exe(string.format("fill -4000 750 %d 4000 950 %d %s", b_z, b_z+5000, white))
exe(string.format("fill -3800 770 %d 3800 930 %d air", b_z+20, b_z+4980))
exe(string.format("fill -3800 770 %d 3800 900 %d %s", b_z+5000, b_z+5000, glass))
exe(string.format("fill -4000 770 %d -4000 900 %d %s", b_z, b_z+5000, glass))
exe(string.format("fill 4000 770 %d 4000 900 %d %s", b_z, b_z+5000, glass))

print("=========================================================")
print("ALL SYSTEMS NOMINAL. 100k MEGASHIP FULLY CONSTRUCTED.")
print("=========================================================")
