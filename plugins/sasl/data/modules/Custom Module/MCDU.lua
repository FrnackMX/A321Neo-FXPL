-------------------------------------------------------------------------------
-- A32NX Freeware Project
-- Copyright (C) 2020
-------------------------------------------------------------------------------
-- LICENSE: GNU General Public License v3.0
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Please check the LICENSE file in the root of the repository for further
--    details or check <https://www.gnu.org/licenses/>
-------------------------------------------------------------------------------
-- File: MCDU.lua 
-- Short description: A32NX MCDU
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Table of contents for the A32NX MCDU
--
--
-- CONSTS DECLARATION
-- MCDU DATA INITIALIZATION
-- DATA & COMMAND REGISTRATION
-- MCDU - FORMATTING
-- MCDU PAGE SIMULATION
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- EMULATOR SHELL CODE (I of II)
—- NOTICE: emulator is deprecated

--    Simulates SASL running on a lua intrepreter (or https://repl.it)
--    instead of booting up X-Plane everytime you want to run this.
--    
--    Notes
--    - This code is continued also at the bottom of this file.
--    - Uses Linux OS-based system calls
--    - Very smelly code, can fail at any time!

EMULATOR = false -- SET THIS TO ENABLE/DISABLE THE EMULATOR!!!

EMULATOR_PROMPT_BEFORE_RUN = false -- Wait after initialization?

if EMULATOR then
	EMULATOR_HEADER = "\27[101;93mSASL EMULATOR\27[0m: "
	os.execute("clear")
	
	-- MCDU popup
	function MCDU_set_popup(str1, str2)
	end

	-- SASL Class
	EmulatorSasl = {gl = nil}
	commands = {}
	SASL_COMMAND_BEGIN = "begin"

	function EmulatorSasl:new (o)
		o = o or {}   -- create object if user does not provide one
		setmetatable(o, self)
		self.__index = self
		return o
	end

	function EmulatorSasl:test()
		print(EMULATOR_HEADER .. "Test OK")
	end

	function EmulatorSasl.createCommand(str, str2)
		print(EMULATOR_HEADER .. "Create command " .. str)
	end

	function EmulatorSasl.registerCommandHandler(str, int, ref)
		if not str then
			print(EMULATOR_HEADER .. "passed NIL for sasl.registerCommandHandler")
			return
		end
		print(EMULATOR_HEADER .. "Register command " .. str)
		for i = 1, #commands, 1 do
			if commands[i].name == str then
				commands[i].ref = ref
				print("found.")
			end
		end	
	end

	function EmulatorSasl.commandOnce(str)
		print(EMULATOR_HEADER .. "Command " .. str)
	end

	function EmulatorSasl:findNavAid(name, a, b, c, d, find_type)
		return 1
	end

	function EmulatorSasl:getNavAidInfo(id)
		return NAV_AIRPORT, 121, 141, 300, 110.500, 70, "id", "name", true
	end

	-- SASL OpenGL Class
	EmulatorGL = {}

	function EmulatorGL:new (o)
		o = o or {}   -- create object if user does not provide one
		setmetatable(o, self)
		self.__index = self
		return o
	end

	function EmulatorGL.loadFont(str)
		print(EMULATOR_HEADER .. "Load font " .. str)
	end

	function EmulatorGL.drawText(font, x, y, str, size, bool1, bool2, align, color)
	end

	-- SASL Global Functions
	function include(str)
		print(EMULATOR_HEADER .. "Include file " .. str)
	end

	function createGlobalPropertyi(str)
		print(EMULATOR_HEADER .. "Create global property (int) " .. str)
	end

	function globalPropertyi(str)
		print(EMULATOR_HEADER .. "Referencing global property (int) " .. str)
        return str
	end

	function createGlobalPropertys(str)
		print(EMULATOR_HEADER .. "Create global property (string) " .. str)
	end

	function createCommand(str)
		if not str then
			print(EMULATOR_HEADER .. "passed NIL for createCommand")
			return
		end
		print(EMULATOR_HEADER .. "Create global command " .. str)
		table.insert(commands, {name = str})
		return str
	end

	function globalPropertys(str)
		return str
	end

	function findCommand(str)
		print(EMULATOR_HEADER .. "Find command " .. str)
		return str
	end

	-- profiler
	function perf_measure_start(str)
	end
	function perf_measure_stop(str)
	end

	-- brightness
	function Draw_LCD_backlight(a,b,c,d,e,f)
	end

	-- get set
	variables = {}
	function get(str)
		return variables[str] 
	end

	function set(str, val)
		variables[str] = val
	end

	-- elecs
	EmulatorELEC = {}

	function EmulatorELEC:new (o)
		o = o or {}   -- create object if user does not provide one
		setmetatable(o, self)
		self.__index = self
		return o
	end

	function EmulatorELEC.add_power_consumption(a,b,c)
	end

	ELEC_sys = EmulatorELEC
	sasl = EmulatorSasl:new()
	sasl.gl = EmulatorGL:new()
	sasl.test()

	ECAM_WHITE = {1.0, 1.0, 1.0}
	ECAM_LINE_GREY = {62/255, 74/255, 91/255}
	ECAM_HIGH_GREY = {0.6, 0.6, 0.6}
	ECAM_BLUE = {0.004, 1.0, 1.0}
	ECAM_GREEN = {0.20, 0.98, 0.20}
	ECAM_HIGH_GREEN = {0.1, 0.6, 0.1}
	ECAM_ORANGE = {1, 0.66, 0.16}
	ECAM_RED = {1.0, 0.0, 0.0}
	ECAM_MAGENTA = {1.0, 0.0, 1.0}
	ECAM_GREY = {0.3, 0.3, 0.3}
	ECAM_BLACK = {0, 0, 0}

	NAV_UNKNOWN = -1
	NAV_AIRPORT = 0
	NAV_NDB = 1
	NAV_VOR = 2
	NAV_ILS = 3
	NAV_LOCALIZER = 4
	NAV_GLIDESLOPE = 5
	NAV_OUTERMARKER = 6
	NAV_MIDDLEMARKER = 7
	NAV_INNERMARKER = 8
	NAV_FIX = 9
	NAV_DME = 10

end
-- END OF EMULATOR SHELL CODE I OF II (CONTINUED AT END OF SCRIPT)
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------



-- START OF MCDU CODE
-- START OF MCDU CODE
-- START OF MCDU CODE

--[[
--
--
--      CONSTS DECLARATION
--
--
--]]

position = {1020, 1666, 560, 530}
size = {560, 530}

include('FMGS.lua') -- Flight Management Guidance System implementation

local NIL = 0 -- used for input return and checking

--define the const size, align and row.
local MCDU_DIV_SIZE = {"s", "l"}
local MCDU_DIV_ALIGN = {"L", "R"}
local MCDU_DIV_ROW = {1,2,3,4,5,6}

--line spacing
local MCDU_DRAW_OFFSET = {x = 15, y = 420} -- starting offset for line drawing
local MCDU_DRAW_SPACING = {x = 530, y = -37} -- change in offset per line drawn

--reference table for drawing
local MCDU_DISP_COLOR = 
{
    ["white"] =   {1.00, 1.00, 1.00},
    ["cyan"] =    {0.10, 0.70, 1.00},
    ["green"] =   {0.20, 1.00, 0.20},
    ["amber"] =   {1.00, 0.66, 0.16},
    ["yellow"] =  {1.00, 0.76, 0.16},
    ["magenta"] = {1.00, 0.00, 1.00},
    ["red"] =     {1.00, 0.00, 0.00},

    ["black"] =   ECAM_BLACK,
}

--font size
local MCDU_DISP_TEXT_SIZE =
{
    ["s"] = 25,
    ["l"] = 37
}

--alignment
local MCDU_DISP_TEXT_ALIGN =
{
    ["L"] = TEXT_ALIGN_LEFT,
    ["R"] = TEXT_ALIGN_RIGHT,
}

-- alphanumeric & decimal FMC entry keys
local MCDU_ENTRY_KEYS = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "overfly", "slash", "space"}
local MCDU_ENTRY_PAGES = {"dir", "prog", "perf", "init", "data", "f-pln", "rad_nav", "fuel_pred", "sec_f-pln", "atc_comm", "mcdu_menu", "air_port"}
local MCDU_ENTRY_SIDES = {"L1", "L2", "L3", "L4", "L5", "L6", "R1", "R2", "R3", "R4", "R5", "R6", "slew_up", "slew_down", "slew_left", "slew_right"}

local CIFP_PATH = sasl.getXPlanePath() .. "Resources/default data/CIFP/"
local APT_PATH = sasl.getXPlanePath() .. "Resources/default scenery/default apt dat/Earth nav data/apt.dat"



--[[
--
--
--      MCDU DATA INITIALIZATION
--
--
--]]

local mcdu_dat = {}
local mcdu_dat_title = {}

for i,size in ipairs(MCDU_DIV_SIZE) do
	mcdu_dat[size] = {}
	for j,align in ipairs(MCDU_DIV_ALIGN) do
		mcdu_dat[size][align] = {}
	end
end

--entry line
local mcdu_entry = ""
local mcdu_entry_cache = "" --caches entry for when messages are shown
local mcdu_messages = {}
local mcdu_message_showing = false

--mcdu page call functions
local mcdu_sim_page = {}

--create LUT for apt.dat for faster reference
if not override_MCDU_dontcreateairportlut then
    parser_apt = Parser_Apt:new(APT_PATH)
    parser_apt:create_airport_lut()
end

--define custom functionalities
local function mcdu_send_message(message)
    table.insert(mcdu_messages, message)
end

local function mcdu_eval_entry(str, format)
    pass = true
    if #str ~= #format then
        pass = false
    end
    for i = 1,#format do
        if string.sub(format, i, i) == "!" then
            -- digit
            if string.find(string.sub(str, i, i), "%d") == nil then
                pass = false
            end
        elseif string.sub(format, i, i) == "@" then
            -- letter
            if string.find(string.sub(str, i, i), "%a") == nil then
                pass = false
            end
        elseif string.sub(format, i, i) == "#" then
            -- do nothing
        else
            if string.sub(str, i, i) ~= string.upper(string.sub(format, i, i)) then 
                pass = false
            end
        end
    end
    return pass
end

local function mcdu_eval_entries(entry, expected_formats)
    --[[
    -- expected_format
    --
    -- can accept multiple inputs ! for digits, @ for letters, # for anything
    -- https://www.lua.org/pil/20.2.html
    --]]
    
    if expected_formats == nil then
        return entry
    end

    if expected_formats[1] ~= nil then
        local pass = false
        for i,format in ipairs(expected_formats) do-- expected_formats is a table
            if mcdu_eval_entry(entry, format) then
                return entry
            end
        end
		return NIL
    else
        if mcdu_eval_entry(entry, expected_formats) then
            return entry
        else
            return NIL
        end
    end
end

local function mcdu_parse_entry(entry, expected_format)

	format_type = expected_format[1]
	if format_type == "altitude" then
		format_type = "number"
		expected_format = {"number", length = 3, dp = 0}
		if string.sub(entry, 1, 2) == "FL" then
			entry = string.sub(entry, 3, -1) -- get rid of FL
		end
	end
	if format_type == "heading" then
		format_type = "number"
		expected_format = {"number", length = 3, dp = 0}
	end
	if format_type == "number" then
		code = "!"
	elseif format_type == "word" then
		code = "#"
	end

	possible_inputs_a = {code}

    -- if dp isn't specified
    if not expected_format.dp then
        expected_format.dp = 0
    end

	-- add decimal places
	s = code .. "."
	for i = 1, expected_format.dp, 1 do
		s = s .. code
		table.insert(possible_inputs_a, s)
	end

	possible_inputs_b = {}

	-- add whole number places
	for _, j in ipairs(possible_inputs_a) do
		s = ""
		for i = 1, expected_format.length, 1 do
			table.insert(possible_inputs_b, s .. j)

			s = code .. s
		end
	end

	possible_inputs_c = {}
	for _, i in ipairs(possible_inputs_b) do
		table.insert(possible_inputs_c, i)
		table.insert(possible_inputs_c, "+" .. i)
		table.insert(possible_inputs_c, "-" .. i)
	end

	output = mcdu_eval_entries(entry, possible_inputs_c)
	if output == NIL then
		return "$invalid"
	end
	return output
end

-- the simpler way of getting mcdu entries
local function mcdu_get_entry_simple(expected_formats)
    output = mcdu_eval_entries(mcdu_entry, expected_formats)
    if output == NIL then
        mcdu_send_message("format error")
        return NIL
    else
        mcdu_entry = ""
        return output
    end
end


-- accepts mcdu entries by a specific format (list of formats)
-- e.g. mcdu_get_entry({"altitude"}, {"number", length = 2, dp = 0})
-- accepts in an altitude format, with a slash and a number.
-- so 300/20 is allowed
-- and /-20 is allowed (returns nil, -20)
-- and 300 is allowed (returns 300, nil)
local function mcdu_get_entry(format_a, format_b, dont_reset_entry)
	a = NIL
	b = NIL
	if format_b then
		-- e.g. /20
		if string.sub(mcdu_entry, 1, 1) == "/" then
			b = mcdu_parse_entry(string.sub(mcdu_entry, 2, -1), format_b)
		else
			i = 1
			while string.sub(mcdu_entry, i, i) ~= "/" and i < #mcdu_entry do
				i = i + 1
			end
			-- e.g. 200
			if i == #mcdu_entry then
				a = mcdu_parse_entry(mcdu_entry, format_a)
			-- e.g. 200/20
			else
				a = mcdu_parse_entry(string.sub(mcdu_entry, 1, i-1), format_a)
				b = mcdu_parse_entry(string.sub(mcdu_entry, i+1, -1), format_b)
			end
		end
	else
        if format_a then
            a = mcdu_parse_entry(mcdu_entry, format_a)
        else
            a = mcdu_entry
        end
	end

	if a == "$invalid" or b == "$invalid" then
        mcdu_send_message("format error")
        if format_b then
            return NIL, NIL
        end
		return NIL
	end

    if not dont_reset_entry then
    	mcdu_entry = ""
    end
    if format_b then
        return a, b
    else
        return a
    end

end

--clear MCDU
local function mcdu_clearall()
    mcdu_dat_title = {txt = "", col = "white", size = nil}
    for i,size in ipairs(MCDU_DIV_SIZE) do
        for j,align in ipairs(MCDU_DIV_ALIGN) do
            for k,row in ipairs(MCDU_DIV_ROW) do
                --mcdu_dat[size][align][row] = {txt = size .. "" .. align .. " " .. row, col = "white"}
                mcdu_dat[size][align][row] = {txt = nil, col = "white", size = nil}
            end
        end
    end
end

--load MCDU page
local function mcdu_open_page(id)
    mcdu_clearall()
    set(mcdu_page, id)
    mcdu_sim_page[get(mcdu_page)]("render")
end


sasl.registerCommandHandler (MCDU_refresh_page, 0, function(phase) if phase == SASL_COMMAND_BEGIN then mcdu_clearall(); mcdu_sim_page[get(mcdu_page)]("render") end end)


--[[
--
--
--      DATA & COMMAND REGISTERATION
--
--
--]]

local mcdu_debug_busy = createGlobalPropertyi("a321neo/debug/mcdu/mcdu_bug_busy")

local mcdu_irs_aligned = createGlobalPropertyi("a321neo/cockpit/mcdu/mcdu_irs_aligned", 1)

local gps_lat = globalPropertyf("sim/flightmodel/position/latitude")
local gps_lon = globalPropertyf("sim/flightmodel/position/longitude")

--mcdu entry inputs
local mcdu_inp = {}

local entry_cooldown = 0
local hokey_pokey = false --wonder what this does

