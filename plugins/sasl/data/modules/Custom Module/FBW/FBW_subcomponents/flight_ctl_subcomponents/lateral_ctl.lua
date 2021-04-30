--AILERONS--
function Ailerons_control(lateral_input, has_florence_kit, ground_spoilers_mode)
    --hyd source B or G (1450PSI)
    --reversion of flight computers: ELAC 1 --> 2
    --surface range -25 up +25 down, 10 degrees droop with flaps(calculated by ELAC 1/2)

    --properties
    local no_hyd_recenter_ias = 80
    local no_hyd_spd = 10
    local ailerons_max_def = 25
    local ailerons_speed = 38.5

    --conditions
    local l_aileron_actual_speed = ailerons_speed
    local r_aileron_actual_speed = ailerons_speed

    local l_aileron_def_table = {
        {-1, -ailerons_max_def},
        {0,   10 * get(Flaps_deployed_angle) / 25},
        {1,   ailerons_max_def},
    }
    local r_aileron_def_table = {
        {-1,  ailerons_max_def},
        {0,   10 * get(Flaps_deployed_angle) / 25},
        {1,  -ailerons_max_def},
    }

    local l_aileron_travel_target = Table_interpolate(l_aileron_def_table, lateral_input)
    local r_aileron_travel_target = Table_interpolate(r_aileron_def_table, lateral_input)

    --SURFACE SPEED LOGIC--
    --aileron anti droop--
    if ground_spoilers_mode == 2 and get(FBW_total_control_law) == FBW_NORMAL_LAW then
        if has_florence_kit == true and get(Flaps_internal_config) ~= 0 and adirs_get_avg_pitch() < 2.5 then
            l_aileron_actual_speed = 25
            r_aileron_actual_speed = 25
        end
    end

    --hydralics power detection
    l_aileron_actual_speed = Math_rescale(0, no_hyd_spd, 1450, ailerons_speed, get(Hydraulic_B_press) + get(Hydraulic_G_press))
    r_aileron_actual_speed = Math_rescale(0, no_hyd_spd, 1450, ailerons_speed, get(Hydraulic_B_press) + get(Hydraulic_G_press))

    --detect surface failures
    l_aileron_actual_speed = l_aileron_actual_speed * (1 - get(FAILURE_FCTL_LAIL))
    r_aileron_actual_speed = r_aileron_actual_speed * (1 - get(FAILURE_FCTL_RAIL))

    --TRAVEL TARGETS CALTULATION
    --ground spoilers
    if ground_spoilers_mode == 2 and get(FBW_total_control_law) == FBW_NORMAL_LAW then
        if has_florence_kit == true and get(Flaps_internal_config) ~= 0 and adirs_get_avg_pitch() < 2.5 then
            l_aileron_travel_target = -ailerons_max_def
            r_aileron_travel_target = -ailerons_max_def
        end
    end

    --detect ELAC failures and revert accordingly 1 --> 2
    if get(ELAC_1_status) == 0 and get(ELAC_2_status) == 0 then
        l_aileron_travel_target = 0
        r_aileron_travel_target = 0
    end

    --hydralics power detection-Both HYD not fully/ not working
    l_aileron_travel_target = Math_rescale(0, Math_rescale(0, ailerons_max_def, no_hyd_recenter_ias, -get(Alpha), get(IAS)), 1450, l_aileron_travel_target, get(Hydraulic_B_press) + get(Hydraulic_G_press))
    r_aileron_travel_target = Math_rescale(0, Math_rescale(0, ailerons_max_def, no_hyd_recenter_ias, -get(Alpha), get(IAS)), 1450, r_aileron_travel_target, get(Hydraulic_B_press) + get(Hydraulic_G_press))

    --output to the surfaces
    set(Left_aileron,  Set_anim_value_linear_range(get(Left_aileron),  l_aileron_travel_target, -ailerons_max_def, ailerons_max_def, l_aileron_actual_speed, 5))
    set(Right_aileron, Set_anim_value_linear_range(get(Right_aileron), r_aileron_travel_target, -ailerons_max_def, ailerons_max_def, r_aileron_actual_speed, 5))
end

