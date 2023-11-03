
function runHomeCheck(zStallMax)
    send_message("info", "Running boot home possition checks", "toast")

    -- get up as much as we can before enabling stall detection
    go_to_home("z")

    -- let user set z stall level, but default if missing
    -- Turn on stall detection for the Z axis
    update_firmware_config({
        encoder_enabled_x = 1,
        encoder_enabled_y = 1,
        encoder_enabled_z = 1,
        encoder_missed_steps_max_z = zStallMax
    })
    -- need config to flush to device
    wait(6000)

    -- Find home on each (two attempts)
    find_home("z")
    find_home("z")

    find_home("x")
    find_home("x")

    find_home("y")
    find_home("y")

    -- Turn off stall detection for the Z axis
    update_firmware_config({ encoder_enabled_z = 0 })
    wait(6000)
end

function main()
    -- Hardcoded variables so that this works with the `BOOT SEQUENCE` setting
    local zStallMax = '70' -- stall level

    runHomeCheck(zStallMax)
end

main()