local MCDU_ENTRY = 
{
    {
        ref_name = "key",               --the group of the command
        ref_desc = "Key",               --the description of the command
        ref_entries = MCDU_ENTRY_KEYS,  --the group of keys
        ref_callback =                  --what they should do
        function (count, val)

            if val == "overfly" then
                val = "Δ"
            elseif val == "slash" then
                val = "/"
            elseif val == "space" then
                val = " "
            end

            if get(TIME) - entry_cooldown > get(DELTA_TIME) then
                entry_cooldown = get(TIME)
                if #mcdu_entry < 22 then
                    mcdu_entry = mcdu_entry .. val
                end
            end
        end
    },
    {
        ref_name = "page",
        ref_desc = "Page",
        ref_entries = MCDU_ENTRY_PAGES,
        ref_callback = 
        function (count, val)
            mcdu_open_page(count * 100)
        end
    },
    {
        ref_name = "side",
        ref_desc = "Side key",
        ref_entries = MCDU_ENTRY_SIDES,
        ref_callback = 
        function (count, val)
            mcdu_sim_page[get(mcdu_page)](val)
        end
    },
    {
        ref_name = "misc",
        ref_desc = "Clear key",
        ref_entries = {"clr"},
        ref_callback = 
        function (count, val)
            if mcdu_message_showing then
                mcdu_entry = mcdu_entry_cache
                mcdu_message_showing = false
            else
                if #mcdu_entry > 0 then
                    mcdu_entry = mcdu_entry:sub(1,#mcdu_entry - 1) 
                else
                    if #mcdu_entry == 0 then
                        mcdu_entry = "CLR"
                        mcdu_message_showing = true
                    end
                end
            end
        end
    },
    {
        ref_name = "misc",
        ref_desc = "positive_negative",
        ref_entries = {"positive_negative"},
        ref_callback = 
        function (count, val)
            if #mcdu_entry < 22 then
                if string.sub(mcdu_entry, #mcdu_entry, #mcdu_entry) == "-" then
                    mcdu_entry = string.sub(mcdu_entry, 0, #mcdu_entry - 1) .. "+"
                elseif string.sub(mcdu_entry, #mcdu_entry, #mcdu_entry) == "+" then
                    mcdu_entry = string.sub(mcdu_entry, 0, #mcdu_entry - 1) .. "-"
                elseif string.sub(mcdu_entry, #mcdu_entry, #mcdu_entry) ~= "+" and string.sub(mcdu_entry, #mcdu_entry, #mcdu_entry) ~= "-" then
                    mcdu_entry = mcdu_entry .. "-"
                end
            end
        end
    }
}

--register all entry keys
for i,entry_category in ipairs(MCDU_ENTRY) do
    for count,entry in ipairs(entry_category.ref_entries) do
        mcdu_inp[entry] = createCommand("a321neo/cockpit/mcdu/" .. entry_category.ref_name .. "/" .. entry, "MCDU " .. entry .. " " .. entry_category.ref_desc)
        sasl.registerCommandHandler(mcdu_inp[entry], 0, function (phase)
            if phase == SASL_COMMAND_BEGIN then
                if get(Mcdu_enabled) == 1 then
                    entry_category.ref_callback(count, entry)
                end
            end
        end)
    end
end



--[[
--
--
--      MCDU DRAWING
--
--
--]]

local draw_lines = {}
local draw_lines_itr = 0

local function draw_dat(dat, draw_size, disp_x, disp_y, disp_text_align)
    if dat.txt == nil then
        return
    end
    disp_text = tostring(dat.txt):upper()
    dat.col = dat.col or "white" --default colour
    disp_color = MCDU_DISP_COLOR[dat.col]

    -- is there a custom size
    if dat.size == nil then
        disp_size = draw_size
    else
        disp_size = dat.size
    end

    -- text size 
    disp_text_size = MCDU_DISP_TEXT_SIZE[disp_size]

    -- replace { with the box
    text = ""
    for j = 1,#disp_text do
        if disp_text:sub(j,j) == "{" then
            if EMULATOR then
                text = text .. "b"
            else
                text = text .. "□"
            end
        else
            text = text .. disp_text:sub(j,j)
        end
    end
    disp_text = text

    -- now draw it!
    table.insert(draw_lines, {font = disp_size, disp_x = disp_x, disp_y = disp_y, disp_text = disp_text, disp_text_size = disp_text_size, disp_text_align = disp_text_align, disp_color = disp_color})
end

local function draw_get_x(align)
    return MCDU_DRAW_OFFSET.x + (MCDU_DRAW_SPACING.x * (align - 1))
end

local function draw_get_y(line)
    return MCDU_DRAW_OFFSET.y + (MCDU_DRAW_SPACING.y * (line - 1))
end

local function draw_update()
    -- clear all line which need to be drawn
    draw_lines = {}
    draw_lines_itr = 0

    for i,draw_row in ipairs(MCDU_DIV_ROW) do
        for j,draw_size in ipairs(MCDU_DIV_SIZE) do
            draw_act_row = ((i - 1) * 2) + (j - 1) -- draw actual row

            for k,draw_align in ipairs(MCDU_DIV_ALIGN) do

                -- spacings
                disp_x = draw_get_x(k)
                disp_y = draw_get_y(draw_act_row)

                -- text alignment
                disp_text_align = MCDU_DISP_TEXT_ALIGN[draw_align]

                -- text data
                dat_full = mcdu_dat[draw_size][draw_align][draw_row]
                if dat_full[1] == nil then
                    draw_dat(dat_full, draw_size, disp_x, disp_y, disp_text_align)
                else
                    for l,dat in pairs(dat_full) do
                        draw_dat(dat, draw_size, disp_x, disp_y, disp_text_align)
                    end
                end
            end
        end
    end

    --draw title line
    if mcdu_dat_title[1] == nil then
        draw_dat(mcdu_dat_title, "l", draw_get_x(1), draw_get_y(-1), MCDU_DISP_TEXT_ALIGN["L"])
    else
        for l,dat in pairs(mcdu_dat_title) do
            draw_dat(dat, "l", draw_get_x(1), draw_get_y(-1), MCDU_DISP_TEXT_ALIGN["L"])
        end
    end
end

local function colorize()
    for i,f in ipairs({"white", "cyan", "amber", "green", "yellow", "magenta", "red"}) do
        c = {}
        c[0] = MCDU_DISP_COLOR[f][1];c[1] = MCDU_DISP_COLOR[f][2];c[2] = MCDU_DISP_COLOR[f][3]
        inc = 0.1
        if c[0] < 1 and c[1] == 0 and c[2] == 0 then
            c[0] = c[0] + inc
        elseif c[0] == 1 and c[1] < 1 and c[2] == 0 then
            c[1] = c[1] + inc
        elseif c[0] <= 1 and c[0] > 0 and c[1] == 1 and c[2] == 0 then
            c[0] = c[0] - inc
        elseif c[0] == 0 and c[1] == 1 and c[2] < 1 then
            c[2] = c[2] + inc
        elseif c[0] == 0 and c[1] <= 1 and c[1] > 0 and c[2] == 1 then
            c[1] = c[1] - inc
        elseif c[0] < 1 and c[1] == 0 and c[2] == 1 then
            c[0] = c[0] + inc
        elseif c[0] == 1 and c[1] == 0 and c[2] <= 1 and c[2] > 0 then
            c[2] = c[2] - inc
        end
        MCDU_DISP_COLOR[f][1] = math.min(math.max(c[0], 0), 1); MCDU_DISP_COLOR[f][2] = math.min(math.max(c[1], 0), 1); MCDU_DISP_COLOR[f][3] = math.min(math.max(c[2], 0), 1)
    end
    draw_update()
end

--drawing the MCDU display
function draw()
	perf_measure_start("MCDU:draw()")
    --DEBUG TODO: commented out four lines because of debugging and the time it takes for it to load.
    --[[
    if get(AC_ess_bus_pwrd) == 0 then   -- TODO MCDU2 is on AC2
        return -- Bus is not powered on, this component cannot work
    end
    ELEC_sys.add_power_consumption(ELEC_BUS_AC_ESS, 0.26, 0.26)   -- 30W (just hypothesis)
    --]]

    --sasl.gl.drawRectangle(0, 0, 560, 530, {1,0,0})
    if hokey_pokey then
        colorize()
    end
    if get(Mcdu_enabled) == 1 then
        MCDU_set_popup("draw lines", draw_lines)
        MCDU_set_popup("mcdu entry", mcdu_entry)
        MCDU_set_popup("enabled", true)

        --draw backlight--
        Draw_LCD_backlight(0, 0, size[1], size[2], 0.5, 1, get(MCDU_1_brightness_act))

        --draw all horizontal lines
        for i,line in ipairs(draw_lines) do
            if line.font == "l" then
                font = Font_AirbusDUL
            else
                font = Font_AirbusDUL_small
            end
            sasl.gl.drawText(font, line.disp_x, line.disp_y, line.disp_text, line.disp_text_size, false, false, line.disp_text_align, line.disp_color)
        end

        --draw scratchpad
        sasl.gl.drawText(Font_AirbusDUL, draw_get_x(1), draw_get_y(12), mcdu_entry, MCDU_DISP_TEXT_SIZE["l"], false, false, MCDU_DISP_TEXT_ALIGN["L"], MCDU_DISP_COLOR["white"])

    end
	perf_measure_stop("MCDU:draw()")
end



--[[
--
--
--      MCDU - FORMATTING
--
--
--]]

--pad a number up to a given dp
--e.g. (2.4, 3) -> 2.400
local function mcdu_pad_dp(number, required_dp)
    return(string.format("%." .. required_dp .. "f", number))
end

--pad a number up to a given length
--e.g. (50, 3) -> 050
local function mcdu_pad_num(number, required_length)
    str = tostring(number)
    while #str < required_length do
        str = "0" .. str
    end
    return str
end

--toggle obj between two strings, a and b
--e.g. ("ad", "ba", "ad") -> "ba"
local function mcdu_toggle(obj, str_a, str_b)
    if obj == str_a then
        return str_b
    elseif obj == str_b then
        return str_a
    end
end

-- converts Decimal Degrees and Axis (lat/lon) to Degrees Minute Seconds Direction
local function mcdu_ctrl_dd_to_dmsd(dd, axis)
    if axis == "lat" then
        if dd > 0 then
            p = "N"
        else
            p = "S"
        end
    else
        if dd > 0 then
            p = "E"
        else
            p = "W"
        end
    end

    dd = math.abs(dd)
    d = dd
    m = d % 1 * 60
    s = m % 1 * 60
    d = math.floor(d)
    -- if axis is longitude
    if axis ~= "lat" then
        d = mcdu_pad_num(d, 3)
    end
    return d, m, s, p
end

-- converts Degrees Minute Seconds Direction to Decimal Degrees
local function mcdu_ctrl_dmsd_to_dd(d,m,s,dir)
    if dir == "E" or dir == "N" then
        p = 1
    else
        p = -1
    end
    dd = (d + m*(1/60) + s*(1/3600)) * p
    return dd
end



--[[
--
--
--      MCDU PAGE SIMULATION
--
--      loosely based on
--      http://www.a320dp.com/A320_DP/nav-flight-management/sys-14.0.0.html
--      
--      WARNING - the website has an outdated MCDU, consult ToLiss for actual data
--      14.7.5 would be (0705 - 200) so 0505 so 505
--
--      0 - nothing
--      100 - dir
--      200 - prog
--      300 - perf
--        301 - perf take off
--      400 - init
--        401 - init routes
--        402 - init irs init
--        403 - init climb wind
--      500 - data
--        501 - data position monitor
--        502 - data irs monitor
--        503 - data gps monitor
--        504 - RESERVED
--        505 - data A/C status
--        506 - data irs monitor irs
--      600 - f-pln
--        601 - f-pln lat rev
--        602 - f-pln lat rev dept airport
--        603 - f-pln lat rev dest airport
--      700 - rad nav
--      800 - fuel pred
--      900 - sec f-pln
--      1000 - atc comm
--      1100 - mcdu menu
--      1200 - air port
--      1300 - CFDS menu (maintenance)
--
--
--]]

mcdu_entry = string.upper("")

--update
function update()
	perf_measure_start("MCDU:update()")
    if get(mcdu_page) == 0 then --on start
       mcdu_open_page(505) --open 505 A/C status
       --mcdu_open_page(1106) --open 1106 mcdu menu options debug
	   --mcdu_open_page(400)
    end

    -- display next message
    if #mcdu_messages > 0 and not mcdu_message_showing then
        mcdu_entry_cache = mcdu_entry
        mcdu_entry = mcdu_messages[#mcdu_messages]:upper()
        mcdu_message_showing = true
        table.remove(mcdu_messages)
    end
  	perf_measure_stop("MCDU:update()")
end

-- MCDU PAGES

-- 00 template
mcdu_sim_page[00] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          a321-521nx"

        --[[
        mcdu_dat["s"]["L"][1].txt = "□"
        mcdu_dat["l"]["L"][1][1] = {txt = " a", col = "green"}
        mcdu_dat["l"]["L"][1][1] = {txt = "  a", col = "cyan", size = "s"}
        --]]

        draw_update()
    end
end

-- 100 dir
mcdu_sim_page[100] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          dir"

        mcdu_dat["l"]["L"][1].txt = "not yet implemented"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 200 prog
mcdu_sim_page[200] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          prog"

        mcdu_dat["l"]["L"][1].txt = "not yet implemented"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 300 perf
mcdu_sim_page[300] =
function (phase)
    if phase == "render" then
        fmgs_dat_init("perf phase", 1)
        fmgs_dat_init("perf page", 0)
        if fmgs_dat["perf page"] == 0 then
            fmgs_dat["perf page"] = fmgs_dat["perf phase"]
        end
        if fmgs_dat["perf page"] == 1 then
            mcdu_open_page(301) -- open 301 perf take off
        elseif fmgs_dat["perf page"] == 2 then
            mcdu_open_page(302) -- open 302 perf clb
        elseif fmgs_dat["perf page"] == 3 then
            mcdu_open_page(303) -- open 303 perf crz
        elseif fmgs_dat["perf page"] == 4 then
            mcdu_open_page(304) -- open 304 perf des
        elseif fmgs_dat["perf page"] == 5 then
            mcdu_open_page(305) -- open 305 perf appr
        elseif fmgs_dat["perf page"] == 6 then
            mcdu_open_page(306) -- open 306 perf go around
        end
    end
end

-- 301 perf take off
mcdu_sim_page[301] =
function (phase)
    if phase == "render" then
        if fmgs_dat["perf phase"] == 1 then
            mcdu_dat_title[1] = {txt = "    take off rwy", col = "white"}
            mcdu_dat_title[2] = {txt = "                 33r", col = "green"}
        else
            mcdu_dat_title = {txt = "       take off", col = "white"}
        end

        fmgs_dat_init("perf take off fspd", 0) 
        fmgs_dat_init("perf take off sspd", 0) 
        fmgs_dat_init("perf take off ospd", 0) 

        mcdu_dat["s"]["L"][1].txt = " v1  flp retr"
        mcdu_dat["l"]["L"][1][1] = fmgs_dat_get("perf v1", "{{{", "amber", "cyan")
        mcdu_dat["l"]["L"][1][2] = {txt = "       f="}
        if fmgs_dat["perf take off fspd"] == 0 then
            mcdu_dat["l"]["L"][1][3] = {txt = "         ---"}
        else
            mcdu_dat["l"]["L"][1][3] = {txt = "         " .. fmgs_dat["perf take off fspd"], col = "green"}
        end

        mcdu_dat["s"]["L"][2].txt = " vr  slt retr"
        mcdu_dat["l"]["L"][2][1] = fmgs_dat_get("perf vr", "{{{", "amber", "cyan")
        mcdu_dat["l"]["L"][2][2] = {txt = "       s="}
        if fmgs_dat["perf take off sspd"] == 0 then
            mcdu_dat["l"]["L"][2][3] = {txt = "         ---"}
        else
            mcdu_dat["l"]["L"][2][3] = {txt = "         " .. fmgs_dat["perf take off sspd"], col = "green"}
        end

        mcdu_dat["s"]["R"][2].txt = "to shift "
        mcdu_dat["l"]["R"][2][1] = {txt = "[m]     ", size = "s"}
        mcdu_dat["l"]["R"][2][2] = {txt = "[  ]*", col = "cyan"}

        mcdu_dat["s"]["L"][3].txt = " v2     clean"
        mcdu_dat["l"]["L"][3][1] = fmgs_dat_get("perf v2", "{{{", "amber", "cyan")
        mcdu_dat["l"]["L"][3][2] = {txt = "       o="}
        if fmgs_dat["perf take off ospd"] == 0 then
            mcdu_dat["l"]["L"][3][3] = {txt = "         ---"}
        else
            mcdu_dat["l"]["L"][3][3] = {txt = "         " .. fmgs_dat["perf take off ospd"], col = "green"}
        end

        mcdu_dat["s"]["R"][3].txt = "flaps/ths"
        mcdu_dat["l"]["R"][3][1] = {txt = "[   ]", col = "cyan"}
        mcdu_dat["l"]["R"][3][2] = {txt = "[ ]/     ", col = "white"}

        mcdu_dat["s"]["L"][4].txt = "trans alt"
        mcdu_dat["l"]["L"][4] = {txt = "4800", col = "cyan"}
        mcdu_dat["s"]["R"][4].txt = "flex to temp"

        local flex_temp_str = get(Eng_N1_flex_temp) ~= 0 and math.floor(get(Eng_N1_flex_temp)) or "  "
        mcdu_dat["l"]["R"][4] = {txt = "["..flex_temp_str.."]°", col = "cyan"}

        mcdu_dat["s"]["L"][5].txt = "thr red/acc"
        mcdu_dat["l"]["L"][5][1] = {txt = "2000", col = "cyan"}
        mcdu_dat["l"]["L"][5][2] = {txt = "    /3000", col = "cyan", size = "s"}
        mcdu_dat["s"]["R"][5].txt = "eng out acc"
        mcdu_dat["l"]["L"][5] = {txt = "2865", col = "cyan", size = "s"}

        mcdu_dat["s"]["L"][6].txt = " uplink"
        mcdu_dat["l"]["L"][6].txt = "<to data"
        mcdu_dat["s"]["R"][6].txt = "next "
        mcdu_dat["l"]["R"][6].txt = "phase>"

		--mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
    
    -- enter v1
    if phase == "L1" then
        --input, variation = mcdu_get_entry_simple({"UP%.%%", "DN%.%%"})
        input, variation = mcdu_get_entry({"number", length = 3, dp = 0})
        if input ~= NIL then
            v1 = tonumber(input)
            vr = tonumber(fmgs_dat["perf vr"]) or 200 
            v2 = tonumber(fmgs_dat["perf v2"]) or 200

            if v1 <= vr and vr <= v2 then
                fmgs_dat["perf v1"] = v1
            else
                mcdu_send_message("v1/vr/v2 disagree")
            end
        end
        mcdu_open_page(301) -- reload
    end
    
    -- enter vr
    if phase == "L2" then
        --input, variation = mcdu_get_entry_simple({"UP%.%%", "DN%.%%"})
        input, variation = mcdu_get_entry({"number", length = 3, dp = 0})
        if input ~= NIL then
            v1 = tonumber(fmgs_dat["perf v1"]) or 0
            vr = tonumber(input)
            v2 = tonumber(fmgs_dat["perf v2"]) or 200

            if v1 <= vr and vr <= v2 then
                fmgs_dat["perf vr"] = vr
            else
                mcdu_send_message("v1/vr/v2 disagree")
            end
        end
        mcdu_open_page(301) -- reload
    end
    
    -- enter v2
    if phase == "L3" then
        --input, variation = mcdu_get_entry_simple({"UP%.%%", "DN%.%%"})
        input, variation = mcdu_get_entry({"number", length = 3, dp = 0})
        if input ~= NIL then
            v1 = tonumber(fmgs_dat["perf v1"]) or 0
            vr = tonumber(fmgs_dat["perf vr"]) or 0 
            v2 = tonumber(input)

            if v1 <= vr and vr <= v2 then
                fmgs_dat["perf v2"] = v2
            else
                mcdu_send_message("v1/vr/v2 disagree")
            end
        end
        mcdu_open_page(301) -- reload
    end

    -- uplink to data
    if phase == "L6" then
        mcdu_open_page(301) -- reload
    end

    -- flex temp
    if phase == "R4" then
        if get(EWD_flight_phase) >= PHASE_1ST_ENG_TO_PWR then
            mcdu_send_message("avail only in preflight")
            return
        end
        input, variation = mcdu_get_entry({"number", length = 2, dp = 0})
        input = tonumber(input)
        if input > 0 and input <= 80 then
            set(Eng_N1_flex_temp, input)
        else
            mcdu_send_message("temperature out of range")
        end
        mcdu_open_page(301)
    end

    -- next phase
    if phase == "R6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] + 1
        mcdu_open_page(300) -- open 300 perf
    end
end

-- 302 perf clb
mcdu_sim_page[302] =
function (phase)
    if phase == "render" then
        if fmgs_dat["perf phase"] == 2 then
            mcdu_dat_title[1] = {txt = "          clb", col = "green"}
        else
            mcdu_dat_title[1] = {txt = "          clb", col = "white"}
        end

        mcdu_dat["s"]["L"][1].txt = "act mode"
        mcdu_dat["l"]["L"][1] = {txt = "managed", col = "green"}

        mcdu_dat["s"]["L"][2].txt = " ci"
        mcdu_dat["l"]["L"][2] = {txt = " 40", col = "cyan", size = "s"}

        mcdu_dat["l"]["R"][2][2] = {txt = "pred to      ", size = "s"}
        mcdu_dat["l"]["R"][2][1] = {txt = "fl250", col = "cyan"}

        mcdu_dat["s"]["L"][3].txt = " managed  utc"
        mcdu_dat["l"]["L"][3] = {txt = " 250     1014", col = "cyan"}

        mcdu_dat["s"]["R"][3].txt = "dist"
        mcdu_dat["l"]["R"][3] = {txt = "66", col = "cyan"}

        mcdu_dat["s"]["L"][4].txt = "  presel"
        mcdu_dat["l"]["L"][4] = {txt = "*[]", col = "cyan"}

        mcdu_dat["s"]["L"][6].txt = " prev"
        mcdu_dat["l"]["L"][6].txt = "<phase"
        mcdu_dat["s"]["R"][6].txt = "next "
        mcdu_dat["l"]["R"][6].txt = "phase>"

        draw_update()
    end

    -- prev phase
    if phase == "L6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] - 1
        mcdu_open_page(300) -- open 300 perf
    end

    -- next phase
    if phase == "R6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] + 1
        mcdu_open_page(300) -- open 300 perf
    end
end

-- 303 perf crz
mcdu_sim_page[303] =
function (phase)
    if phase == "render" then
        if fmgs_dat["perf phase"] == 2 then
            mcdu_dat_title[1] = {txt = "          crz", col = "green"}
        else
            mcdu_dat_title[1] = {txt = "          crz", col = "white"}
        end

        mcdu_dat["s"]["L"][1].txt = "act mode  utc dest"
        mcdu_dat["l"]["L"][1] = {txt = "managed 1220", col = "green"}

        mcdu_dat["l"]["R"][1] = {txt = "efob", col = "green"}
        mcdu_dat["l"]["R"][1] = {txt = "8.4", col = "green"}

        mcdu_dat["s"]["L"][2].txt = " ci"
        mcdu_dat["l"]["L"][2] = {txt = "540", col = "cyan", size = "s"}

        mcdu_dat["s"]["L"][3].txt = " managed  utc"
        mcdu_dat["l"]["L"][3] = {txt = " 250     1014", col = "cyan"}

        mcdu_dat["s"]["R"][3].txt = "dist"
        mcdu_dat["l"]["R"][3] = {txt = "66", col = "cyan"}

        mcdu_dat["s"]["L"][4].txt = "  presel"
        mcdu_dat["l"]["L"][4] = {txt = "*[]", col = "cyan"}

        mcdu_dat["s"]["R"][4].txt = "des cabin rate"
        mcdu_dat["l"]["R"][4][1] = {txt = "-350     ", col = "cyan"}
        mcdu_dat["l"]["R"][4][2] = {txt = "ft/mn", col = "cyan"}

        mcdu_dat["l"]["R"][5].txt = "step alts>"

        mcdu_dat["s"]["L"][6].txt = " prev"
        mcdu_dat["l"]["L"][6].txt = "<phase"
        mcdu_dat["s"]["R"][6].txt = "next "
        mcdu_dat["l"]["R"][6].txt = "phase>"

        draw_update()
    end

    -- prev phase
    if phase == "L6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] - 1
        mcdu_open_page(300) -- open 300 perf
    end

    -- next phase
    if phase == "R6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] + 1
        mcdu_open_page(300) -- open 300 perf
    end
end

-- 304 perf des
mcdu_sim_page[304] =
function (phase)
    if phase == "render" then
        if fmgs_dat["perf phase"] == 2 then
            mcdu_dat_title[1] = {txt = "          des", col = "green"}
        else
            mcdu_dat_title[1] = {txt = "          des", col = "white"}
        end

        mcdu_dat["s"]["L"][1].txt = "act mode  utc dest"
        mcdu_dat["l"]["L"][1] = {txt = "managed 1220", col = "green"}

        mcdu_dat["l"]["R"][1] = {txt = "efob", col = "green"}
        mcdu_dat["l"]["R"][1] = {txt = "8.4", col = "green"}

        mcdu_dat["s"]["L"][2].txt = " ci"
        mcdu_dat["l"]["L"][2] = {txt = "540", col = "cyan", size = "s"}

        mcdu_dat["s"]["L"][3].txt = " managed  utc"
        mcdu_dat["l"]["L"][3] = {txt = " 250     1014", col = "cyan"}

        mcdu_dat["s"]["R"][3].txt = "dist"
        mcdu_dat["l"]["R"][3] = {txt = "66", col = "cyan"}

        mcdu_dat["s"]["L"][4].txt = "  presel"
        mcdu_dat["l"]["L"][4] = {txt = "*[]", col = "cyan"}

        mcdu_dat["s"]["R"][4].txt = "des cabin rate"
        mcdu_dat["l"]["R"][4][1] = {txt = "-350     ", col = "cyan"}
        mcdu_dat["l"]["R"][4][2] = {txt = "ft/mn", col = "cyan"}

        mcdu_dat["l"]["R"][5].txt = "step alts>"

        mcdu_dat["s"]["L"][6].txt = " prev"
        mcdu_dat["l"]["L"][6].txt = "<phase"
        mcdu_dat["s"]["R"][6].txt = "next "
        mcdu_dat["l"]["R"][6].txt = "phase>"

        draw_update()
    end

    -- prev phase
    if phase == "L6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] - 1
        mcdu_open_page(300) -- open 300 perf
    end

    -- next phase
    if phase == "R6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] + 1
        mcdu_open_page(300) -- open 300 perf
    end
end

-- 305 perf appr
mcdu_sim_page[305] =
function (phase)
    if phase == "render" then
        if fmgs_dat["perf phase"] == 1 then
            mcdu_dat_title[1] = {txt = "    take off rwy", col = "white"}
            mcdu_dat_title[2] = {txt = "                 33r", col = "green"}
        else
            mcdu_dat_title = {txt = "       take off", col = "white"}
        end

        mcdu_dat["s"]["L"][1].txt = " qnh   flp retr"
        mcdu_dat["l"]["L"][1][1] = {txt = "{{{", col = "amber"}
        mcdu_dat["l"]["L"][1][2] = {txt = "       f=---"}

        mcdu_dat["s"]["R"][1].txt = "final "
        mcdu_dat["l"]["R"][1] = {txt = "ils 33r", col = "green"}

        mcdu_dat["s"]["L"][2].txt = " temp  slt retr"
        mcdu_dat["l"]["L"][2][1] = {txt = "{{{", col = "amber"}
        mcdu_dat["l"]["L"][2][2] = {txt = "       s=---"}

        mcdu_dat["s"]["R"][2].txt = "baro "
        mcdu_dat["l"]["R"][2] = {txt = "[  ]", col = "cyan"}

        mcdu_dat["s"]["L"][3].txt = " v2     clean"
        mcdu_dat["l"]["L"][3][1] = {txt = "{{{", col = "amber"}
        mcdu_dat["l"]["L"][3][2] = {txt = "       o=---"}

        mcdu_dat["s"]["R"][3].txt = "flaps/ths"
        mcdu_dat["l"]["R"][3] = {txt = "[]/[   ]", col = "cyan"}

        mcdu_dat["s"]["L"][4].txt = "trans alt"
        mcdu_dat["s"]["R"][4].txt = "flex to temp"

        mcdu_dat["s"]["L"][5].txt = "thr red/acc"
        mcdu_dat["s"]["R"][5].txt = "eng out acc"

        mcdu_dat["s"]["L"][6].txt = " uplink"
        mcdu_dat["l"]["L"][6].txt = "<to data"
        mcdu_dat["s"]["R"][6].txt = "next "
        mcdu_dat["l"]["R"][6].txt = "phase>"

		--mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end

    -- prev phase
    if phase == "L6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] - 1
        mcdu_open_page(300) -- open 300 perf
    end

    -- next phase
    if phase == "R6" then
        fmgs_dat["perf page"] = fmgs_dat["perf page"] + 1
        mcdu_open_page(300) -- open 300 perf
    end
end

-- 400 init
mcdu_sim_page[400] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          init"

        fmgs_dat_init("fmgs init", false)   -- init has the fmgs been initialised? to false

        fmgs_dat_init("crz temp alt", true) --init has crz temp been changed?

        --[[ CO RTE --]]
        mcdu_dat["s"]["L"][1].txt = " co rte"
        --changes on fmgs airport init
        if fmgs_dat["fmgs init"] then
            mcdu_dat["l"]["L"][1] = fmgs_dat_get("co rte", "NONE", "cyan", "cyan")
        else
            mcdu_dat["l"]["L"][1] = fmgs_dat_get("co rte", "{{{{{{{{{{", "amber", "cyan")
        end

        --[[ FROM / TO --]]
        mcdu_dat["s"]["R"][1].txt = " from/to  "

        mcdu_dat["l"]["R"][1] = fmgs_dat_get("origin", "{{{{", "amber", "cyan")
        mcdu_dat["l"]["R"][1].txt = mcdu_dat["l"]["R"][1].txt .. "/" .. fmgs_dat_get_txt("dest", "{{{{")

        --[[ ALTN / CO RTE --]]
        mcdu_dat["s"]["L"][2].txt = "altn/co rte"
        mcdu_dat["l"]["L"][2] = fmgs_dat_get("co rte", "----/---------", "white", "cyan")

        --[[ FLT NBR --]]
        mcdu_dat["s"]["L"][3].txt = "flt nbr"
        mcdu_dat["l"]["L"][3] = fmgs_dat_get("flt nbr", "{{{{{{{{", "amber", "cyan")

        --[[ IRS INIT --]]
        mcdu_dat["l"]["R"][3].txt = "irs init>"

        --[[ COST INDEX --]]
        mcdu_dat["s"]["L"][5].txt = "cost index"
        --changes on fmgs airport init
        if fmgs_dat["fmgs init"] then
            mcdu_dat["l"]["L"][5] = fmgs_dat_get("cost index", "{{{", "amber", "cyan")
        else
            mcdu_dat["l"]["L"][5] = fmgs_dat_get("cost index", "---", "white", "cyan")
        end

        --[[ WIND --]]
        mcdu_dat["l"]["R"][5].txt = "wind>"

        --[[ CRZ FL/TEMP --]]
        mcdu_dat["s"]["L"][6].txt = "crz fl/temp"
        --changes on fmgs airport init
        if fmgs_dat["fmgs init"] then
            crz_fl_init_txt = "{{{{{"
            crz_fl_init_col = "amber"
        else
            crz_fl_init_txt = "-----"
            crz_fl_init_col = "white"
        end
        mcdu_dat["l"]["L"][6][1] = fmgs_dat_get("crz fl", crz_fl_init_txt, crz_fl_init_col, "cyan", 
            --formatting
            function (val) 
                if #val > 4 then
                    return "FL" .. val:sub(1,3)
                else
                    return val:sub(1,4)
                end
            end
        )
        mcdu_dat["l"]["L"][6][1].txt = mcdu_dat["l"]["L"][6][1].txt .. "/" --append slant

        --has crz temp been altered?
        if fmgs_dat["crz temp alt"] then
            crz_temp_size = "l"
        else
            crz_temp_size = "s"
        end
        --changes on fmgs airport init
        if fmgs_dat["fmgs init"] then
            mcdu_dat["l"]["L"][6][2] = {txt = "      " .. fmgs_dat_get_txt("crz temp", "{{{") .. "°", col = mcdu_dat["l"]["L"][6][1].col, size = crz_temp_size}
        else
            mcdu_dat["l"]["L"][6][2] = {txt = "      " .. fmgs_dat_get_txt("crz temp", "---") .. "°", col = mcdu_dat["l"]["L"][6][1].col, size = crz_temp_size}
        end

        --[[ TROPO --]]
        mcdu_dat["s"]["R"][6].txt = "tropo "
        fmgs_dat_init("tropo", 39060)
        --grows bigger if changed
        if fmgs_dat["tropo"] == 39060 then
            tropo_size = "s"
        else
            tropo_size = "l"
        end
        mcdu_dat["l"]["R"][6] = {txt = fmgs_dat["tropo"], col = "cyan", size = tropo_size}

        draw_update()
    end
	-- flt nbr
    if phase == "L3" then
        input = mcdu_get_entry()
        if string.len(input) < 9 then
            fmgs_dat["flt nbr"] = input
        end
        mcdu_open_page(400) -- reload
    end
    -- cost index
    if phase == "L5" then
        --format e.g. 100
        input, variation = mcdu_get_entry({"number", length = 3, dp = 0})
        if input ~= NIL then
            fmgs_dat["cost index"] = input
        end
        mcdu_open_page(400) -- reload
    end
    -- crz fl/temp
    if phase == "L6" then
        -- e.g. mcdu_get_entry({"altitude"}, {"number", length = 2, dp = 0})
        --format e.g. FL230
        input_a, input_b = mcdu_get_entry({"altitude"}, {"number", length = 2, dp = 0})

        if input_a ~= NIL or input_b ~= NIL then
            if input_a ~= NIL then
                alt = input_a * 100
                if alt >= 1500 then
                    fmgs_dat["crz fl"] = tonumber(alt)
                    fmgs_dat["crz temp"] = math.floor(tonumber(alt / 100) * -0.2 + 16)
                    fmgs_dat["crz temp alt"] = false --crz temp has not been altered
                else
                    mcdu_send_message("invalid altitude")
                end
            end
            if input_b ~= NIL then
                fmgs_dat["crz temp"] = tonumber(input_b)
                fmgs_dat["crz temp alt"] = true --crz temp has been manually altered
            end
            mcdu_open_page(400) -- reload
        end
    end

    -- from/to
    if phase == "R1" then
        --format e.g. ksea/kbfi
        input = mcdu_get_entry_simple({"####/####"})

        if input ~= NIL then

			-- parse data
			airp_origin_name = input:sub(1,4):lower()
            airp_dest_name = input:sub(6,9):lower()

            airp_origin = fmgs_get_nav(airp_origin_name, NAV_AIRPORT)
            airp_dest = fmgs_get_nav(airp_dest_name, NAV_AIRPORT)

            -- wipe f-pln
            fpln_clearall()

            -- add to f-pln
            fpln_add_airports(airp_origin, airp_dest)

            -- do these airports exist?
			if airp_origin.navtype == NAV_UNKNOWN or
			   airp_dest.navtype == NAV_UNKNOWN then
				mcdu_send_message("NOT IN DATABASE")
				mcdu_open_page(400) -- reload
				return
			end			

			-- init data
			fmgs_dat["fmgs init"] = true
			fmgs_dat["origin"] = airp_origin.id
			fmgs_dat["dest"] = airp_dest.id

            fmgs_dat["origin lat"] = airp_origin.lat
            fmgs_dat["origin lon"] = airp_origin.lon
            fmgs_dat["init irs lat"] = airp_origin.lat
            fmgs_dat["init irs lon"] = airp_origin.lon

            -- enable latlon sel in irs init page
            fmgs_dat["init irs latlon sel"] = "lat"

			mcdu_open_page(401) -- open 401 init routes
        end
    end

    -- irs init>
    if phase == "R3" then
        mcdu_open_page(402) -- open 402 init irs init
    end

    -- wind
    if phase == "R5" then
        mcdu_open_page(403) -- open 403 init climb wind
    end

    -- tropo
    if phase == "R6" then
        input = mcdu_get_entry({"number", length = 3, dp = 0})
		if input ~= NIL then
      	  fmgs_dat["tropo"] = input * 100
		end
        mcdu_open_page(400) -- reload
    end
end

-- 401 init routes
mcdu_sim_page[401] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "       " ..  fmgs_dat["origin"] .. "/" .. fmgs_dat["dest"]

		mcdu_dat["l"]["L"][1] = {txt = " none", col = "green"}
		mcdu_dat["l"]["L"][6].txt = "<return"

        draw_update()
    end
	if phase == "L6" then
        mcdu_open_page(400) -- open 400 init
    end
end

-- TODO: REMOVE THIS
irs1_status = "aligning-gps"
irs2_status = "aligning-gps"
irs3_status = "aligning-gps"

gps_status = "on"

irs_statuses = {irs1_status, irs2_status, irs3_status}

-- 402 init irs init
mcdu_sim_page[402] =
function (phase)

    if phase == "render" then
        fmgs_dat_init("init irs latlon sel", "nil")-- init latlon selection for irs alignment
        fmgs_dat_init("init irs latlon edited", false)-- init latlon edited?
        fmgs_dat_init("confirm align on ref", false)-- init latlon edited?

        mcdu_dat_title.txt = "        irs init"

        if fmgs_dat["fmgs init"] then

            --[[ REFERENCE LAT / LONG --]]
            mcdu_dat["s"]["L"][1].txt = "lat    reference"
            mcdu_dat["s"]["R"][1].txt = "long"

            --irs latlon change selection
            if fmgs_dat["init irs latlon sel"] == "lat" then
                mcdu_dat["s"]["L"][1].txt = "lat^   reference"
            elseif fmgs_dat["init irs latlon sel"] == "lon" then
                mcdu_dat["s"]["R"][1].txt = "^long"
            end

            if fmgs_dat["init irs lat"] == fmgs_dat["origin lat"] and
               fmgs_dat["init irs lon"] == fmgs_dat["origin lon"] then
                mcdu_dat["l"]["L"][1][1] = {txt = "          "  .. fmgs_dat["origin"], col = "green"}
            else
                mcdu_dat["l"]["L"][1][1] = {txt = "          ----"}
            end

            -- set colour based on if latlon ref can be changed
            if fmgs_dat["init irs latlon sel"] == "lock" then
                col = "green"
            else
                col = "cyan"
            end

            deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(fmgs_dat["init irs lat"], "lat")
            mcdu_dat["l"]["L"][1][2] = {txt = tostring(deg) .. "º    "  .. tostring(dir), col = col}
            mcdu_dat["l"]["L"][1][3] = {txt = "   " .. mcdu_pad_dp(tostring(Round(min, 1)), 1), col = col, size = "s"}
            deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(fmgs_dat["init irs lon"], "lon")
            mcdu_dat["l"]["R"][1][1] = {txt = tostring(deg) .. "º    "  .. tostring(dir), col = col}
            mcdu_dat["l"]["R"][1][2] = {txt = mcdu_pad_dp(tostring(Round(min, 1)), 1) .. " ", col = col, size = "s"}

            --[[ GPS POSITION LAT / LONG --]]
            mcdu_dat["s"]["L"][2].txt = "lat   gps position"
            mcdu_dat["s"]["R"][2].txt = "long"
            if gps_status == "off" then
                mcdu_dat["l"]["L"][2].txt = "--º--.--"
                mcdu_dat["l"]["R"][2].txt = "---º--.--"
            elseif gps_status == "on" then
                deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(get(gps_lat), "lat")
                mcdu_dat["l"]["L"][2][1] = {txt = tostring(deg) .. "º    "  .. tostring(dir), col = "green"}
                mcdu_dat["l"]["L"][2][2] = {txt = "   " ..mcdu_pad_dp(tostring(Round(min, 1)), 1), col = "green", size = "s"}
                deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(get(gps_lon), "lon")
                mcdu_dat["l"]["R"][2][1] = {txt = tostring(deg) .. "º    "  .. tostring(dir), col = "green"}
                mcdu_dat["l"]["R"][2][2] = {txt = mcdu_pad_dp(tostring(Round(min, 1)), 1) .. " ", col = "green", size = "s"}
            end
        end

        for no, irs in ipairs(irs_statuses) do
                print(irs_statuses[no])
            lat = nil
            lon = nil
            if irs == "off" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " off"
            elseif irs == "att" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " in att"
            elseif irs == "aligning" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligning on ---"
            elseif irs == "aligning-gps" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligning on gps"
                lat = get(gps_lat)
                lon = get(gps_lon)
            elseif irs == "aligning-ref" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligning on ref"
                lat = fmgs_dat["init irs lat"]
                lon = fmgs_dat["init irs lon"]
            elseif irs == "aligning-cdu" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligning on cdu"
                lat = 0
                lon = 0
            elseif irs == "aligned-gps" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligned on gps"
                lat = get(gps_lat)
                lon = get(gps_lon)
            elseif irs == "aligned-ref" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligned on ref"
                lat = fmgs_dat["init irs lat"]
                lon = fmgs_dat["init irs lon"]
            elseif irs == "aligned-cdu" then
                mcdu_dat["s"]["L"][no + 2].txt = "  irs" .. no .. " aligned on cdu"
                lat = 0
                lon = 0
            end

            -- if lat and lon are set
            if lat ~= nil and lon ~= nil then
                deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(lat, "lat")
                mcdu_dat["l"]["L"][no + 2][1] = {txt = "   " .. tostring(deg) .. "º    "  .. tostring(dir) .. "/", col = "green"}
                mcdu_dat["l"]["L"][no + 2][2] = {txt = "      " ..mcdu_pad_dp(tostring(Round(min, 1)), 1), col = "green", size = "s"}
                deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(lon, "lon")
                mcdu_dat["l"]["R"][no + 2][1] = {txt = tostring(deg) .. "º    "  .. tostring(dir) .. "   ", col = "green"}
                mcdu_dat["l"]["R"][no + 2][2] = {txt = mcdu_pad_dp(tostring(Round(min, 1)), 1) .. "    ", col = "green", size = "s"}
            else
                mcdu_dat["l"]["L"][no + 2].txt = "   --º--.--/---º--.--"
            end
        end
		mcdu_dat["l"]["L"][6].txt = "<return"
        if fmgs_dat["init irs latlon sel"] ~= "lock" then
            if fmgs_dat["confirm align on ref"] then
                mcdu_dat["l"]["R"][6] = {txt = "confirm align*", col = "amber"}
            else
                mcdu_dat["l"]["R"][6] = {txt = "align on ref→", col = "cyan"}
            end
        end

        draw_update()
    end
    if phase == "L6" then
        mcdu_open_page(400) -- open 400 init
    end
    if phase == "R6" then
        -- if not confirmed
        if not fmgs_dat["confirm align on ref"] then
            fmgs_dat["confirm align on ref"] = true
            mcdu_open_page(402) -- reload
            return
        end

        -- if confirmed
        fmgs_dat["init irs latlon sel"] = "lock" -- disable editing of latlon
        for no, irs in ipairs(irs_statuses) do
            if irs == "aligning-gps" then
                irs_statuses[no] = "aligning-ref"
            end
        end
        mcdu_open_page(402) -- reload
    end

    -- slew left/right (used for lat lon)
    if phase == "slew_left" or phase == "slew_right" then
        --toggle between lat and lon select
        fmgs_dat["init irs latlon sel"] = mcdu_toggle(fmgs_dat["init irs latlon sel"], "lat", "lon")
        mcdu_open_page(402) -- reload
    end

    -- slew up (used for lat lon)
    if phase == "slew_up" or phase == "slew_down" then
        fmgs_dat["init irs latlon edited"] = true

        if phase == "slew_up" then
            increment = 1
        else
            increment = -1
        end

        if fmgs_dat["init irs latlon sel"] == "lat" then
            fmgs_dat["init irs lat"] = fmgs_dat["init irs lat"] + 1/600 * increment

        elseif fmgs_dat["init irs latlon sel"] == "lon" then
            fmgs_dat["init irs lon"] = fmgs_dat["init irs lon"] + 1/600 * increment
        end
        mcdu_open_page(402) -- reload
    end
end

-- 403 init climb wind
mcdu_sim_page[403] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "       climb wind"

        mcdu_dat["s"]["L"][1].txt = "tru wind alt"
        mcdu_dat["l"]["L"][1] = {txt = "[ ]º/[ ]/[   ]", col = "cyan"}
        mcdu_dat["s"]["R"][1].txt = "history "
        mcdu_dat["l"]["R"][1].txt = "wind>"
        mcdu_dat["s"]["R"][2] = {txt = "wind ", col = "amber"}
        mcdu_dat["l"]["R"][2] = {txt = "request*", col = "amber"}

        mcdu_dat["s"]["R"][5].txt = "next "
        mcdu_dat["l"]["R"][5].txt = "phase>"

        mcdu_dat["l"]["L"][6][1] = {txt = "<return"}
		mcdu_dat["l"]["L"][6][2] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
    if phase == "L1" then
        mcdu_send_message("page not implemented")
    end
    if phase == "L6" then
        mcdu_open_page(400) -- open 400 init
    end
end

-- 500 data
mcdu_sim_page[500] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "     data index"

        mcdu_dat["s"]["L"][1].txt = " position"
        mcdu_dat["l"]["L"][1].txt = "<monitor"
        mcdu_dat["s"]["L"][2].txt = " irs"
        mcdu_dat["l"]["L"][2].txt = "<monitor"
        mcdu_dat["s"]["L"][3].txt = " gps"
        mcdu_dat["l"]["L"][3].txt = "<monitor"
        mcdu_dat["l"]["L"][4].txt = "<a/c status"
        mcdu_dat["s"]["L"][5].txt = " closest"
        mcdu_dat["l"]["L"][5].txt = "<airports"
        mcdu_dat["s"]["L"][6].txt = " equitime"
        mcdu_dat["l"]["L"][6].txt = "<point"

        mcdu_dat["s"]["R"][6].txt = "acars/print "
        mcdu_dat["l"]["R"][6].txt = "function>"

        draw_update()
    end
    if phase == "L1" then
        mcdu_open_page(501) -- open 501 data position monitor
    end
    if phase == "L2" then
        mcdu_open_page(502) -- open 502 data irs monitor
    end
    if phase == "L3" then
        mcdu_open_page(503) -- open 503 data gps monitor
    end
    if phase == "L4" then
        mcdu_open_page(505) -- open 505 data A/C status
    end
end

-- 501 data position monitor
mcdu_sim_page[501] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "      position monitor"
        draw_update()
    end
end

-- 502 data irs monitor
mcdu_sim_page[502] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "      irs monitor"
        if fmgs_dat["origin"] ~= nil then
            mcdu_dat["s"]["L"][1].txt = "      drift at " .. fmgs_dat["origin"]
        end
        for i = 1,3,1 do
            mcdu_dat["l"]["L"][i].txt = "<irs" .. i
            if ADIRS_sys[i].ir_status == IR_STATUS_ALIGNED then
                mcdu_dat["s"]["L"][i+1] = {txt = " nav   drift   1.0nm/h", col = "green"}
            elseif ADIRS_sys[n].ir_status == IR_STATUS_FAULT then
                mcdu_dat["s"]["L"][i+1] = {txt = " ir fault", col = "green"}
            elseif ADIRS_sys[n].ir_status == IR_STATUS_ATT_ALIGNED
                   and not ADIRS_sys[i].ir_is_waiting_hdg then
                mcdu_dat["s"]["L"][i+1] = {txt = " att", col = "green"}
            elseif ADIRS_sys[n].ir_status == IR_STATUS_ATT_ALIGNED
                   and ADIRS_sys[i].ir_is_waiting_hdg then
                mcdu_dat["s"]["L"][i+1] = {txt = " enter heading", col = "green"}
            elseif ADIRS_sys[n].ir_status == IR_STATUS_IN_ALIGN then
                ttn = math.floor(ADIRS_sys[i].ir_align_start_time + get(Adirs_total_time_to_align) - get(TIME) / 60)
                mcdu_dat["s"]["L"][i+1] = {txt = " align ttn " .. ttn, col = "green"}
            end
        end
        draw_update()
    end

    if phase == "L1" then
        fmgs_dat["irs monitoring"] = 1
        mcdu_open_page(506) -- 506 data irs monitor irs
    end
    if phase == "L2" then
        fmgs_dat["irs monitoring"] = 2
        mcdu_open_page(506) -- 506 data irs monitor irs
    end
    if phase == "L3" then
        fmgs_dat["irs monitoring"] = 3
        mcdu_open_page(506) -- 506 data irs monitor irs
    end
end

-- 503 data gps monitor
mcdu_sim_page[503] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "      gps monitor"
        draw_update()
    end
end

-- 505 data A/C status
mcdu_sim_page[505] =
function (phase)
    if phase == "render" then

        mcdu_dat["s"]["L"][1].txt = " eng"

        if get(Engine_option) == 0 then
            mcdu_dat_title.txt = "        a321-271nx"
            mcdu_dat["l"]["L"][1] = {txt = "cfm-leap-1a", col = "green"}
        else
            --mcdu_dat_title.txt = "        a321-251nx"
            --mcdu_dat["l"]["L"][1] = {txt = "pw-1130g-jm", col = "green"}
        end
        
        mcdu_dat["s"]["L"][2].txt = " active data base"
		mcdu_dat["l"]["L"][2] = {txt = " 28 nov-25dec", col = "cyan"}
		mcdu_dat["l"]["R"][2] = {txt = "ab49012001", col = "green"}
        mcdu_dat["s"]["L"][3].txt = " second data base"
        mcdu_dat["l"]["L"][3] = {txt = " none", col = "cyan", size = "s"}

        mcdu_dat["s"]["L"][5].txt = "chg code"
        fmgs_dat_init("chg code", "[ ]")
        mcdu_dat["l"]["L"][5] = {txt = fmgs_dat["chg code"], col = "cyan"}

        mcdu_dat["s"]["L"][6].txt = "idle/perf"
        fmgs_dat_init("chg code lock", true)
        fmgs_dat_init("idle", 0)
        fmgs_dat_init("perf", 0)
        if fmgs_dat["chg code lock"] then
            mcdu_dat["l"]["L"][6][1] = {txt = "+0.0/+0.0", col = "green", size = "s"}
        else
            idleperf = fmgs_dat_get_txt("idle/perf", "+0.0/+0.0")
            idle = string.sub(idleperf, 1, 4)
            perf = string.sub(idleperf, 6, 9)
            if idle == "+0.0" then
                mcdu_dat["l"]["L"][6][1] = {txt = idle, col = "cyan", size = "s"}
            else
                mcdu_dat["l"]["L"][6][1] = {txt = idle, col = "cyan"}
            end
            mcdu_dat["l"]["L"][6][2] = {txt = "    /", col = "cyan", size = "s"}
            if perf == "+0.0" then
                mcdu_dat["l"]["L"][6][3] = {txt = "     " .. perf, col = "cyan", size = "s"}
            else
                mcdu_dat["l"]["L"][6][3] = {txt = "     " .. perf, col = "cyan"}
            end
        end

		mcdu_dat["s"]["R"][6].txt = "software"
        mcdu_dat["l"]["R"][6].txt = "options>"

       
        draw_update()
    end

    -- chg code
    if phase == "L5" then
        input = mcdu_get_entry({"word", length = 3, dp = 0})
        if input ~= NIL then
            if input == "ARM" then
                fmgs_dat["chg code"] = input
                fmgs_dat["chg code lock"] = false
                mcdu_open_page(505) -- reload
            else
                mcdu_send_message("invalid change code")
            end
        end
    end

    -- idle/perf
    if phase == "L6" then
        if fmgs_dat["chg code lock"] then
            mcdu_send_message("enter change code")
            return
        end
        input_a, input_b = mcdu_get_entry({"number", length = 1, dp = 1}, {"number", length = 1, dp = 1})

         -- is input valid?
        if input_a ~= NIL or input_b ~= NIL then
            if input_a ~= NIL then
                fmgs_dat["idle"] = tonumber(input_a)
            end
            if input_b ~= NIL then
                fmgs_dat["perf"] = tonumber(input_b)
            end

            -- output idle/perf
            fmgs_dat["idle/perf"] = ""
            idle = tostring(fmgs_dat["idle"])
            perf = tostring(fmgs_dat["perf"])
            print(fmgs_dat["perf"])
            if fmgs_dat["idle"] % 1 == 0 then
                idle = idle .. ".0"
            end
            if fmgs_dat["perf"] % 1 == 0 then
                perf = perf .. ".0"
            end
            if fmgs_dat["idle"] >= 0 then
                fmgs_dat["idle/perf"] = "+" .. idle
            else
                fmgs_dat["idle/perf"] = idle
            end
            if fmgs_dat["perf"] >= 0 then
                fmgs_dat["idle/perf"] = fmgs_dat["idle/perf"] .. "/+" .. perf
            else
                fmgs_dat["idle/perf"] = fmgs_dat["idle/perf"] .. "/" .. perf
            end

            mcdu_open_page(505) -- reload
        end
    end

    -- options>
    if phase == "R6" then
        mcdu_open_page(1101) -- open 1101 mcdu menu options
    end
end

-- 506 data irs monitor irs
mcdu_sim_page[506] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "         irs " .. fmgs_dat["irs monitoring"]
        mcdu_dat["s"]["L"][1].txt = "position"
        mcdu_dat["s"]["L"][2].txt = "ttrk"
        mcdu_dat["s"]["L"][3].txt = "thdg"
        mcdu_dat["s"]["L"][4].txt = "wind"
        mcdu_dat["s"]["L"][5].txt = "aoa"
        draw_update()
    end
end

-- 600 f-pln
mcdu_sim_page[600] =
function (phase)
    if phase == "render" then
        fmgs_dat_init("fpln index", 0)
        fmgs_dat_init("fpln page", 1)

        --format the fpln
        fpln_format()

        --initialize fpln page index
        fpln_index = fmgs_dat["fpln index"]

        --initialize title
        mcdu_dat_title[1] = {txt = " "}

        --add flt nbr to title
        flt_nbr = fmgs_dat["flt nbr"] or ""
        mcdu_dat_title[2] = {txt = "               " .. flt_nbr, size = "s"}

        --draw the f-pln
        for i = 1, math.min(#fmgs_dat["fpln fmt"], 5) do
            --increment fpln index, loop around flight plan.
            fpln_index = fpln_index % #fmgs_dat["fpln fmt"] + 1

            fpln_wpt = fmgs_dat["fpln fmt"][fpln_index] or ""
            --is it a simple message (pseudo-waypoint)?
            if type(fpln_wpt) == "string" then
                mcdu_dat["l"]["L"][i].txt = fpln_wpt
            --is it a waypoint?
            else
                --set title
                fmgs_dat_init("wpt from", fmgs_dat["origin"])
                if i == 1 and fpln_wpt.name:sub(1,4) == fmgs_dat["wpt from"] then
                    mcdu_dat_title[1] = {txt = " from", size = "s"}
                end

                --[[ VIA --]]
                --is via an airway/note or heading?
                if type(fpln_wpt.via) == "string" then
                    --is via an airway or note?
                    if fpln_wpt.via:sub(1,1) ~= "(" then
                        mcdu_dat["s"]["L"][i][1] = {txt = " " .. fpln_wpt.via}
                    --via must be a note
                    else
                        mcdu_dat["s"]["L"][i][1] = {txt = " " .. fpln_wpt.via, col = "green"}
                    end
                --via must be a heading
                else
                    mcdu_dat["s"]["L"][i][1] = {txt = " H" .. fpln_wpt.via .. "°"}
                end

                --[[ NAME --]]
                mcdu_dat["l"]["L"][i][1] = {txt = fpln_wpt.name, col = "green"}

                --[[ DIST --]]
                if i == 2 then
                    suffix = "nm"
                else
                    suffix = "  "
                end
                mcdu_dat["s"]["R"][i] = {txt = fpln_wpt.dist .. suffix .. "   ", col = "green", size = "s"}

                if fmgs_dat["fpln page"] == 1 then
                    --[[ TIME --]]
                    if fpln_wpt.time ~= -1 then
                        mcdu_dat["l"]["L"][i][2] = {txt = "        " .. fpln_wpt.time, col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["L"][i][2] = {txt = "        ----", size = "s"}
                    end

                    --[[ SPD --]]
                    if fpln_wpt.spd ~= -1 then
                        mcdu_dat["l"]["R"][i][1] = {txt = fpln_wpt.spd .. "      ", col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["R"][i][1] = {txt = "---      ", size = "s"}
                    end

                    --[[ ALT --]]
                    if fpln_wpt.alt ~= -1 then
                        mcdu_dat["l"]["R"][i][2] = {txt = fpln_wpt.alt, col = "green", size = "s"}
                        mcdu_dat["l"]["R"][i][3] = {txt = "/     ", col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["R"][i][2] = {txt = "/-----", size = "s"}
                    end
                else
                    --[[ EFOB --]]
                    if fpln_wpt.efob ~= -1 then
                        mcdu_dat["l"]["L"][i][2] = {txt = "        " .. fpln_wpt.efob, col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["L"][i][2] = {txt = "        -.-", size = "s"}
                    end

                    --[[ WIND HDG --]]
                    if fpln_wpt.windhdg ~= -1 then
                        mcdu_dat["l"]["R"][i][2] = {txt = mcdu_pad_num(fpln_wpt.windhdg, 3) ..  "°/   ", col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["R"][i][2] = {txt = "---°/   ", size = "s"}
                    end

                    --[[ WIND SPD --]]
                    if fpln_wpt.windspd ~= -1 then
                        mcdu_dat["l"]["R"][i][1] = {txt = fpln_wpt.windspd, col = "green", size = "s"}
                    else
                        mcdu_dat["l"]["R"][i][1] = {txt = "---", size = "s"}
                    end
                end
            end
        end

        --[[ DEST --]]
        mcdu_dat["s"]["L"][6] = {txt = "dest    time  "}
        mcdu_dat["s"]["R"][6] = {txt = "dist  efob"}
        --the last index of the f-pln must be the destination
        dest_index = #fmgs_dat["fpln"]
        if #fmgs_dat ~= 0 then
            dest_wpt = fmgs_dat["fpln"][dest_index]
        else
            dest_wpt = {name = "", time = "", dist = "", efob = ""}
        end
        mcdu_dat["l"]["L"][6][1] = {txt = fmgs_dat["dest"]}
        --formatting
        if dest_wpt.time == "" then
            mcdu_dat["l"]["L"][6][2] = {txt = "        ----"}
        else
            mcdu_dat["l"]["L"][6][2] = {txt = "        " .. dest_wpt.time}
        end
        --formatting
        if dest_wpt.dist == "" then
            mcdu_dat["l"]["R"][6][2] = {txt = "-----      "}
        else
            mcdu_dat["l"]["R"][6][2] = {txt = dest_wpt.dist .. "      "}
        end
        --formatting
        if dest_wpt.efob == "" then
            mcdu_dat["l"]["R"][6][1] = {txt = "--.- "}
        else
            mcdu_dat["l"]["R"][6][1] = {txt = dest_wpt.efob .. " "}
        end

        draw_update()
    end

    --if any of the side buttons are pushed
    if phase:sub(1,1) == "R" or phase:sub(1,1) == "L" then

        index = phase:sub(2,2)
        wpt_check = mcdu_dat["l"]["L"][tonumber(index)][1] or "invalid"

        --if valid wpt, open 601 f-pln lat rev page
        if wpt_check ~= "invalid" then
            fmgs_dat["lat rev wpt"] = wpt_check.txt
            mcdu_open_page(601) -- 601 f-pln lat rev page
        end
    end

    -- slew left/right (used for lat lon)
    if phase == "slew_left" or phase == "slew_right" then
        --toggle between lat and lon select
        fmgs_dat["fpln page"] = mcdu_toggle(fmgs_dat["fpln page"], 1, 2)
        mcdu_open_page(600) -- reload
    end

    --slew up or down
    if phase == "slew_up" or phase == "slew_down" then
        if phase == "slew_up" then
            increment = 1
        else
            increment = -1
        end
        --is flight plan long enough to slew up and down?
        if #fmgs_dat["fpln fmt"] > 2 then
            fmgs_dat["fpln index"] = fmgs_dat["fpln index"] % #fmgs_dat["fpln fmt"] + increment 
            print(fmgs_dat["fpln index"])
        end
        mcdu_open_page(600) -- reload
    end
end

-- 601 f-pln lat rev page
mcdu_sim_page[601] =
function (phase)
    if phase == "render" then
        fmgs_dat_init("lat rev wpt", "none")
        --get the wpt in question's name
        wpt_find_name = fmgs_dat["lat rev wpt"]
        wpt = "invalid"
        --find the wpt data with the name
        for i, wpt_find in ipairs(fmgs_dat["fpln"]) do
            if wpt_find.name == wpt_find_name then
                wpt = wpt_find
                break
            end
        end
        if wpt == "invalid" then
            mcdu_send_message("error 601 " .. wpt_find_name) --throw error!
            return
        end
        mcdu_dat_title[1] = {txt = "   lat rev"}
        mcdu_dat_title[2] = {txt = "           from", size = "s"}
        mcdu_dat_title[3] = {txt = "                " .. wpt.name, col = "green"}

        --get lat lon
        nav = fmgs_get_nav(wpt.name, wpt.navtype)

        deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(nav.lat, "lat")
        mcdu_dat["s"]["L"][1][1] = {txt = "   " .. tostring(deg) .. "º    "  .. tostring(dir) .. "/", col = "green"}
        mcdu_dat["s"]["L"][1][2] = {txt = "      " ..mcdu_pad_dp(tostring(Round(min, 1)), 1), col = "green", size = "s"}
        deg, min, sec, dir = mcdu_ctrl_dd_to_dmsd(nav.lon, "lon")
        mcdu_dat["s"]["R"][1][1] = {txt = tostring(deg) .. "º    "  .. tostring(dir) .. "   ", col = "green"}
        mcdu_dat["s"]["R"][1][2] = {txt = mcdu_pad_dp(tostring(Round(min, 1)), 1) .. "    ", col = "green", size = "s"}


        mcdu_dat["s"]["R"][2].txt = "ll xing/incr/no"
        mcdu_dat["l"]["R"][2] = {txt = "[  ]°/[ ]°/[ ]", col = "cyan"}

        mcdu_dat["s"]["R"][3].txt = "next wpt "
        mcdu_dat["l"]["R"][3] = {txt = "[    ]", col = "cyan"}
        --if wpt is not dept airport
        if wpt.name:upper():sub(1,4) ~= fmgs_dat["dest"] then
            mcdu_dat["s"]["R"][4].txt = "new dest "
            mcdu_dat["l"]["R"][4] = {txt = "[  ]", col = "cyan"}
        end

        --is wpt the dept airport?
        if wpt.name:sub(1,4) == fmgs_dat["origin"] then
            mcdu_dat["l"]["L"][1].txt = "<departure"
            mcdu_dat["l"]["R"][1].txt = "fix info>"
        --is wpt the dept airport?
        elseif wpt.name:sub(1,4) == fmgs_dat["dest"] then
            mcdu_dat["l"]["R"][1].txt = "arrival>"
            mcdu_dat["l"]["L"][3].txt = "<altn"
        end

        mcdu_dat["l"]["L"][6].txt = "<return"

        draw_update()
    end
    
    --departure
    if phase == "L1" then
        --is wpt the dept airport?
        if wpt.name:sub(1,4) == fmgs_dat["origin"] then
        fmgs_dat["fpln latrev index"] = 1
            mcdu_open_page(602) -- open 602 f-pln lat rev page dept airport
        end
    end
    --arrival/fix info
    if phase == "R1" then
        --is wpt the dept airport?
        if wpt.name:sub(1,4) == fmgs_dat["dest"] then
            fmgs_dat["fpln latrev index"] = 1
            mcdu_open_page(603) -- open 603 f-pln lat rev page dest airport
        else
            mcdu_send_message("not yet implemented!")
        end
    end
    --altn
    if phase == "L3" then
        --is wpt the dept airport?
        if wpt.name:sub(1,4) == fmgs_dat["origin"] then
            mcdu_open_page(602) -- open 602 f-pln lat rev page dept airport
        end
    end
    if phase == "R2" or phase == "R3" or phase == "R4" then
        mcdu_send_message("not yet implemented!")
    end
    if phase == "L6" then
        mcdu_open_page(600) -- open 600 f-pln
    end
end

-- 602 f-pln lat rev page dept airport
mcdu_sim_page[602] =
function (phase)
    if phase == "render" then
        -- title
        mcdu_dat_title[1] = {txt = " departures"}
        mcdu_dat_title[2] = {txt = "            from", size = "s"}
        mcdu_dat_title[3] = {txt = "                 " .. wpt.name, col = "green"}
            
        -- init data
        fmgs_dat_init("fpln latrev index", 1)   -- init the increment/offset of runway data to 0
        fmgs_dat_init("fpln latrev dept mode", "runway") -- init selection mode to runways
        fmgs_dat_init("fpln latrev dept runway", "")
        fmgs_dat_init("fpln latrev dept sid", "")
        fmgs_dat_init("fpln latrev dept trans", "")

        -- subtitle
        mcdu_dat["s"]["L"][1].txt = " rwy      sid     trans"
        if fmgs_dat["fpln latrev dept runway"] ~= "" then
            mcdu_dat["l"]["L"][1][1] = {txt = " " .. fmgs_dat["fpln latrev dept runway"], col = "yellow"}
        else
            mcdu_dat["l"]["L"][1][1] = {txt = " ---", col = "white"}
        end

        if fmgs_dat["fpln latrev dept sid"] ~= "" then
            mcdu_dat["l"]["L"][1][2] = {txt = "         " .. fmgs_dat["fpln latrev dept sid"], col = "yellow"}
        else
            mcdu_dat["l"]["L"][1][2] = {txt = "         ------", col = "white"}
        end

        if fmgs_dat["fpln latrev dept trans"] ~= "" then
            mcdu_dat["l"]["R"][1] = {txt = "                 " .. fmgs_dat["fpln latrev dept trans"], col = "yellow"}
        else
            mcdu_dat["l"]["R"][1] = {txt = "                 ------", col = "white"}
        end

        --set airport in question
        airport = fmgs_dat["origin"]

        -- set the data
        parser = {}
        parser = Parser_Cifp:new(CIFP_PATH .. airport .. ".dat") 

        if fmgs_dat["fpln latrev dept mode"] == "runway" then
            parser_apt = Parser_Apt:new(APT_PATH)
            if not init_airport_lut then
                parser_apt:create_airport_lut()
            end

            runways = parser:get_runways()
            runway_lengths = parser_apt:get_runway_lengths(airport)
        else
            runway = fmgs_dat["fpln latrev dept runway"]

            -- trim runway
            if string.sub(runway, 3, 3) == " " then
                runway = string.sub(runway, 1, 2)
            end

            -- get sids
            sids = parser:get_sids("RW" .. runway)
            sid = fmgs_dat["fpln latrev dept sid"]

            -- get trans
            if sid ~= "" then
                trans = parser:get_trans("SID", sid, "RW" .. runway) -- get trans for sid
            else
                trans = {} -- no trans avail
            end
            for _, i in ipairs(sids) do
                print(i)
            end
        end

        for i = 1, 4 do
            line = i + 1
            index = fmgs_dat["fpln latrev index"] + i - 1
            print(line)
            print(index)

            if fmgs_dat["fpln latrev dept mode"] == "runway" then
                mcdu_dat["l"]["L"][6].txt = "<return"

                mcdu_dat["s"]["L"][2].txt = " available runways"

                --get runway or stop
                if index <= #runways then
                    runway = runways[index]
                else
                    break
                end

                --get ILS data
                --e.g. RW16C -> 16C
                runway_name = string.sub(runway, 3, -1)
                -- remove the last letter if there is none, i.e. trim it
                if string.sub(runway_name, 3, 3) == " " then
                    runway_name = string.sub(runway_name, 1, 2)
                end
                ils = fmgs_get_nav(airport .. " " .. runway_name, NAV_ILS)

                if ils.navtype ~= NAV_UNKNOWN then
                    --get ILS freq
                    --format e.g. 11170 to 111.70
                    ils.freq = tostring(ils.freq)
                    freq = ils.freq:sub(1,3) .. "." .. ils.freq:sub(4,5)

                    --get ILS crs
                    ils.hdg = sasl.degTrueToDegMagnetic(ils.hdg)
                    if ils.hdg > 180 then
                        --format e.g. 342 to -18
                        ils.hdg = Round(ils.hdg - 360,0)
                    end
                    --how many digits?
                    ils.hdg = tostring(ils.hdg)
                    if string.len(ils.hdg) == 1 then
                        ils.hdg = ils.hdg:sub(1,1)
                    elseif string.len(ils.hdg) == 2 then
                        ils.hdg = ils.hdg:sub(1,2)
                    else
                        ils.hdg = ils.hdg:sub(1,3)
                    end

                    mcdu_dat["l"]["R"][line] = {txt = "crs" .. ils.hdg .. "   ", col = "cyan", size = "s"}

                    mcdu_dat["s"]["L"][line + 1] = {txt = "       ILS", col = "cyan"}
                    mcdu_dat["s"]["R"][line + 1] = {txt = ils.id .. "/" .. freq, col = "cyan"}
                end
                
                runway_length = runway_lengths[runway_name] or 0
                runway_length = Round(runway_length / 5, -2) * 5

                mcdu_dat["l"]["L"][line][1] = {txt = "←" .. runway_name, col = "cyan"}
                mcdu_dat["l"]["L"][line][2] = {txt = "       " .. runway_length .. "m", col = "cyan"}

            else
                mcdu_dat["s"]["L"][2].txt = "sid   available   trans"
                
                --engine out sid
                mcdu_dat["s"]["L"][6] = {txt = "          eosid"}
                mcdu_dat["l"]["L"][6][1] = {txt = "           none", col = "yellow"}

                mcdu_dat["l"]["R"][6] = {txt = "insert*", col = "amber"}
                mcdu_dat["l"]["L"][6][2] = {txt = "←erase", col = "amber"}

                --get sids or stop
                if index <= #sids then
                    sid = sids[index]
                    if sid == fmgs_dat["fpln latrev dept sid"] or
                       (sid == "no sid" and fmgs_dat["fpln latrev dept sid"] == "none") then
                        prefix = " "
                    else
                        prefix = "←"
                    end
                    mcdu_dat["l"]["L"][line] = {txt = prefix .. sid, col = "cyan"}
                end

                --get trans or stop
                if index <= #trans then
                    tran = trans[index]
                    if tran == fmgs_dat["fpln latrev dept trans"] or
                       (tran == "none" and fmgs_dat["fpln latrev dept trans"] ==  "none") then
                        prefix = " "
                    else
                        prefix = "→"
                    end
                    mcdu_dat["l"]["R"][line] = {txt = tran .. prefix, col = "cyan"}
                end
            end
        end


        draw_update()
    end

    --if any of the side buttons are pushed
    if (phase:sub(1,1) == "L" or phase:sub(1,1) == "R") and tonumber(phase:sub(2,2)) >= 2 and tonumber(phase:sub(2,2)) <= 5 then

        if fmgs_dat["fpln latrev dept mode"] == "runway" then
            if phase:sub(1,1) == "L" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 2
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #runways then
                    runway = runways[index]
                    fmgs_dat["fpln latrev dept mode"] = "sid"
                    fmgs_dat["fpln latrev dept runway"] = string.sub(runway, 3, -1)
                    fmgs_dat["fpln latrev index"] = 1
                    mcdu_open_page(602) -- reload
                end
            end
        else
            if phase:sub(1,1) == "L" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 2
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #sids then
                    sid = sids[index]
                    print(sid)
                    fmgs_dat["fpln latrev dept mode"] = "trans"
                    fmgs_dat["fpln latrev dept sid"] = sid
                    fmgs_dat["fpln latrev dept trans"] = ""
                    fmgs_dat["fpln latrev index"] = 1

                    if sid == "no sid" then
                        fmgs_dat["fpln latrev dept sid"] = "none"
                    end
                    mcdu_open_page(602) -- reload
                end
            elseif phase:sub(1,1) == "R" and
                   fmgs_dat["fpln latrev dept mode"] == "trans" or
                   fmgs_dat["fpln latrev dept mode"] == "done" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 2
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #trans then
                    tran = trans[index]
                    print(tran)
                    fmgs_dat["fpln latrev dept mode"] = "done"
                    fmgs_dat["fpln latrev dept trans"] = tran
                    fmgs_dat["fpln latrev index"] = 1

                    if tran == "none" then
                        fmgs_dat["fpln latrev dept trans"] = "none"
                    end
                    mcdu_open_page(602) -- reload
                end
            end
        end
    end

    --<return or <erase
    if phase == "L6" then
        if fmgs_dat["fpln latrev dept mode"] == "runway" then
            mcdu_open_page(600) -- open 600 f-pln
        else
            fmgs_dat["fpln latrev dept mode"] = "runway"
            fmgs_dat["fpln latrev dept runway"] = ""
            fmgs_dat["fpln latrev dept sid"] = ""
            fmgs_dat["fpln latrev dept trans"] = ""
            fmgs_dat["fpln latrev index"] = 1
            mcdu_open_page(602) -- reload
        end
    end

    --insert>
    if phase == "R6" then
        if fmgs_dat["fpln latrev dept mode"] ~= "runway" then
            rwy = fmgs_dat["fpln latrev dept runway"]

            -- trim runway
            if string.sub(rwy, 3, 3) == " " then
                rwy = string.sub(rwy, 1, 2)
            end

            rwy = "RW" .. rwy
            proc = fmgs_dat["fpln latrev dept sid"]
            trans = fmgs_dat["fpln latrev dept trans"]
            -- set the data
            airport = fmgs_dat["origin"]
            parser = {}
            parser = Parser_Cifp:new(CIFP_PATH .. airport .. ".dat") 
            wpts = parser:get_departure(rwy, proc, trans)

            idx = fpln_pointto_wpt(airport)
            fmgs_dat["fpln"][idx].name = airport .. fmgs_dat["fpln latrev dept runway"]
            for _, wpt in ipairs(wpts) do
                fmgs_dat["fpln"][idx].nextname = wpts[1].name
                fpln_add_wpt(wpt)
            end

            mcdu_open_page(600) -- open 600 f-pln
        end
    end

    --slew up or down
    if phase == "slew_up" or phase == "slew_down" then
        if phase == "slew_up" then
            increment = 1
        else
            increment = -1
        end
        if fmgs_dat["fpln latrev index"] + increment > 0 then
            fmgs_dat["fpln latrev index"] = fmgs_dat["fpln latrev index"] + increment
        end
        print(fmgs_dat["fpln latrev index"])
        mcdu_open_page(602)
    end
end

-- 603 f-pln lat rev page arr airport
mcdu_sim_page[603] =
function (phase)
    if phase == "render" then
        -- title
        mcdu_dat_title[1] = {txt = "     arrival"}
        mcdu_dat_title[2] = {txt = "             to", size = "s"}
        mcdu_dat_title[3] = {txt = "                 " .. wpt.name, col = "green"}
            
        -- init data
        fmgs_dat_init("fpln latrev index", 1)   -- init the increment/offset of runway data to 0
        fmgs_dat_init("fpln latrev arr mode", "appr") -- init selection mode to runways
        fmgs_dat_init("fpln latrev arr appr", "")
        fmgs_dat_init("fpln latrev arr star", "")
        fmgs_dat_init("fpln latrev arr via", "")
        fmgs_dat_init("fpln latrev arr trans", "")

        -- subtitle
        mcdu_dat["s"]["L"][1].txt = " appr     via      star"
        mcdu_dat["s"]["R"][2].txt = "trans"
        if fmgs_dat["fpln latrev arr appr"] ~= "" then
            mcdu_dat["l"]["L"][1][1] = {txt = fmgs_dat["fpln latrev arr appr"], col = "yellow"}
        else
            mcdu_dat["l"]["L"][1][1] = {txt = "------", col = "white"}
        end

        if fmgs_dat["fpln latrev arr via"] ~= "" then
            mcdu_dat["l"]["L"][1][2] = {txt = "         " .. fmgs_dat["fpln latrev arr via"], col = "yellow"}
        else
            mcdu_dat["l"]["L"][1][2] = {txt = "         ------", col = "white"}
        end

        if fmgs_dat["fpln latrev arr star"] ~= "" then
            mcdu_dat["l"]["R"][1] = {txt = fmgs_dat["fpln latrev arr star"], col = "yellow"}
        else
            mcdu_dat["l"]["R"][1] = {txt = "------", col = "white"}
        end

        if fmgs_dat["fpln latrev arr trans"] ~= "" then
            mcdu_dat["l"]["R"][2] = {txt = fmgs_dat["fpln latrev arr trans"], col = "yellow"}
        else
            mcdu_dat["l"]["R"][2] = {txt = "------", col = "white"}
        end

        --set airport in question
        airport = fmgs_dat["dest"]

        -- set the data
        parser = {}
        parser = Parser_Cifp:new(CIFP_PATH .. airport .. ".dat") 

        if fmgs_dat["fpln latrev arr mode"] == "appr" then
            parser_apt = Parser_Apt:new(APT_PATH)
            if not init_airport_lut then
                parser_apt:create_airport_lut()
            end

            runways = parser:get_approaches()
            runway_lengths = parser_apt:get_runway_lengths(airport)
        else
            appr = fmgs_dat["fpln latrev arr appr"]

            -- get vias
            vias = parser:get_vias(appr)

            -- get stars
            stars = parser:get_stars(appr)
            star = fmgs_dat["fpln latrev arr star"]

            -- get trans
            if star ~= "" then
                trans = parser:get_trans("STAR", star, appr) -- get trans for star
            else
                trans = {} -- no trans avail
            end
            for _, i in ipairs(stars) do
                print(i)
            end
        end

        for i = 1, 3 do
            line = i + 2
            index = fmgs_dat["fpln latrev index"] + i - 1
            print(line)
            print(index)

            if fmgs_dat["fpln latrev arr mode"] == "appr" then
                mcdu_dat["l"]["L"][6].txt = "<return"

                mcdu_dat["s"]["L"][3].txt = " appr available"

                --get runway or stop
                if index <= #runways then
                    runway = runways[index]
                else
                    break
                end

                --get ILS data
                --e.g. RNV16C -> 16C
                if string.sub(runway, 1, 3) == "RNV" or
                   string.sub(runway, 1, 3) == "ILS" or 
                   string.sub(runway, 1, 3) == "VOR" or
                   string.sub(runway, 1, 3) == "NDB" then
                    if string.sub(runway, 6, 6) == "L" or
                       string.sub(runway, 6, 6) == "C" or
                       string.sub(runway, 6, 6) == "R" then
                        runway_name = string.sub(runway, 4, 6)
                    else
                        runway_name = string.sub(runway, 4, 5)
                    end
                else
                    if string.sub(runway, 1, 2) == "RW" then
                        runway_name = string.sub(runway, 3, -1)
                    else
                        runway_name = string.sub(runway, 2, -1)
                    end
                end

                ils = fmgs_get_nav(airport .. " " .. runway_name, NAV_ILS)

                if string.sub(runway, 1, 3) == "ILS" and ils.navtype ~= NAV_UNKNOWN then
                    --get ILS freq
                    --format e.g. 11170 to 111.70
                    ils.freq = tostring(ils.freq)
                    freq = ils.freq:sub(1,3) .. "." .. ils.freq:sub(4,5)

                    --get ILS crs
                    ils.hdg = sasl.degTrueToDegMagnetic(ils.hdg)
                    if ils.hdg > 180 then
                        --format e.g. 342 to -18
                        ils.hdg = Round(ils.hdg - 360,0)
                    end
                    --how many digits?
                    ils.hdg = tostring(ils.hdg)
                    if string.len(ils.hdg) == 1 then
                        ils.hdg = ils.hdg:sub(1,1)
                    elseif string.len(ils.hdg) == 2 then
                        ils.hdg = ils.hdg:sub(1,2)
                    else
                        ils.hdg = ils.hdg:sub(1,3)
                    end

                    mcdu_dat["l"]["R"][line] = {txt = "crs" .. ils.hdg .. "   ", col = "cyan", size = "s"}

                    mcdu_dat["s"]["L"][line + 1] = {txt = "       ILS", col = "cyan"}
                    mcdu_dat["s"]["R"][line + 1] = {txt = ils.id .. "/" .. freq, col = "cyan"}
                end
                
                runway_length = runway_lengths[runway_name] or 0
                runway_length = Round(runway_length / 5, -2) * 5

                mcdu_dat["l"]["L"][line][1] = {txt = "          " .. runway_length .. "m", col = "cyan"}
                mcdu_dat["l"]["L"][line][2] = {txt = "←" .. runway, col = "cyan"}

            elseif fmgs_dat["fpln latrev arr mode"] == "vias" then
                mcdu_dat["s"]["L"][2].txt = " appr available"
                mcdu_dat["l"]["L"][2].txt = " vias"

                mcdu_dat["l"]["R"][6] = {txt = "insert*", col = "amber"}
                mcdu_dat["l"]["L"][6] = {txt = "←erase", col = "amber"}

                --get vias or stop
                if index <= #vias then
                    via = vias[index]
                    if via == fmgs_dat["fpln latrev arr via"] or
                       (via == "no via" and fmgs_dat["fpln latrev arr via"] == "via") then
                        prefix = " "
                    else
                        prefix = "←"
                    end
                    mcdu_dat["l"]["L"][line] = {txt = prefix .. via, col = "cyan"}
                end
            else
                mcdu_dat["s"]["L"][2].txt = " appr"
                mcdu_dat["l"]["L"][2].txt = "<vias"
                mcdu_dat["s"]["L"][3].txt = "stars  available   trans"

                mcdu_dat["l"]["R"][6] = {txt = "insert*", col = "amber"}
                mcdu_dat["l"]["L"][6] = {txt = "←erase", col = "amber"}

                --get stars or stop
                if index <= #stars then
                    star = stars[index]
                    if star == fmgs_dat["fpln latrev arr star"] or
                       (star == "no star" and fmgs_dat["fpln latrev arr star"] == "none") then
                        prefix = " "
                    else
                        prefix = "←"
                    end
                    mcdu_dat["l"]["L"][line] = {txt = prefix .. star, col = "cyan"}
                end

                --get trans or stop
                if index <= #trans then
                    tran = trans[index]
                    if tran == fmgs_dat["fpln latrev arr trans"] or
                       (tran == "none" and fmgs_dat["fpln latrev dept trans"] ==  "none") then
                        prefix = " "
                    else
                        prefix = "→"
                    end
                    mcdu_dat["l"]["R"][line] = {txt = tran .. prefix, col = "cyan"}
                end
            end
        end


        draw_update()
    end

    --if any of the side buttons are pushed
    if (phase:sub(1,1) == "L" or phase:sub(1,1) == "R") and tonumber(phase:sub(2,2)) >= 3 and tonumber(phase:sub(2,2)) <= 5 then

        if fmgs_dat["fpln latrev arr mode"] == "appr" then
            if phase:sub(1,1) == "L" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 3
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #runways then
                    runway = runways[index]
                    fmgs_dat["fpln latrev arr mode"] = "star"
                    fmgs_dat["fpln latrev arr appr"] = runway
                    fmgs_dat["fpln latrev index"] = 1
                    mcdu_open_page(603) -- reload
                end
            end
        elseif fmgs_dat["fpln latrev arr mode"] == "vias" then
            if phase:sub(1,1) == "L" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 3
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #vias then
                    via = vias[index]
                    fmgs_dat["fpln latrev arr mode"] = "trans"
                    fmgs_dat["fpln latrev arr via"] = via
                    fmgs_dat["fpln latrev index"] = 1
                    mcdu_open_page(603) -- reload
                end
            end
        else
            if phase:sub(1,1) == "L" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 3
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #stars then
                    star = stars[index]
                    print(star)
                    fmgs_dat["fpln latrev arr mode"] = "vias"
                    fmgs_dat["fpln latrev arr star"] = star
                    fmgs_dat["fpln latrev arr trans"] = ""
                    fmgs_dat["fpln latrev index"] = 1

                    if star == "no star" then
                        fmgs_dat["fpln latrev arr star"] = "none"
                    end
                    mcdu_open_page(603) -- reload
                end
            elseif phase:sub(1,1) == "R" and
                   fmgs_dat["fpln latrev arr mode"] == "trans" or
                   fmgs_dat["fpln latrev arr mode"] == "done" then
                --find the index of which button was pressed, and -2 to make it equal to `offset` in the function above
                index = tonumber(phase:sub(2,2)) - 3
                index = fmgs_dat["fpln latrev index"] + index
                if index <= #trans then
                    tran = trans[index]
                    print(tran)
                    fmgs_dat["fpln latrev arr mode"] = "done"
                    fmgs_dat["fpln latrev arr trans"] = tran
                    fmgs_dat["fpln latrev index"] = 1

                    if tran == "none" then
                        fmgs_dat["fpln latrev arr trans"] = "none"
                    end
                    mcdu_open_page(603) -- reload
                end
            end
        end
    end

    --<return or <erase
    if phase == "L6" then
        if fmgs_dat["fpln latrev arr mode"] == "appr" then
            mcdu_open_page(600) -- open 600 f-pln
        else
            fmgs_dat["fpln latrev arr mode"] = "appr"
            fmgs_dat["fpln latrev arr appr"] = ""
            fmgs_dat["fpln latrev arr star"] = ""
            fmgs_dat["fpln latrev arr via"] = ""
            fmgs_dat["fpln latrev arr trans"] = ""
            fmgs_dat["fpln latrev index"] = 1
            mcdu_open_page(603) -- reload
        end
    end

    --<vias
    if phase == "L2" then
        if fmgs_dat["fpln latrev arr mode"] == "star" or
           fmgs_dat["fpln latrev arr mode"] == "trans" or
           fmgs_dat["fpln latrev arr mode"] == "done" then
            fmgs_dat["fpln latrev arr mode"] = "vias"
            fmgs_dat["fpln latrev index"] = 1
            mcdu_open_page(603) -- reload
        end
    end

    --insert>
    if phase == "R6" then
        if fmgs_dat["fpln latrev arr mode"] ~= "appr" then
            -- set the data
            airport = fmgs_dat["dest"]
            parser = {}
            parser = Parser_Cifp:new(CIFP_PATH .. airport .. ".dat") 
            appr = fmgs_dat["fpln latrev arr appr"]
            via = fmgs_dat["fpln latrev arr via"]
            proc = fmgs_dat["fpln latrev arr star"]
            trans = fmgs_dat["fpln latrev arr trans"]

            idx = fpln_pointto_wpt(airport)
            fpln_offset_pointer(-1)

            wpts = parser:get_arrival(appr, via, proc, trans)
            for no, wpt in ipairs(wpts) do
                if string.sub(wpt.name, 1, 2) == "RW" then
                    wpt.name = airport .. string.sub(wpt.name, 3, -1)
                    print("michael buble " .. fmgs_dat["fpln"][no].name)
                    fmgs_dat["fpln"][no].nextname = wpt.name
                end
                fpln_add_wpt(wpt)
            end
            mcdu_open_page(600) -- open 600 f-pln
        end
    end

    --slew up or down
    if phase == "slew_up" or phase == "slew_down" then
        if phase == "slew_up" then
            increment = 1
        else
            increment = -1
        end
        if fmgs_dat["fpln latrev index"] + increment > 0 then
            fmgs_dat["fpln latrev index"] = fmgs_dat["fpln latrev index"] + increment
        end
        print(fmgs_dat["fpln latrev index"])
        mcdu_open_page(603) --reload
    end
end

-- 700 rad nav
mcdu_sim_page[700] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "        radio nav"
        mcdu_dat["s"]["L"][1].txt = "vor1/freq"
        mcdu_dat["s"]["R"][1].txt = "freq/vor2"
        mcdu_dat["s"]["L"][2].txt = "crs"
        mcdu_dat["s"]["R"][2].txt = "crs"
        mcdu_dat["s"]["L"][3].txt = "ils /freq"
        mcdu_dat["s"]["L"][4].txt = "crs"
        mcdu_dat["s"]["L"][5].txt = "adf1/freq"
        mcdu_dat["s"]["R"][5].txt = "freq/adf2"

        if get(DRAIMS_nav_stby_mode) == 0 then
            mcdu_dat["l"]["L"][1][1] = {txt = " [ ]", col = "cyan"}
            mcdu_dat["l"]["L"][1][2] = {txt = "    /111.00", col = "cyan", size = "s"}

            mcdu_dat["l"]["R"][1][1] = {txt = "[ ] ", col = "cyan"}
            mcdu_dat["l"]["R"][1][2] = {txt = "110.90/    ", col = "cyan", size = "s"}

            mcdu_dat["l"]["L"][2] = {txt = "315", col = "cyan"}
            mcdu_dat["l"]["R"][2] = {txt = "315", col = "cyan"}

            mcdu_dat["l"]["L"][3][1] = {txt = "[  ]", col = "cyan"}
            mcdu_dat["l"]["L"][3][2] = {txt = "    /08.10", col = "cyan", size = "s"}

            mcdu_dat["l"]["L"][4].txt = "---"

            mcdu_dat["l"]["L"][5][1] = {txt = " [ ]", col = "cyan"}
            mcdu_dat["l"]["L"][5][2] = {txt = "    / 210.0", col = "cyan", size = "s"}

            mcdu_dat["l"]["R"][5][1] = {txt = "[ ] ", col = "cyan"}
            mcdu_dat["l"]["R"][5][2] = {txt = "210.0/    ", col = "cyan", size = "s"}
        end
        draw_update()
    end
end

-- 800 fuel pred
mcdu_sim_page[800] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          fuel pred"

        mcdu_dat["l"]["L"][1].txt = "not yet implemented"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 900 sec f-pln
mcdu_sim_page[900] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "        sec f-pln"

		mcdu_dat["l"]["L"][1] = {txt = "←copy active", col = "cyan"}
		mcdu_dat["l"]["R"][1].txt = "init>"
		mcdu_dat["l"]["L"][2].txt = "<sec f-pln"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 1000 atc comm
mcdu_sim_page[1000] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          atc comm"

        mcdu_dat["l"]["L"][1].txt = "not yet implemented"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 1100 mcdu menu
mcdu_sim_page[1100] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "        mcdu menu"
        mcdu_dat["l"]["L"][1].txt = "<fmgc"

        mcdu_dat["l"]["L"][4].txt = "<cfds"
        mcdu_dat["l"]["R"][6].txt = "options>"
        draw_update()
    end
    if phase == "L1" then
        mcdu_open_page(505) -- open 505 data a/c status
    end
    if phase == "L4" then
        mcdu_open_page(1300) -- open 1300 CDFS menu
    end
    if phase == "R6" then
        mcdu_open_page(1101) -- open 1101 mcdu menu options
    end
end

-- 1101 mcdu menu options
mcdu_sim_page[1101] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "   c star simulations"

        mcdu_dat["l"]["L"][1].txt = "<about"
        mcdu_dat["l"]["L"][2].txt = "<colours"
        mcdu_dat["l"]["R"][2].txt = "debug>"

        mcdu_dat["s"]["R"][3] = {txt = "head developer      ", col = "white"}
        mcdu_dat["l"]["R"][3] = {txt = "jonathan orr       ", col = "cyan"}
		mcdu_dat["s"]["R"][4] = {txt = "avionics         ", col = "white"}
        mcdu_dat["l"]["R"][4] = {txt = "henrick ku        ", col = "green"}
		mcdu_dat["s"]["R"][5] = {txt = "programmer        ", col = "white"}
        mcdu_dat["l"]["R"][5] = {txt = "ricorico         ", col = "green"}
        mcdu_dat["s"]["R"][6] = {txt = "mcdu written by     ", col = "white"}
        mcdu_dat["l"]["R"][6] = {txt = "chaidhat chaimongkol  ", col = "green"}
        mcdu_dat["l"]["L"][6] = {txt = "<", col = "white"}

        draw_update()
    end
    if phase == "L1" then
        mcdu_open_page(1102) -- open 1102 mcdu menu options about
    end
    if phase == "L2" then
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    if phase == "R2" then
        mcdu_open_page(1106) -- open 1106 mcdu menu options debug
    end
    if phase == "L6" then
        mcdu_open_page(1100) -- open 1100 mcdu menu
    end
end

-- 1102 mcdu menu options about
mcdu_sim_page[1102] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "  version and license"
        mcdu_dat["s"]["L"][1].txt = "mcdu version"
        mcdu_dat["l"]["L"][1].txt = "v1.0 not finished"
        mcdu_dat["s"]["L"][2].txt = "license"
        mcdu_dat["l"]["L"][2].txt = "gpl 3.0"
        mcdu_dat["s"]["L"][3].txt = "github.com"
        mcdu_dat["l"]["L"][3].txt = "jonathanorr/a321neo-fxpl"

        mcdu_dat["s"]["L"][4] = {txt = "join our discord!", col = "cyan"}
        mcdu_dat["s"]["L"][5].txt = "mcdu manufacturer"
        mcdu_dat["l"]["L"][5].txt = "honeywell"


        mcdu_dat["l"]["R"][6].txt = "return>"

        draw_update()
    end
    if phase == "R6" then
        mcdu_open_page(1101) -- open 1101 mcdu menu options
    end
end

-- 1103 mcdu menu options colours
mcdu_sim_page[1103] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "     a32nx colours"
        mcdu_dat["l"]["L"][1].txt = " colour change utility"

        for i,col in ipairs({"white", "cyan", "green", "amber"}) do
            mcdu_dat["l"]["L"][i + 1] = {txt = "<" .. col, col = col}
        end
        for i,col in ipairs({"yellow", "magenta", "red"}) do
            mcdu_dat["l"]["R"][i + 1] = {txt = col .. ">", col = col}
        end

        mcdu_dat["l"]["R"][5].txt = "load palette>"

        mcdu_dat["l"]["L"][6].txt = "←disco mode?"
        mcdu_dat["l"]["R"][6].txt = "return>"
        draw_update()
    end
    if phase == "L2" then
        fmgs_dat["colour"] = "white"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end
    if phase == "L3" then
        fmgs_dat["colour"] = "cyan"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end
    if phase == "L4" then
        fmgs_dat["colour"] = "green"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end
    if phase == "L5" then
        fmgs_dat["colour"] = "amber"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end

    if phase == "R2" then
        fmgs_dat["colour"] = "yellow"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end
    if phase == "R3" then
        fmgs_dat["colour"] = "magenta"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end
    if phase == "R4" then
        fmgs_dat["colour"] = "red"
        mcdu_open_page(1104) -- open 1104 mcdu menu options colours changer
    end

    if phase == "R5" then
        mcdu_open_page(1105) -- open 1105 mcdu menu options colours palette
    end

    if phase == "L6" then
        if not hokey_pokey then
            hokey_pokey = true
            for i,f in ipairs({"white", "cyan", "amber", "green", "yellow", "magenta", "red"}) do
                MCDU_DISP_COLOR[f] = {1, 0, 0} 
            end
        else
            hokey_pokey = false
            mcdu_send_message("pls load default palette")
        end
    end
    if phase == "R6" then
        mcdu_open_page(1101) -- open 1101 mcdu menu options
    end
end
-- 1104 mcdu menu options colours changer
mcdu_sim_page[1104] =
function (phase)
    if phase == "render" then
        colour = fmgs_dat["colour"]
        mcdu_dat_title.txt = "     change " .. colour
        mcdu_dat_title.col = colour
        mcdu_dat["l"]["L"][1] = {txt = "←red   " .. MCDU_DISP_COLOR[colour][1] * 100 .. " percent", col = colour}
        mcdu_dat["l"]["L"][2] = {txt = "←green " .. MCDU_DISP_COLOR[colour][2] * 100 .. " percent", col = colour}
        mcdu_dat["l"]["L"][3] = {txt = "←blue  " .. MCDU_DISP_COLOR[colour][3] * 100 .. " percent", col = colour}

        mcdu_dat["l"]["L"][5].txt = "format e.g. 10"
        mcdu_dat["l"]["L"][6].txt = "<return"

        draw_update()
    end
    if phase == "L1" then
        input = mcdu_get_entry({"number", length = 3, dp = 1})
        if input ~= NIL then
            input_col = tonumber(input) / 100
            MCDU_DISP_COLOR[fmgs_dat["colour"]][1] = input_col

            mcdu_open_page(1104) -- reload page
        else
            mcdu_send_message("please enter value")
        end
    end
    if phase == "L2" then
        input = mcdu_get_entry({"number", length = 3, dp = 1})
        if input ~= NIL then
            input_col = tonumber(input) / 100
            MCDU_DISP_COLOR[fmgs_dat["colour"]][2] = input_col

            mcdu_open_page(1104) -- reload page
        else
            mcdu_send_message("please enter value")
        end
    end
    if phase == "L3" then
        input = mcdu_get_entry({"number", length = 3, dp = 1})
        if input ~= NIL then
            input_col = tonumber(input) / 100
            MCDU_DISP_COLOR[fmgs_dat["colour"]][3] = input_col

            mcdu_open_page(1104) -- reload page
        else
            mcdu_send_message("please enter value")
        end
    end
    if phase == "L6" then
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
end

-- 1105 mcdu menu options colours palette
mcdu_sim_page[1105] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "  load colour palette"
        mcdu_dat["l"]["L"][1].txt = "←load default"
        mcdu_dat["l"]["L"][2].txt = "←load ecam colours"
        mcdu_dat["l"]["L"][3].txt = "←load aerofsx"
        mcdu_dat["l"]["L"][4].txt = "←load classic"
        mcdu_dat["l"]["L"][5].txt = "←load high contrast"

        mcdu_dat["l"]["R"][6].txt = "return>"

        draw_update()
    end
    if phase == "L1" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   {1.00, 1.00, 1.00},
            ["cyan"] =    {0.10, 0.70, 1.00},
            ["green"] =   {0.20, 1.00, 0.20},
            ["amber"] =   {1.00, 0.66, 0.16},
            ["yellow"] =  {1.00, 0.76, 0.16},
            ["magenta"] = {1.00, 0.00, 1.00},
            ["red"] =     {1.00, 0.00, 0.00},

            ["black"] =   {0.00, 0.00, 0.00},
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    if phase == "L2" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   ECAM_WHITE,
            ["cyan"] =    ECAM_BLUE,
            ["green"] =   ECAM_GREEN,
            ["amber"] =   ECAM_ORANGE,
            ["yellow"] =  {1.00, 1.00, 0.00},
            ["magenta"] = ECAM_MAGENTA,
            ["red"] =     ECAM_RED,

            ["black"] =   ECAM_BLACK,
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    if phase == "L3" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   {1.00, 1.00, 1.00},
            ["cyan"] =    {0.07, 0.79, 0.94}, --11AFD7
            ["green"] =   {0.09, 0.54, 0.17}, --178A2C
            ["amber"] =   {0.95, 0.65, 0.00}, --F2BF2C
            ["yellow"] =  {0.95, 0.75, 0.00}, --F2BF2C
            ["magenta"] = {0.57, 0.29, 0.63}, --924AA1
            ["red"] =     {1.00, 0.00, 0.00},

            ["black"] =   {0.00, 0.00, 0.00},
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    if phase == "L4" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   {1.00, 1.00, 1.00}, --EBEFEC
            ["cyan"] =    {0.68, 0.84, 1.00}, --ADD7FF
            ["green"] =   {0.73, 1.00, 0.87}, --BBFDDD
            ["amber"] =   {1.00, 0.67, 0.70}, --FFAAB3
            ["yellow"] =  {1.00, 0.67, 0.70}, --FFAAB3
            ["magenta"] = {0.92, 0.54, 1.00}, --EC8AFF
            ["red"] =     {1.00, 0.50, 0.50},

            ["black"] =   {0.00, 0.00, 0.00},
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    --[[
    if phase == "L4" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   {1.00, 1.00, 1.00},
            ["cyan"] =    {0.00, 0.68, 0.78}, --00AEC7
            ["green"] =   {0.52, 0.74, 0.00}, --84BD00
            ["amber"] =   {1.00, 0.31, 0.00}, --FE5000
            ["yellow"] =  {0.88, 0.88, 0.00}, --E1E000
            ["magenta"] = {0.64, 0.09, 0.56}, --A51890
            ["red"] =     {0.89, 0.00, 0.17}, --E4002B

            ["black"] =   {0.00, 0.00, 0.00},
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
    --]]
    if phase == "L5" then
        MCDU_DISP_COLOR = 
        {
            ["white"] =   {1.00, 1.00, 1.00},
            ["cyan"] =    {0.00, 1.00, 1.00}, 
            ["green"] =   {0.00, 1.00, 0.00},
            ["amber"] =   {1.00, 0.50, 0.00},
            ["yellow"] =  {1.00, 1.00, 0.00},
            ["magenta"] = {1.00, 0.00, 1.00},
            ["red"] =     {1.00, 0.00, 0.00},

            ["black"] =   {0.00, 0.00, 0.00},
        }
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end

    if phase == "R6" then
        mcdu_open_page(1103) -- open 1103 mcdu menu options colours
    end
end

-- 1106 mcdu menu options debug
mcdu_sim_page[1106] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["L"][1].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["L"][1].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["R"][2].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["R"][2].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["L"][3].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["L"][3].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["R"][4].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["R"][4].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["L"][5].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["L"][5].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["s"]["R"][6].txt = "xxxxxxxxxxxxxxxxxxxxxxxx"
        mcdu_dat["l"]["R"][6][1] = {txt = "       xxxxxxxxxxxxxxxxx"}
        mcdu_dat["l"]["R"][6][2] = {txt = "<return                 ", col = "amber"}

        draw_update()
    end
    if phase == "L6" then
        mcdu_open_page(1101) -- open 1101 mcdu menu options
    end
end


-- 1200 air port
mcdu_sim_page[1200] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          air port"

        mcdu_dat["l"]["L"][1].txt = "not yet implemented"
		mcdu_dat["l"]["L"][6] = {txt = "        inop page", col = "amber"}

        draw_update()
    end
end

-- 1300 CFDS menu (maintenance)
mcdu_sim_page[1300] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "          cfds"

        mcdu_dat["l"]["L"][4].txt = "<avionics status"
        mcdu_dat["l"]["L"][5].txt = "<system report / test"
        draw_update()
    end

    if phase == "L5" then
        mcdu_open_page(1301) -- open 1301 system report / test
    end
end

mcdu_sim_page[1301] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = " system report / test"

        mcdu_dat["l"]["L"][1].txt = "<dmc"
        draw_update()
    end

    if phase == "L1" then
        mcdu_open_page(1302) -- open 1302 DMC test
    end
end

mcdu_sim_page[1302] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "       dmc test"

        mcdu_dat["l"]["L"][1].txt = "<dmc 1 perform test"
        mcdu_dat["l"]["L"][2].txt = "<dmc 2 perform test"
        mcdu_dat["l"]["L"][3].txt = "<dmc 3 perform test"
        draw_update()
    end

    if phase == "L1" then
        sasl.commandOnce(MCDU_DMC_cmd_test_1)
        mcdu_open_page(1303) -- open 1303 DMC 1 test
    end
    if phase == "L2" then
        sasl.commandOnce(MCDU_DMC_cmd_test_2)
        mcdu_open_page(1303) -- open 1304 DMC 2 test
    end
    if phase == "L3" then
        sasl.commandOnce(MCDU_DMC_cmd_test_3)
        mcdu_open_page(1303) -- open 1305 DMC 3 test
    end
end

mcdu_sim_page[1303] =
function (phase)
    if phase == "render" then
        mcdu_dat_title.txt = "       dmc test"

        mcdu_dat["l"]["L"][1].txt = "dmc " .. get(DMC_which_test_in_progress)
        mcdu_dat["l"]["L"][2] = {txt="test in progress", col="green"}
        mcdu_dat["l"]["L"][3] = {txt="please wait", col="green"}
        draw_update()
    end
end


-- END OF MCDU CODE
-- END OF MCDU CODE
-- END OF MCDU CODE

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- EMULATOR SHELL CODE CONTINUED (II of II)
--    Simulates SASL running on a lua intrepreter (or https://repl.it)
--    instead of booting up X-Plane everytime you want to run this.

if EMULATOR then
    -- initialize all global variables which would otherwise be done by other parts of the script
	Mcdu_enabled = "Mcdu_enabled"
	mcdu_page = "mcdu_page"
	mcdu_debug_busy = "mcdu_debug_busy"
	TIME = "time"
	DELTA_TIME = "delta_time"
	Engine_option = "Engine_option"
	set(Mcdu_enabled, 1)
	set(mcdu_page, 0)
	set(TIME, 1)
	set(DELTA_TIME, 0)
	set(Engine_option, 0)

	print("")
	print(EMULATOR_HEADER .. "Initalization done!")
	if EMULATOR_PROMPT_BEFORE_RUN then
		print("")
		print("PRESS ENTER TO RUN.")
		s = io.read("*l")
	end
	os.execute("clear")
	found_command = true
	while true do
		os.execute("clear")
		set(TIME, get(TIME) + 1)
		
		print()
		if not found_command then
			print(EMULATOR_HEADER .. "COMMAND NOT FOUND")
		end

		update()
		draw()

		print()
		print()
		print()

		chars = {}
		for i = 0,14,1 do -- columns
			chars[i] = "                        "
		end

		color_codes = {} -- colour codes, which are inserted later into the text

		--draw all horizontal lines
        for i,line in ipairs(draw_lines) do
			str = line.disp_text
			color = line.disp_color

			x = math.floor(((line.disp_x - 20) / 520) + 1.1)
			y = math.floor(14.1 -((line.disp_y - 31.7) / 35.3))

			if x == 2 then
				x = 25 - #str
			end

			if line.disp_color == MCDU_DISP_COLOR["cyan"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[1;36m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end
			if line.disp_color == MCDU_DISP_COLOR["green"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[1;32m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end
			if line.disp_color == MCDU_DISP_COLOR["amber"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[1;33m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end
			if line.disp_color == MCDU_DISP_COLOR["yellow"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[0;33m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end
			if line.disp_color == MCDU_DISP_COLOR["magenta"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[1;35m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end
			if line.disp_color == MCDU_DISP_COLOR["red"] then
				table.insert(color_codes, {x = x, y = y, word = "\27[1;31m"})
				table.insert(color_codes, {x = x + #str + 1, y = y, word = "\27[0m"})
			end

			for i = 1, 24, 1 do
				j = i - x + 1-- i relative to str
				if j < 1 then
					 j = 999
				end
				if string.sub(str,j,j) ~= " " then
					chars[y] = string.sub(chars[y], 1, i) .. string.sub(str, j, j) .. string.sub(chars[y], i+1, #chars[y])
				end
			end
        end 

		for k = 1, #color_codes, 1 do
			spec = color_codes[k]
			i = 1
			j = 1
			while i <= spec.x do
				if string.sub(chars[spec.y], j, j) == "\27" then
					j = j + 7
				end
				--print(string.sub(chars[spec.y], j, j) .. " " .. i)
				j = j + 1
				i = i + 1
			end 
			j = j - 1
			chars[spec.y] = string.sub(chars[spec.y], 1, j-1) .. spec.word .. string.sub(chars[spec.y], j, #chars[spec.y])
		end

		chars[14] = mcdu_entry

		for i = 1,14,1 do -- columns
			if (math.fmod((i+1)*0.5,1) == 0) then
				out_line = (i - 1) / 2
			else
				out_line = " "
			end
			print(out_line .. "|" .. chars[i] .. "")
		end

		print()
		print()
		print()

		print("List of commands:")
		print("  a321neo/cockpit/mcdu/key <-- to enter key mode")
		print("  a321neo/cockpit/mcdu/side/L1 <-- side keys: L1-L6, R1-R6")

		for i = 1, #commands, 1 do
			if string.sub(commands[i].name,0,24) ~= "a321neo/cockpit/mcdu/key" and
			   string.sub(commands[i].name,0,25) ~= "a321neo/cockpit/mcdu/side" then
				print("  " .. commands[i].name)
			end
		end

		print()
		print("\27[101;93mSCROLL UP TO FIND THE MCDU\27[0m")

		print()
		print("Please enter a command name.")
		io.write("	a321neo/cockpit/mcdu/")
		user_command = io.read("*l")
		
		if user_command == "key" then --enter keymode
			print("Please enter mcdu entry")
			user_entry = io.read("*l")
			mcdu_entry = string.upper(user_entry)
		end

		found_command = false
		for i = 1, #commands, 1 do
			if string.sub(commands[i].name,22,-1) == user_command then
				commands[i].ref(SASL_COMMAND_BEGIN) -- call the command
				found_command = true
			end
		end
	end
end
-- END OF EMULATOR SHELL CODE II OF II (CONTINUED AT END OF SCRIPT)
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