--permanent variables
Spoilers_obj = {
    num_of_spoils_per_wing = 5,
    l_spoilers_spdbrk_max_air_def = {0, 25, 25, 25, 0},
    r_spoilers_spdbrk_max_air_def = {0, 25, 25, 25, 0},
    l_spoilers_spdbrk_max_ground_def = {6, 20, 40, 40, 0},
    r_spoilers_spdbrk_max_ground_def = {6, 20, 40, 40, 0},
    l_spoilers_datarefs = {Left_spoiler_1,  Left_spoiler_2,  Left_spoiler_3,  Left_spoiler_4,  Left_spoiler_5},
    r_spoilers_datarefs = {Right_spoiler_1, Right_spoiler_2, Right_spoiler_3, Right_spoiler_4, Right_spoiler_5},

    Get_cmded_spdbrk_def = function (spdbrk_input)
        local l_spoilers_spdbrk_max_def = {6, 20, 40, 40, 0}
        local r_spoilers_spdbrk_max_def = {6, 20, 40, 40, 0}
        spdbrk_input = Math_clamp(spdbrk_input, 0, 1)

        if get(Aft_wheel_on_ground) == 1 then
            --on ground and slightly open spoiler 1 with speedbrake handle
            l_spoilers_spdbrk_max_def = Spoilers_obj.l_spoilers_spdbrk_max_ground_def
            r_spoilers_spdbrk_max_def = Spoilers_obj.r_spoilers_spdbrk_max_ground_def
        else
            --adujust max in air deflection of the speedbrakes
            l_spoilers_spdbrk_max_def = Spoilers_obj.l_spoilers_spdbrk_max_air_def
            r_spoilers_spdbrk_max_def = Spoilers_obj.r_spoilers_spdbrk_max_air_def
        end

        local total_cmded_def = 0
        for i = 1, Spoilers_obj.num_of_spoils_per_wing do
            total_cmded_def = total_cmded_def + l_spoilers_spdbrk_max_def[i] * spdbrk_input
            total_cmded_def = total_cmded_def + r_spoilers_spdbrk_max_def[i] * spdbrk_input
        end

        return total_cmded_def
    end,

    Get_curr_spdbrk_def = function ()
        local total_curr_def = 0
        for i = 1, Spoilers_obj.num_of_spoils_per_wing do
            total_curr_def = total_curr_def + get(L_speed_brakes_extension, i)
            total_curr_def = total_curr_def + get(R_speed_brakes_extension, i)
        end

        return total_curr_def
    end,
}

