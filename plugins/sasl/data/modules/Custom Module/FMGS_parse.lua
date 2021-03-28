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
-- File: FMGS_parse.lua 
-- Short description: Read and parses FMGS data 
--                    This is a helper file used by FMGS.lua
-------------------------------------------------------------------------------

include('libs/geo-helpers.lua')

--[[
--
--
--      FORMATTING
--
--
--]]

function char_at(str, index)
	return string.sub(str, index, index)
end



-- converts appr airbus format to xplane appr
-- e.g. RNV16LZ to R16LZ
function appr_airbus_to_xp_appr(appr)
	if string.sub(appr, 1, 3) == "ILS" or
	   string.sub(appr, 1, 3) == "RNV" or
	   string.sub(appr, 1, 3) == "VOR" or
	   string.sub(appr, 1, 3) == "NDB"
	then
        prefix = string.sub(appr, 1, 1)
	    if string.sub(appr, 1, 3) == "VOR" then
            prefix = "D"
        end
	    if string.sub(appr, 1, 3) == "NDB" then
           prefix = "Q"
        end
		runway = prefix .. string.sub(appr, 4, 7)
	elseif string.sub(appr, 1, 2) == "RW" then
		return nil
	end
	return runway
end

-- converts appr airbus format to xplane rwy
-- e.g. RNV16LZ to RW16B
function appr_airbus_to_xp_rwy(appr)
	-- get runway numbers
	if string.sub(appr, 1, 3) == "ILS" or
	   string.sub(appr, 1, 3) == "RNV" or
	   string.sub(appr, 1, 3) == "VOR" or
	   string.sub(appr, 1, 3) == "NDB"
	then
		runway = string.sub(appr, 4, 6)
	elseif string.sub(appr, 1, 2) == "RW" then
		runway = string.sub(appr, 3, 5)
	end
    print(runway)
    if string.sub(runway, 3, 3) == "L" or
       string.sub(runway, 3, 3) == "C" or
       string.sub(runway, 3, 3) == "R"
       then
        runway = string.sub(runway, 1, 2) .. "B"
    end
    runway = "RW" .. runway
	return runway
end



--[[
--
--
--      LINE PARSER
--
--
--]]

-- Line will parse a row of data into a struct
Line = {row = "", sep_char = ""}
Line.__index = Line

-- row parser class constructor
function Line:new(row, sep_char)
   	local o = {}             -- our new object
  	setmetatable(o, self)  -- make Account handle lookup
  	o.row = row      -- initialize our object
	o.sep_char = sep_char
	return o
end

-- read column from row of data
function Line:get_column(col_index)
	i = 1
	col = 0
	while col < col_index - 1 do
		-- detect for end
		if char_at(self.row, i) == "" then
			return nil
		end
		if char_at(self.row, i) == self.sep_char or char_at(self.row, i) == ";" then
			-- prevent doubles
			if char_at(self.row, i + 1) ~= self.sep_char then
				col = col + 1
			end
		end
		i = i + 1
	end
	j = i
	while char_at(self.row, j) ~= self.sep_char and char_at(self.row, i) ~= ";" and j < string.len(self.row) do
		j = j + 1
	end
	return string.sub(self.row, i, j - 1)
end



--[[
--
--
--      PARSER - CIFP
--
--
--]]

-- Parser_Cifp will parse CIFP files for an airport
Parser_Cifp = {data = "", parsed_data = {}}
Parser_Cifp.__index = Parser_Cifp

-- parser class constructor
function Parser_Cifp:new(filename)
	file = io.open(filename, "r")
	data = file:read("*all")

  	local o = {}             -- our new object
   	setmetatable(o, self)  -- make Account handle lookup
   	o.data = data      -- initialize our object
    o.parsed_data = {}

	-- parses all columns from row of data
	i = 1
	j = 1
	col = 0
	while j < #data do
		while char_at(data, j) ~= ";" and j < #data do
			j = j + 1
		end
		
		j = j + 1
		line = Line:new(string.sub(data, i, j - 1), ",")
		table.insert(o.parsed_data, line)
		i = j + 1
	end

	return o
end

function Parser_Cifp:get_runways()
	output = {}
	for _, pd in ipairs(self.parsed_data) do
		if string.sub(pd:get_column(1), 1, 3) == "RWY" then
			table.insert(output, string.sub(pd:get_column(1), 5, 9))
		end
	end
	return output
end

