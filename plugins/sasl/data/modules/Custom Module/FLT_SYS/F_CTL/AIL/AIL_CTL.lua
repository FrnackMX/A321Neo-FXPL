local function AIL_CTL(lateral_input)
    --surface range -25 up +25 down, 10 degrees droop with flaps(calculated by ELAC 1/2)
    local MAX_DEF = 25

    --AIL_Droop (2deg/s counting frames)--
    if get(Flaps_deployed_angle) > 0 then
        set(AIL_Droop, Set_linear_anim_value(get(AIL_Droop), 10, 0, 10, 2))
    else
        set(AIL_Droop, Set_linear_anim_value(get(AIL_Droop), 0, 0, 10, 2))
    end

    --properties
    local L_AIL_DEF_TBL = {
        {-1, -MAX_DEF + get(AIL_Droop)},
        {0,             get(AIL_Droop)},
        {1,   MAX_DEF + get(AIL_Droop)},
    }
    local R_AIL_DEF_TBL = {
        {-1,  MAX_DEF + get(AIL_Droop)},
        {0,             get(AIL_Droop)},
        {1,  -MAX_DEF + get(AIL_Droop)},
    }

    local L_AIL_TGT = Math_clamp(Table_interpolate(L_AIL_DEF_TBL, lateral_input), -MAX_DEF, MAX_DEF)
    local R_AIL_TGT = Math_clamp(Table_interpolate(R_AIL_DEF_TBL, lateral_input), -MAX_DEF, MAX_DEF)

    --ADD MLA & GLA--
    if FCTL.AIL.STAT.L.controlled and FCTL.AIL.STAT.R.controlled then
        L_AIL_TGT = Math_clamp_lower(L_AIL_TGT - get(FBW_MLA_output), -MAX_DEF)
        R_AIL_TGT = Math_clamp_lower(R_AIL_TGT - get(FBW_MLA_output), -MAX_DEF)
        L_AIL_TGT = Math_clamp_lower(L_AIL_TGT - get(FBW_GLA_output), -MAX_DEF)
        R_AIL_TGT = Math_clamp_lower(R_AIL_TGT - get(FBW_GLA_output), -MAX_DEF)
    end

    --TRAVEL TARGETS CALTULATION--
    --aileron anti droop
    if get(Ground_spoilers_mode) == 2 and
       get(FBW_total_control_law) == FBW_NORMAL_LAW and
       get(Flaps_internal_config) > 1 and
       adirs_get_avg_pitch() < 2.5 then
        L_AIL_TGT = -MAX_DEF
        R_AIL_TGT = -MAX_DEF
    end

    --output to the surfaces
    FCTL.AIL.ACT(L_AIL_TGT, 1)
    FCTL.AIL.ACT(R_AIL_TGT, 2)
end

function update()
    AIL_CTL(get(FBW_roll_output))
end