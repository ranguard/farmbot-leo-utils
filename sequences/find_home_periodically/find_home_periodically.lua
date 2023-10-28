function shouldSkipHomeCheck()
    local time_check = env("HOME_CHECK_AFTER")
    -- toast("shouldSkipHomeCheck time_check value = " .. time_check)
    if time_check then
        -- has the time check expired?
        local now = os.time();
        if now > tonumber(time_check) then
            return 0
        end
    else
        -- It was not set previously so run now
        return 0
    end
    -- Assume we are skipping the check
    return 1
end

function runHomeCheck(zStallMax)
    send_message("info", "Running home possition checks", "toast")

    -- get up as much as we can before enabling stall detection
    go_to_home("z")

    -- let user set z stall level, but default if missing
    -- Turn on stall detection for the Z axis
    update_firmware_config({
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
    -- Make sure we have the variables we need
    local secondsUntilNextCheck = variable("Seconds between checks");

    zStallMax = variable("Z stall level")
    if zStallMax == 0 then
        zStallMax = '70'
    end

    local shouldSkipHomeCheck = shouldSkipHomeCheck();

    if shouldSkipHomeCheck == 0 then
        -- run home check
        runHomeCheck(zStallMax)

        -- reset time until next check
        local checkAgainAfter = tostring(os.time() + secondsUntilNextCheck)
        env("HOME_CHECK_AFTER", checkAgainAfter)
    else
        toast("Not time to run home possition checks")
    end
end

main()