function Parser_Cifp:get_approaches()
	output = {}
	for _, pd in ipairs(self.parsed_data) do
		last_word = ""
		if string.sub(pd:get_column(1), 1, 5) == "APPCH" then
			word = pd:get_column(3)
			-- replace prefixes with airbus ones
			if string.sub(word, 1, 1) == "I" then
				word = "ILS" .. string.sub(word, 2, -1)
			end
			if string.sub(word, 1, 1) == "R" then
				word = "RNV" .. string.sub(word, 2, -1)
			end
			if string.sub(word, 1, 1) == "D" then
				word = "VOR" .. string.sub(word, 2, -1)
			end
			if string.sub(word, 1, 1) == "Q" then
				word = "NDB" .. string.sub(word, 2, -1)
			end

			pass = true
			-- don't repeatedly insert names
			for _,i in ipairs(output) do
				if word == i then
					pass = false
				end
			end
			if pass then
				table.insert(output, word)
			end
		end
	end
	-- add all runways at the end
	output_b = output
	runways = self:get_runways()
	output = output_b
	for i = 1, #runways, 1 do
		table.insert(output, runways[i])
	end
	return output
end

function Parser_Cifp:get_sids(runway)
	output = {"no sid"}
	for _, pd in ipairs(self.parsed_data) do
		if pd:get_column(1) == "SID:010" and
		   pd:get_column(4) == runway
		   then
			table.insert(output, pd:get_column(3))
		end
	end
	return output
end

function Parser_Cifp:get_stars(appr)
	appr = appr_airbus_to_xp_rwy(appr)
    print(">" .. appr .. "<")
	output = {"no star"}
	for _, pd in ipairs(self.parsed_data) do
		if pd:get_column(1) == "STAR:010" and
		   pd:get_column(4) == runway
		   then
			table.insert(output, pd:get_column(3))
		end
	end
	return output
end

function Parser_Cifp:get_vias(appr)
	appr = appr_airbus_to_xp_appr(appr)
	output = {"no via"}
	-- convert appr from airbus to xplane format
	for _, pd in ipairs(self.parsed_data) do
		if pd:get_column(1) == "APPCH:010" and
		   pd:get_column(3) == runway and
		   pd:get_column(2) == "A"
		   then
			table.insert(output, pd:get_column(4))
		end
	end
	return output
end

function Parser_Cifp:get_trans(proc_type, proc, runway)
	output = {"none"}
	for _, pd in ipairs(self.parsed_data) do
		if proc_type == "SID" then
			correct_type = (
				pd:get_column(2) == "6" or --SID Enroute Transition
				pd:get_column(2) == "3" --RNAV SID Enroute Transition
			)
		elseif proc_type == "STAR" then
			correct_type = (
				pd:get_column(2) == "1" --STAR Enroute Transition
			)
		end
		if pd:get_column(1) == proc_type .. ":010" and
			correct_type and
			pd:get_column(3) == proc
		   then
			table.insert(output, pd:get_column(4))
		end
	end
	return output
end

function Parser_Cifp:get_procedure(proc_type, proc, runway)
	output = {}
	num = 1
	
	found = true
	while found do
		found = false
		for _, pd in ipairs(self.parsed_data) do
			wpt_info = pd:get_column(1)
			j = 1
			while char_at(wpt_info, j) ~= ":" and j < string.len(wpt_info) do 
				j = j + 1
			end

			wpt_type = string.sub(wpt_info, 1, j - 1)
			wpt_num = string.sub(wpt_info, j + 1, -1)
			if wpt_type == proc_type and
			wpt_num == "0" .. tostring(num) .. "0" and
			pd:get_column(3) == proc and
			pd:get_column(4) == runway
				then
				found = true
                wpt_name = pd:get_column(5)
                wpt_alt = 0
                wpt_via = 0
				
				if pd:get_column(5) == " " then
                    wpt_via = "h" .. tostring(tonumber(pd:get_column(21)) / 10) .. "º"
					print("\tHeading " .. tonumber(pd:get_column(21)) / 10 .. "deg")
					if pd:get_column(23) == "+" then
                        wpt_name = "(" .. pd:get_column(24) .. ")Δ"
						print("\tAbove alt " .. tonumber(pd:get_column(24)) .. "ft")
					elseif pd:get_column(24) == "-" then
                        wpt_name = "(" .. pd:get_column(24) .. ")Δ"
						print("\tBelow alt " .. tonumber(pd:get_column(24)) .. "ft")
					end
				end
				
				if string.sub(pd:get_column(9), 2, 2) == "Y" then
                    wpt_name = wpt_name .. "Δ"
				end

				print()
				if pd:get_column(12) == "VI" then
                    wpt_name = wpt_name .. "Δ"
				end
				if pd:get_column(12) == "VM" then
                    wpt_name = "MANUAL"
				end

				table.insert(output, fpln_waypoint(NAV_FIX, nil, wpt_via, wpt_name, nil, nil, nil, wpt_alt))
				if string.sub(pd:get_column(9), 2, 2) == "E" then
					print("end of procedure")
                    -- remove discontinuities 
                    for no,wpt in ipairs(output) do
                        nextwpt = output[no + 1] or {name = ""}
                        wpt.nextname = nextwpt.name
                        print(wpt.name .. " " .. nextwpt.name)
                    end
					return output
				end
			end
			
		end
		num = num + 1
	end
    -- remove discontinuities 
    for no,wpt in ipairs(output) do
        nextwpt = output[no] or {name = ""}
        wpt.nextname = nextwpt.name
    end
	return output
