-- =====================================================================
-- FIFE.SYSTEMS MEGASHIP ULTIMATE BUILDER (GitHub Deployment Version)
-- Dimensions: X=50,000 / Y=1,000 / Z=100,000
-- =====================================================================

print("Initiating Ultimate Megaship Construction Protocol...")
print("Target Dimensions: 50k(W) x 1k(H) x 100k(D)")

-- 究極の爆破耐性（絶対破壊不能）マテリアル定義
local dark = "mekanism:block_reinforced_obsidian"
local white = "securitycraft:reinforced_white_concrete"
local glass = "mekanism:structural_glass"

-- コマンド実行用ラッパー（エラー修正箇所：commands.execを使用）
local function exe(cmd)
    commands.exec(cmd)
    os.sleep(0.05)
end

-- =====================================================================
-- 1. 巨大ドックの整地 (Z= -5000 to 0) - 後部エンジン用の空間確保
-- =====================================================================
print("[1/5] Clearing terrain for Rear Engines...")
exe("fill -15000 0 -5000 15000 1000 0 air")

print("[2/5] Constructing 4x Rear Engine Pods...")
-- 画像の巨大な4連装メインスラスター（白と黒の混色）
exe(string.format("fill -12000 100 -4000 -2000 450 0 %s", white))
exe(string.format("fill 2000 100 -4000 12000 450 0 %s", white))
exe(string.format("fill -12000 500 -4000 -2000 850 0 %s", dark))
exe(string.format("fill 2000 500 -4000 12000 850 0 %s", dark))

-- =====================================================================
-- 2. メイン船体と部屋割り（整地しながら10万ブロック先へ進む）
-- =====================================================================
print("[3/5] Generating Sloped Hull, Clearing Terrain, and Dividing Rooms...")
local max_z = 100000
local max_x = 25000 -- 横5万の半分(原点から左右)
local max_y = 1000

-- Z軸方向に500ブロックずつ進みながら生成（マイクラを落とさないための細分化）
for z = 0, max_z, 500 do
    -- 【豆腐回避ロジック】先端(Z=100000)に行くほど幅と高さが鋭く狭まる計算
    local current_x = math.floor(max_x * (1 - (z / max_z)))
    local current_y = math.floor(max_y * (1 - (z / max_z)))
    if current_y < 150 then current_y = 150 end -- 最小の高さを確保
    if current_x < 50 then current_x = 50 end

    -- ① まずその座標の地形（山など）を完全に消し飛ばす【整地】
    exe(string.format("fill %d 0 %d %d %d %d air", -current_x-10, z, current_x+10, current_y+10, z+499))

    -- ② 画像に基づくツートンカラーの外殻生成（下部は黒、上部は白）
    local mid_y = math.floor(current_y * 0.4)
    exe(string.format("fill %d 0 %d %d %d %d %s", -current_x, z, current_x, mid_y, z+499, dark))
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x+10, mid_y+1, z, current_x-10, current_y, z+499, white))

    -- ③ 内部をくり抜いて居住区・格納庫を作る（外殻の厚さは20ブロック確保）
    exe(string.format("fill %d 20 %d %d %d %d air", -current_x+20, z+20, current_x-20, current_y-20, z+480))

    -- ④ 【部屋分け】500ブロックごとに強化オブシディアンの分厚い防爆隔壁を設置
    exe(string.format("fill %d 20 %d %d %d %d %s", -current_x+20, z, current_x-20, current_y-20, z+19, dark))

    -- ⑤ 側面にMekanismの構造ガラスをはめ込む（ビューポート）
    exe(string.format("fill %d %d %d %d %d %d %s", -current_x, mid_y+20, z+100, -current_x, mid_y+80, z+400, glass))
    exe(string.format("fill %d %d %d %d %d %d %s", current_x, mid_y+20, z+100, current_x, mid_y+80, z+400, glass))
end

-- =====================================================================
-- 3. 密着した巨大ウイングの生成 (Z=40000 〜 70000付近)
-- =====================================================================
print("[4/5] Constructing Massive Swept Wings...")
-- 船体から離さず、ガッチリ接続された幅広の黒い翼
for z = 40000, 70000, 1000 do
    local wing_width = 30000 - math.floor((z - 40000) * 0.5) -- 後ろに下がるほど広がる後退翼
    exe(string.format("fill %d 250 %d -15000 350 %d %s", -wing_width, z, z+999, dark))
    exe(string.format("fill 15000 250 %d %d 350 %d %s", z, wing_width, z+999, dark))
end

-- =====================================================================
-- 4. 構造ガラス張りの巨大管制室（メインブリッジ）
-- =====================================================================
print("[5/5] Elevating Main Bridge with Structural Glass...")
-- 高さ800付近にそびえる、画像の独立した巨大ブリッジ
local b_z = 75000 -- Z=7万5000地点の上部に設置
exe(string.format("fill -4000 750 %d 4000 950 %d %s", b_z, b_z+5000, white))
exe(string.format("fill -3800 770 %d 3800 930 %d air", b_z+20, b_z+4980)) -- 内部空洞化

-- ブリッジ正面と側面のパノラマ・構造ガラス張り
exe(string.format("fill -3800 770 %d 3800 900 %d %s", b_z+5000, b_z+5000, glass)) -- 正面
exe(string.format("fill -4000 770 %d -4000 900 %d %s", b_z, b_z+5000, glass))    -- 左側面
exe(string.format("fill 4000 770 %d 4000 900 %d %s", b_z, b_z+5000, glass))      -- 右側面

print("=========================================================")
print("ALL SYSTEMS NOMINAL. 100k MEGASHIP HAS BEEN FULLY BUILT.")
print("=========================================================")