--ROLL SPOILERS & SPD BRAKES--
function Spoilers_control(lateral_input, spdbrk_input, ground_spoilers_mode, in_auto_flight, var_table)
    --during a touch and go one of the thrust levers has to be advanced beyond 20 degrees to disarm the spoilers

    --spoiler 1 2 3 4 5
    --HYD     G Y B Y G
    --SEC     3 3 1 1 2

    --DATAREFS FOR SURFACES
    local l_spoilers_hyd_sys_dataref = {Hydraulic_G_press, Hydraulic_Y_press, Hydraulic_B_press, Hydraulic_Y_press, Hydraulic_G_press}
    local r_spoilers_hyd_sys_dataref = {Hydraulic_G_press, Hydraulic_Y_press, Hydraulic_B_press, Hydraulic_Y_press, Hydraulic_G_press}

    local l_spoilers_flt_computer_dataref = {SEC_3_status, SEC_3_status, SEC_1_status, SEC_1_status, SEC_2_status}
    local r_spoilers_flt_computer_dataref = {SEC_3_status, SEC_3_status, SEC_1_status, SEC_1_status, SEC_2_status}

    local l_spoilers_failure_dataref = {FAILURE_FCTL_LSPOIL_1, FAILURE_FCTL_LSPOIL_2, FAILURE_FCTL_LSPOIL_3, FAILURE_FCTL_LSPOIL_4, FAILURE_FCTL_LSPOIL_5}
    local r_spoilers_failure_dataref = {FAILURE_FCTL_RSPOIL_1, FAILURE_FCTL_RSPOIL_2, FAILURE_FCTL_RSPOIL_3, FAILURE_FCTL_RSPOIL_4, FAILURE_FCTL_RSPOIL_5}

    --limit input range
    spdbrk_input = Math_clamp(spdbrk_input, 0, 1)

    --properties
    local roll_spoilers_threshold = {0.1, 0.1, 0.3, 0.1, 0.1}--amount of sidestick deflection needed to trigger the roll spoilers

    --speeds--
    local l_spoilers_total_max_def = {40, 40, 40, 40, 40}
    local r_spoilers_total_max_def = {40, 40, 40, 40, 40}
    local l_spoilers_spdbrk_max_def = {6, 20, 40, 40, 0}
    local r_spoilers_spdbrk_max_def = {6, 20, 40, 40, 0}
    local l_spoilers_roll_max_def = {0, 35, 7, 35, 35}
    local r_spoilers_roll_max_def = {0, 35, 7, 35, 35}


    local l_spoilers_spdbrk_spd = {5, 5, 5, 5, 5}
    local r_spoilers_spdbrk_spd = {5, 5, 5, 5, 5}
    local l_spoilers_roll_spd = {0, 40, 40, 40, 40}
    local r_spoilers_roll_spd = {0, 40, 40, 40, 40}

    local l_spoilers_spdbrk_ground_spd = {15, 15, 15, 15, 15}
    local r_spoilers_spdbrk_ground_spd = {15, 15, 15, 15, 15}
    local l_spoilers_spdbrk_air_spd = {5, 5, 5, 5, 5}
    local r_spoilers_spdbrk_air_spd = {5, 5, 5, 5, 5}
    local l_spoilers_spdbrk_high_spd_air_spd = {1, 1, 1, 1, 1}
    local r_spoilers_spdbrk_high_spd_air_spd = {1, 1, 1, 1, 1}

    --targets--
    local l_spoilers_spdbrk_targets = {0, 0, 0, 0, 0}
    local r_spoilers_spdbrk_targets = {0, 0, 0, 0, 0}

    local l_spoilers_roll_targets = {0, 0, 0, 0, 0}
    local r_spoilers_roll_targets = {0, 0, 0, 0, 0}

    --SPOILERS & SPDBRAKES SPD CALCULATION------------------------------------------------------------------------
    if get(Aft_wheel_on_ground) == 1 then
        --speed up ground spoilers deflection
        l_spoilers_spdbrk_spd = l_spoilers_spdbrk_ground_spd
        r_spoilers_spdbrk_spd = r_spoilers_spdbrk_ground_spd

        --on ground and slightly open spoiler 1 with speedbrake handle
        l_spoilers_spdbrk_max_def = var_table.l_spoilers_spdbrk_max_ground_def
        r_spoilers_spdbrk_max_def = var_table.r_spoilers_spdbrk_max_ground_def
    else
        --slow down the spoilers for flight
        l_spoilers_spdbrk_spd = l_spoilers_spdbrk_air_spd
        r_spoilers_spdbrk_spd = r_spoilers_spdbrk_air_spd

        --adujust max in air deflection of the speedbrakes
        l_spoilers_spdbrk_max_def = var_table.l_spoilers_spdbrk_max_air_def
        r_spoilers_spdbrk_max_def = var_table.r_spoilers_spdbrk_max_air_def
    end

    --detect if hydraulics power is avail to the surfaces then accordingly slow down the speed
    for i = 1, var_table.num_of_spoils_per_wing do
        --speedbrkaes
        l_spoilers_spdbrk_spd[i] = Math_rescale(0, 0, 1450, l_spoilers_spdbrk_spd[i], get(l_spoilers_hyd_sys_dataref[i]))
        r_spoilers_spdbrk_spd[i] = Math_rescale(0, 0, 1450, r_spoilers_spdbrk_spd[i], get(r_spoilers_hyd_sys_dataref[i]))
        --roll spoilers
        l_spoilers_roll_spd[i] = Math_rescale(0, 0, 1450, l_spoilers_roll_spd[i], get(l_spoilers_hyd_sys_dataref[i]))
        r_spoilers_roll_spd[i] = Math_rescale(0, 0, 1450, r_spoilers_roll_spd[i], get(r_spoilers_hyd_sys_dataref[i]))
    end

    --FAILURE MANAGER--
    for i = 1, var_table.num_of_spoils_per_wing do
        l_spoilers_spdbrk_spd[i] = l_spoilers_spdbrk_spd[i] * (1 - get(l_spoilers_failure_dataref[i])) * (1 - get(r_spoilers_failure_dataref[i]))
        r_spoilers_spdbrk_spd[i] = r_spoilers_spdbrk_spd[i] * (1 - get(l_spoilers_failure_dataref[i])) * (1 - get(r_spoilers_failure_dataref[i]))
        l_spoilers_roll_spd[i] = l_spoilers_roll_spd[i] * (1 - get(l_spoilers_failure_dataref[i])) * (1 - get(r_spoilers_failure_dataref[i]))
        r_spoilers_roll_spd[i] = r_spoilers_roll_spd[i] * (1 - get(l_spoilers_failure_dataref[i])) * (1 - get(r_spoilers_failure_dataref[i]))
    end

    --SPOILERS & SPDBRAKES TARGET CALCULATION------------------------------------------------------------------------
    --DEFLECTION TARGET CALCULATION--
    for i = 1, var_table.num_of_spoils_per_wing do
        --speedbrakes
        l_spoilers_spdbrk_targets[i] = l_spoilers_spdbrk_max_def[i] * spdbrk_input
        r_spoilers_spdbrk_targets[i] = r_spoilers_spdbrk_max_def[i] * spdbrk_input
        --roll spoilers
        l_spoilers_roll_targets[i] = Math_rescale(-1, l_spoilers_roll_max_def[i], -roll_spoilers_threshold[i], 0, lateral_input)
        r_spoilers_roll_targets[i] = Math_rescale( roll_spoilers_threshold[i], 0,  1, r_spoilers_roll_max_def[i], lateral_input)
    end

    --SPEEDBRAKES INHIBITION--
    if get(Speedbrake_handle_ratio) >= 0 and get(Speedbrake_handle_ratio) <= 0.1 then
        set(Speedbrakes_inhibited, 0)
    end

    --lacking upon a.prot toga [and restoring speedbrake avail by reseting the lever position]
    if get(Bypass_speedbrakes_inhibition) ~= 1 then
        if get(SEC_1_status) == 0 and get(SEC_3_status) == 0 then
            set(Speedbrakes_inhibited, 1)
        end
        if get(L_elevator_avail) == 0 or get(R_elevator_avail) == 0 then
            set(Speedbrakes_inhibited, 1)
        end
        if get(FBW_lateral_law) == FBW_NORMAL_LAW and adirs_get_avg_aoa() > get(Aprot_AoA) - 1 then
            set(Speedbrakes_inhibited, 1)
        end
        if get(Flaps_internal_config) >= 4 then
            set(Speedbrakes_inhibited, 1)
        end
        if get(Cockpit_throttle_lever_L) >= THR_MCT_START or get(Cockpit_throttle_lever_R) >= THR_MCT_START then
            set(Speedbrakes_inhibited, 1)
        end
    end

    if get(Speedbrakes_inhibited) == 1 and get(Bypass_speedbrakes_inhibition) ~= 1 then
        l_spoilers_spdbrk_targets = {0, 0, 0, 0, 0}
        r_spoilers_spdbrk_targets = {0, 0, 0, 0, 0}
    end

    --GROUND SPOILERS MODE--
    --0 = NOT EXTENDED
    --1 = PARCIAL EXTENTION
    --2 = FULL EXTENTION
    if ground_spoilers_mode == 1 then
        l_spoilers_spdbrk_targets = {10, 10, 10, 10, 10}
        r_spoilers_spdbrk_targets = {10, 10, 10, 10, 10}
    elseif ground_spoilers_mode == 2 then
        l_spoilers_roll_targets = {0, 0, 0, 0, 0}
        r_spoilers_roll_targets = {0, 0, 0, 0, 0}
        l_spoilers_spdbrk_targets = {40, 40, 40, 40, 40}
        r_spoilers_spdbrk_targets = {40, 40, 40, 40, 40}
    end

    --if the aircraft is in roll direct law change the roll spoiler deflections to limit roll rate
    if get(FBW_lateral_law) == FBW_DIRECT_LAW and (get(L_aileron_avail) == 1 or get(R_aileron_avail) == 1) then
        if get(L_spoiler_4_avail) == 1 then
            l_spoilers_roll_targets[1] = 0
            l_spoilers_roll_targets[2] = 0
            l_spoilers_roll_targets[3] = 0
        else
            l_spoilers_roll_targets[1] = 0
            l_spoilers_roll_targets[2] = 0
            l_spoilers_roll_targets[4] = 0
        end
        if get(R_spoiler_4_avail) == 1 then
            r_spoilers_roll_targets[1] = 0
            r_spoilers_roll_targets[2] = 0
            r_spoilers_roll_targets[3] = 0
        else
            r_spoilers_roll_targets[1] = 0
            r_spoilers_roll_targets[2] = 0
            r_spoilers_roll_targets[4] = 0
        end
    end

    --SECs position reset--
    for i = 1, var_table.num_of_spoils_per_wing do
        --speedbrakes position reset
        l_spoilers_spdbrk_targets[i] = l_spoilers_spdbrk_targets[i] * get(l_spoilers_flt_computer_dataref[i])
        r_spoilers_spdbrk_targets[i] = r_spoilers_spdbrk_targets[i] * get(r_spoilers_flt_computer_dataref[i])
        --roll spoilers position reset
        l_spoilers_roll_targets[i] = l_spoilers_roll_targets[i] * get(l_spoilers_flt_computer_dataref[i])
        r_spoilers_roll_targets[i] = r_spoilers_roll_targets[i] * get(r_spoilers_flt_computer_dataref[i])
    end

    --reduce speedbrakes retraction speeds in high speed conditions
    if (adirs_get_avg_ias()>= 315 or adirs_get_avg_mach() >= 0.75) and in_auto_flight then
        --check if any spoilers are retracting and slow down accordingly
        for i = 1, var_table.num_of_spoils_per_wing do
            if l_spoilers_spdbrk_targets[i] < get(var_table.l_spoilers_datarefs[i]) then
                r_spoilers_spdbrk_spd[i] = l_spoilers_spdbrk_high_spd_air_spd[i]
            end
            if r_spoilers_spdbrk_targets[i] < get(var_table.r_spoilers_datarefs[i])then
                r_spoilers_spdbrk_spd[i] = r_spoilers_spdbrk_high_spd_air_spd[i]
            end
        end
    end

    --PRE-EXTENTION DEFECTION VALUE CALCULATION --> OUTPUT OF CALCULATED VALUE TO THE SURFACES--
    set(Speedbrakes_ratio, math.abs(lateral_input) + spdbrk_input)
    for i = 1, var_table.num_of_spoils_per_wing do
        --speedbrakes
        set(L_speed_brakes_extension, Set_anim_value_linear_range(get(L_speed_brakes_extension, i), l_spoilers_spdbrk_targets[i], 0, l_spoilers_total_max_def[i], l_spoilers_spdbrk_spd[i], 5), i)
        set(R_speed_brakes_extension, Set_anim_value_linear_range(get(R_speed_brakes_extension, i), r_spoilers_spdbrk_targets[i], 0, r_spoilers_total_max_def[i], r_spoilers_spdbrk_spd[i], 5), i)
        --roll spoilers
        set(L_roll_spoiler_extension, Set_anim_value_linear_range(get(L_roll_spoiler_extension, i), l_spoilers_roll_targets[i], 0, l_spoilers_total_max_def[i], l_spoilers_roll_spd[i], 5), i)
        set(R_roll_spoiler_extension, Set_anim_value_linear_range(get(R_roll_spoiler_extension, i), r_spoilers_roll_targets[i], 0, r_spoilers_total_max_def[i], r_spoilers_roll_spd[i], 5), i)

        --TOTAL SPOILERS OUTPUT TO THE SURFACES--
        --if any surface exceeds the max deflection limit the othere side would reduce deflection by the exceeded amount
        set(var_table.l_spoilers_datarefs[i], Math_clamp_higher(get(L_speed_brakes_extension, i) + get(L_roll_spoiler_extension, i), l_spoilers_total_max_def[i]) - Math_clamp_lower(get(R_speed_brakes_extension, i) + get(R_roll_spoiler_extension, i) - r_spoilers_total_max_def[i], 0))
        set(var_table.r_spoilers_datarefs[i], Math_clamp_higher(get(R_speed_brakes_extension, i) + get(R_roll_spoiler_extension, i), r_spoilers_total_max_def[i]) - Math_clamp_lower(get(L_speed_brakes_extension, i) + get(L_roll_spoiler_extension, i) - l_spoilers_total_max_def[i], 0))
    end
end