end


function Parser_Cifp:get_departure(rwy, proc, trans)
    proc_type = "SID"
	print()
	print("SID Procedure:")
	proc_1 = parser:get_procedure(proc_type, proc, rwy)
	print("Transition Procedure:")
	proc_2 = parser:get_procedure(proc_type, proc, trans)
    for no, wpt in ipairs(proc_2) do
        if no ~= 1 then
            table.insert(proc_1, wpt)
        end
    end
    return proc_1
end

function Parser_Cifp:get_arrival(appr, via, proc, trans)
    proc_type = "STAR"
	print()
	print("Transition Procedure:")
	proc_1 = parser:get_procedure(proc_type, proc, trans)
	print("Common Route:")
	proc_2 = parser:get_procedure(proc_type, proc, " ")
    for _,wpt in ipairs(proc_2) do
        table.insert(proc_1, wpt)
    end
	print("STAR Procedure:")
	proc_3 = parser:get_procedure(proc_type, proc, appr_airbus_to_xp_rwy(appr))
    for _,wpt in ipairs(proc_3) do
        print(wpt.name .. " " .. wpt.nextname)
        table.insert(proc_1, wpt)
    end
    for _, wpt in ipairs(proc_1) do
        print(wpt.name .. " " .. wpt.nextname)
    end
	print("Via Procedure:")
	proc_4 = parser:get_procedure("APPCH", appr_airbus_to_xp_appr(appr), via)
    for _,wpt in ipairs(proc_4) do
        table.insert(proc_1, wpt)
    end
	print("Approach Procedure:")
	proc_5 = parser:get_procedure("APPCH", appr_airbus_to_xp_appr(appr), " ")
    for _,wpt in ipairs(proc_5) do
        table.insert(proc_1, wpt)
    end
    return proc_1
end



--[[
--
--
--      PARSER - AIRPORT
--
--
--]]

--AIRPORT_LUT_PATH = sasl.getAircraftPath() .. "/data/fmgs_airport_lut.dat"

AIRPORT_LUT = {}
init_airport_lut = false

-- Parser_Apt will parse apt.dat for airport data
Parser_Apt = {file = {}, data = "", parsed_data = {}}
Parser_Apt.__index = Parser_Apt

-- parser class constructor
function Parser_Apt:new(filename)
	file = io.open(filename, "r")

   	local o = {}             -- our new object
   	setmetatable(o, self)  -- make Account handle lookup
	o.file = file
	return o
end

-- creates a Look Up Table (LUT) for all the airports and their positions for easier reference
function Parser_Apt:create_airport_lut()
    line = Line:new("", "")
    --print(AIRPORT_LUT_PATH)
    --lut_file = io.open(AIRPORT_LUT_PATH, "w")
    while true do
        -- find a code 1
        read_line = ""
        while string.sub(read_line, 1, 2) ~= "1 " do -- find a "1" code or "99" terminate
            read_line = file:read() or "EOF"
            if read_line == "EOF" then -- end of file
                init_airport_lut = true
                return
            end
        end
        -- find the airport name in that line
        line = Line:new(read_line, " ")
        airport_name = line:get_column(5)
        if airport_name ~= nil then
            AIRPORT_LUT[airport_name] = file:seek()
        end
        --lut_file:write(airport_name .. " " .. file:seek() .. "\n")
    end
end

function Parser_Apt:load_airport_lut()
    -- TODO: needs to be loaded again, else defeats the purpose of keeping data cached
end

