--command buttons callback functions
Toggle_elac_1_callback = function (phase)
    if phase == SASL_COMMAND_BEGIN then
        set(ELAC_1_off_button, 1 - get(ELAC_1_off_button))
    end
end
Toggle_elac_2_callback = function (phase)
    if phase == SASL_COMMAND_BEGIN then
        set(ELAC_2_off_button, 1 - get(ELAC_2_off_button))
    end
end

Toggle_sec_1_callback = function (phase)
    if phase == SASL_COMMAND_BEGIN then
        set(SEC_1_off_button, 1 - get(SEC_1_off_button))
    end
end
Toggle_sec_2_callback = function (phase)
    if phase == SASL_COMMAND_BEGIN then
        set(SEC_2_off_button, 1 - get(SEC_2_off_button))
    end
end

--register commands
sasl.registerCommandHandler (Toggle_ELAC_1, 0, Toggle_elac_1_callback)
sasl.registerCommandHandler (Toggle_ELAC_2, 0, Toggle_elac_2_callback)
sasl.registerCommandHandler (Toggle_SEC_1, 0, Toggle_sec_1_callback)
sasl.registerCommandHandler (Toggle_SEC_2, 0, Toggle_sec_2_callback)