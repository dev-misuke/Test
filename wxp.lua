-- =====================================================================
-- DEBUG SCRIPT: Check commands.exec behavior
-- =====================================================================

print("Debug start...")

local function test_exe(cmd)
    print("Executing: " .. cmd)
    local success, result = commands.exec(cmd)
    if success then
        print("-> Success!")
    else
        print("-> Failed: " .. tostring(result and result[1] or "Unknown"))
    end
    os.sleep(0.1)
end

-- 試しに原点付近に小さなブロックを1つ置いてみるテスト
test_exe("fill 0 10 0 5 15 5 mekanism:block_reinforced_obsidian")

print("Debug finished.")
