local BUTTON_PRESS_TIME = 0.5
local refresh_button_begin = 0
local send_data_button_begin = 0

--column 1 displayed data
local displayed_zfw = 0
local displayed_zfwcg = 0
local displayed_block_fuel = 0

--column 2 displayed data
local displayed_v1 = 0
local displayed_vr = 0
local displayed_v2 = 0
local displayed_flaps = 0
local displayed_trim = 0
local displayed_flex = 0
local displayed_wind = 0
local displayed_tow = 0

local dropdown_expanded = {false, false, false}
local dropdown_names = {EFB_LOAD_s2_dropdown1, EFB_LOAD_s2_dropdown2, EFB_LOAD_s2_dropdown3}
local dropdown_current = {"1+F", "TOGA", "DRY"}

include("EFB/efb_topcat.lua")

local flaps_table = {"1+F", 2, 3}
---------------------------------------------------------------------------------------------------------------------------------
local function compute_flaps()
    set(LOAD_flapssetting, 1)
end

local function fetch_wind_data()
    displayed_wind = Round(get(Wind_HDG), 0).."°/"..Round(get(Wind_SPD)).."kt"
end

local function draw_background()
    sasl.gl.drawTexture (EFB_LOAD_s2_bgd, 0 , 0 , 1143 , 800 , EFB_WHITE )
end

local function draw_buttons()
    if get(TIME) -  refresh_button_begin > BUTTON_PRESS_TIME then
        SASL_drawSegmentedImg_xcenter_aligned (EFB_LOAD_compute_button, 343,215,544,32,2,1)
    else
        SASL_drawSegmentedImg_xcenter_aligned (EFB_LOAD_compute_button, 343,215,544,32,2,2)
    end
    if get(TIME) -  send_data_button_begin > BUTTON_PRESS_TIME then
        SASL_drawSegmentedImg_xcenter_aligned (EFB_LOAD_compute_button, 800,215,544,32,2,1)
    else
        SASL_drawSegmentedImg_xcenter_aligned (EFB_LOAD_compute_button, 800,215,544,32,2,2)
    end

    drawTextCentered( Font_Airbus_panel , 343 , 230, "REFRESH"    , 22 ,false , false , TEXT_ALIGN_CENTER , EFB_BACKGROUND_COLOUR )
    drawTextCentered( Font_Airbus_panel , 800 , 230, "FORWARD TO MCDU"    , 22 ,false , false , TEXT_ALIGN_CENTER , EFB_BACKGROUND_COLOUR )

end