-- gets runway length of an airport IN METRES
function Parser_Apt:get_runway_lengths(airport)
	-- runway length is calculated by finding the distance between the end of the runway and the opposite runway (e.g. end of 16L and 34R will get you the distance)
	lat_rwy = 0
	lon_rwy = 0
	lat_rwyopp = 0
	lon_rwyopp = 0

    print("runways")

    -- find the airport (code 1)
    if init_airport_lut then
        if not AIRPORT_LUT[airport] then
            return "NOT FOUND" -- should never be returned like this, but safer.
        end

        file:seek("set", AIRPORT_LUT[airport])
    else
        line = Line:new("", "")
        while line:get_column(5) ~= airport do
            -- find a code 1
            read_line = ""
            while string.sub(read_line, 1, 2) ~= "1 " and read_line ~= "99" do -- find a "1" code
                read_line = file:read()
            end
            if read_line == "99" then
                return "NOT FOUND"
            end
            -- find the airport name in that line
            line = Line:new(read_line, " ")
        end
    end

	-- ok, found the airport. Now find the correct runway (code 100)

    output = {}
	-- find a code 100, repeat until found another airport or end of apt.dat (code 99)
	line = Line:new("", "")
	read_line = ""
    while string.sub(read_line, 1, 2) ~= "1 " and read_line ~= "99" do -- find a "1" code
		read_line = ""
		repeat
			read_line = file:read()
        until string.sub(read_line, 1, 4) == "100 " or -- find 100 code
              string.sub(read_line, 1, 2) == "1 " or -- a code 1
              read_line == "99" -- a code 99

        if string.sub(read_line, 1, 4) == "100 " then
            -- find the runway name in that line
            line = Line:new(read_line, " ")

            name_rwy = line:get_column(9)
            lat_rwy = line:get_column(10)
            lon_rwy = line:get_column(11)
            name_rwyopp = line:get_column(18)
            lat_rwyopp = line:get_column(19)
            lon_rwyopp = line:get_column(20)
            
            runway_length = GC_distance_kt(lat_rwy, lon_rwy, lat_rwyopp, lon_rwyopp) * 1852 -- convert nm to metres
            output[name_rwy] = runway_length
            print(name_rwy .. " " .. runway_length)
            output[name_rwyopp] = runway_length
        end
	end
    return output
end



--[[
--
--
--      FMGS SASL
--
--
--]]

--sasl get nav aid information
function fmgs_get_nav(find_nameid, find_type)
    --find by name
    id = sasl.findNavAid(find_nameid:upper(), nil, nil, nil, nil, find_type)
    --if name is not found
    if id == -1 then
        --find by id
        id = sasl.findNavAid(nil, find_nameid:upper(), nil, nil, nil, find_type) 
    end
    local nav = {}
    nav.navtype, nav.lat, nav.lon, nav.height, nav.freq, nav.hdg, nav.id, nav.name, nav.loadedDSF = sasl.getNavAidInfo(id)
    print("nav")
    print("type " .. nav.navtype)
    print("lat " .. nav.lat)
    print("lon " .. nav.lon)
    print("height " .. nav.height)
    print("freq " .. nav.freq)
    print("hdg " .. nav.hdg)
    print("id " .. nav.id)
    print("name " .. nav.name)
    return nav
end




-- DEMO 
-- DEMO 
-- DEMO 
--[[

-- get the runway length of an airport
Parser_Apt = Parser_Apt:new("cifp-parser/apt.dat")
print(math.floor(Parser_Apt:get_runway_length("KSEA", "34C")))



-- create a new parser, input first row of data (KSEA.dat)
parser = Parser_Cifp:new("cifp-parser/KSEA.dat")

proc_type = question("Choose a procedure type (Enter a number)", {"departure", "arrival"})

if proc_type == "departure" then
	proc_type = "SID"
	possible_proc_rwys = parser:get_runways()
	rwy = question("AVAILABLE RUNWAYS", possible_proc_rwys)

	possible_proc = parser:get_sids( rwy)
	proc = question("SIDS AVAILABLE", possible_proc)

	possible_trans = parser:get_trans(proc_type, proc, rwy)
	trans = question("AVAILABLE TRANS", possible_trans)

	parser:get_departure(rwy, proc, trans)
else
	proc_type = "STAR"
	possible_proc_rwys = parser:get_approaches()
	appr = question("APPRS AVAILABLE", possible_proc_rwys)

	possible_vias = parser:get_vias(appr)
	via = question("VIAS AVAILABLE", possible_vias)

	possible_proc = parser:get_stars(appr)
	proc = question("STARS AVAILABLE", possible_proc)

	possible_trans = parser:get_trans(proc_type, proc, appr)
	trans = question("AVAILABLE TRANS", possible_trans)

	parser:get_arrival(appr, via, proc, trans)
end
--]]