local function draw_column_1_values()
    drawTextCentered( Font_Airbus_panel , 225 , 461, displayed_zfw      , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 225 , 435, displayed_zfwcg    , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 225 , 409, displayed_block_fuel     , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
end

local function draw_column_2_values()
    drawTextCentered( Font_Airbus_panel , 549 , 461, displayed_v1    , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 549 , 435, displayed_vr    , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 549 , 409, displayed_v2    , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 549 , 383, displayed_flaps , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 549 , 357, displayed_trim , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 549 , 331, displayed_flex , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
end

local function draw_column_3_values()
    drawTextCentered( Font_Airbus_panel , 885 , 461, displayed_wind  , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
    drawTextCentered( Font_Airbus_panel , 885 , 435, displayed_tow  , 22 ,false , false , TEXT_ALIGN_LEFT , EFB_LIGHTBLUE )
end

local function refresh_data_reminder()
    if New_takeoff_data_available then
        drawTextCentered( Font_Airbus_panel , 370 , 108, "NEW PERFORMANCE DATA AVAILABLE, PLEASE REFRESH"  , 22 ,false , false , TEXT_ALIGN_CENTER , EFB_FULL_RED )
    end
end

local function refresh_data()
    displayed_zfw = zfw_actual
    displayed_zfwcg = Round(final_cg,0)
    displayed_block_fuel = fuel_weight_actual --see variables created inside draw lop in page 3 subpage 1
    displayed_v1 = computed_v1
    displayed_vr = computed_vr
    displayed_v2 = computed_v2
    displayed_flaps = flaps_table[get(LOAD_flapssetting)]
    displayed_flex = get(LOAD_thrustto) == 0 and "NO FLEX" or flex_temp
    displayed_tow = takeoff_weight_actual

    trim_raw = Round(Table_extrapolate(pitch_trim_table, final_cg),1)
    if trim_raw > 0 then
        displayed_trim = "UP"..math.abs(trim_raw)
    else
        displayed_trim = "DN"..math.abs(trim_raw)
    end

    New_takeoff_data_available = false
end

local function draw_dropdowns()
    for i, v in ipairs(dropdown_expanded) do
        if dropdown_expanded[i] then
            sasl.gl.drawTexture (dropdown_names[i] , 0 , 0 , 1143 , 800 , EFB_WHITE )
        end
    end
end

local function draw_dropdown_selected_items()
    drawTextCentered( Font_Airbus_panel , 482 , 594, dropdown_current[1]  , 19 ,false , false , TEXT_ALIGN_CENTER , EFB_FULL_GREEN )
    drawTextCentered( Font_Airbus_panel , 727 , 594, dropdown_current[2]  , 19 ,false , false , TEXT_ALIGN_CENTER , EFB_FULL_GREEN )
    drawTextCentered( Font_Airbus_panel , 960 , 594, dropdown_current[3]  , 19 ,false , false , TEXT_ALIGN_CENTER , EFB_FULL_GREEN )
end

local function close_menu_1()
    dropdown_expanded[1] = false
end
local function close_menu_2()
    dropdown_expanded[2] = false
end
local function close_menu_3()
    dropdown_expanded[3] = false
end

--MOUSE & BUTTONS--
function p3s2_buttons()
    Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 206, 215, 480, 247,function () --refresh
        refresh_button_begin = get(TIME)
        constant_conversions()
        v2_calculation()
        flex_calculation()
        other_spd_calculation()
        fetch_wind_data()
        -----------------------------------put this at the bottom
        refresh_data()
    end)
    Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 663, 215, 936, 247,function () --SEND TO MCDU
        send_data_button_begin = get(TIME)
    end)
    Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 401, 580, 588, 609,function () --DROPDOWN 1 EXPAND
        dropdown_expanded[1] = not dropdown_expanded[1]
    end)
    Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 644, 580, 830, 609,function () --DROPDOWN 2 EXPAND
        dropdown_expanded[2] = not dropdown_expanded[2]
    end)
    Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 877, 580, 1062, 609,function () --DROPDOWN 3 EXPAND
        dropdown_expanded[3] = not dropdown_expanded[3]
    end)


    if dropdown_expanded[1] then
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 403, 553, 560, 580,function () --DROPDOWN 3 EXPAND
            dropdown_current[1] = "1+F"
            set(LOAD_flapssetting, 1)
            close_menu_1()
        end)
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 403, 529, 560, 553,function () --DROPDOWN 3 EXPAND
            dropdown_current[1] = "2"
            set(LOAD_flapssetting, 2)
            close_menu_1()
        end)
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 403, 501, 560, 529,function () --DROPDOWN 3 EXPAND
            dropdown_current[1] = "3"
            set(LOAD_flapssetting, 3)
            close_menu_1()
        end)
        click_anywhere_except_that_area( 401, 501, 559, 608, close_menu_1)

    elseif dropdown_expanded[2] then
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 645, 556, 802, 580,function () --DROPDOWN 3 EXPAND
            dropdown_current[2] = "TOGA"
            set(LOAD_thrustto, 0)
            close_menu_2()
        end)
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 645, 529, 802, 556,function () --DROPDOWN 3 EXPAND
            dropdown_current[2] = "FLEX"
            set(LOAD_thrustto, 1)
            close_menu_2()
        end)
        click_anywhere_except_that_area( 645, 501, 802, 608, close_menu_2)

    elseif dropdown_expanded[3] then
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 878, 556, 1034, 580,function () --DROPDOWN 3 EXPAND
            dropdown_current[3] = "DRY"
            set(LOAD_runwaycond, 0)
            close_menu_3()
        end)
        Button_check_and_action(EFB_CURSOR_X, EFB_CURSOR_Y, 878, 529, 1034, 556,function () --DROPDOWN 3 EXPAND
            dropdown_current[3] = "WET"
            set(LOAD_runwaycond, 1)
            close_menu_3()
        end)
        click_anywhere_except_that_area( 877, 501, 1035, 608, close_menu_3)
    end
end

--UPDATE LOOPS--
function p3s2_update()
end

--DRAW LOOPS--
function p3s2_draw()
    draw_background()
    draw_buttons()
    draw_column_1_values()
    draw_column_2_values()
    draw_column_3_values()
    refresh_data_reminder()
    draw_dropdowns()
    draw_dropdown_selected_items()
end

--DO AT THE BEGINNING
