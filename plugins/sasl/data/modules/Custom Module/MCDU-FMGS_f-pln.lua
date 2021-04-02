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
-- File: FMGS_f-pln.lua 
-- Short description: Flight Management and planning implementation
--                    This is a helper file used by FMGS.lua
-------------------------------------------------------------------------------

fmgs_dat["fpln"] = {}
fmgs_dat["fpln fmt"] = {}

function fpln_waypoint(navtype, loc, via, name, dist, time, spd, alt, efob, windspd, windhdg, nextname)
    wpt = {}
    wpt.name = name or ""
    wpt.navtype = navtype or ""
    wpt.dist = dist or 0
    wpt.time = time or -1
    wpt.spd = spd or -1
    wpt.alt = alt or -1
    wpt.via = via or ""
    wpt.nextname = nextname or ""
    wpt.efob = efob or -1
    wpt.windspd = windspd or -1
    wpt.windhdg = windhdg or -1
    return wpt
end

pointer = 1

function fpln_pointto_wpt(wptname)
    i = 1
    while i <= #fmgs_dat["fpln"] do
        if fmgs_dat["fpln"][i].name == wptname then
            pointer = i + 1
            print("pointed at " .. i)
            return i
        end
        i = i + 1
    end
    print("NOT FOUND " .. wptname)
    return 1
    -- not found
end

function fpln_offset_pointer(val)
    pointer = pointer + val
end

function fpln_add_wpt(wpt, loc)
    if loc then
        table.insert(fmgs_dat["fpln"], loc, wpt)
    else
        table.insert(fmgs_dat["fpln"], pointer, wpt)
        pointer = pointer + 1
    end
end

--formats the fpln
function fpln_format()
    fpln_fmt = {}
    fpln = fmgs_dat["fpln"]

    --init previous waypoint
    wpt_prev = {}
    if #fpln > 0 then
        wpt_prev = {nextname = fpln[1].name}
    end

    for i,wpt in ipairs(fpln) do
        --is waypoint a blank?
        if wpt.name ~= "" then
            --is waypoint repeated?
            if wpt_prev.name ~= wpt.name then
                --check for flight discontinuities
                if wpt_prev.nextname ~= wpt.name then
                    print(wpt_prev.name .. " " .. wpt_prev.nextname .. " " .. wpt.name .. " " .. wpt.nextname)
                    table.insert(fpln_fmt, "---f-pln discontinuity--")
                end
                --insert waypoint
                table.insert(fpln_fmt, wpt)
            else
                --repeated, therefore omit it
                --prevent discons
                if fpln[i + 1] ~= nil then
                    wpt.nextname = fpln[i + 1].name
                end
            end
            --set previous waypoint
            wpt_prev = wpt
        end
    end
    table.insert(fpln_fmt, "----- end of f-pln -----")
    table.insert(fpln_fmt, "----- no altn fpln -----")

    --output
    fmgs_dat["fpln fmt"] = fpln_fmt
end

function fpln_clearall()
    fmgs_dat["fpln"] = {}
    fmgs_dat["fpln fmt"] = {}

    pointer = 1

    fmgs_dat["fpln latrev dept mode"] = "runway"
    fmgs_dat["fpln latrev dept runway"] = ""
    fmgs_dat["fpln latrev dept sid"] = ""
    fmgs_dat["fpln latrev dept trans"] = ""

    fmgs_dat["fpln latrev arr mode"] = "appr"
    fmgs_dat["fpln latrev arr appr"] = ""
    fmgs_dat["fpln latrev arr star"] = ""
    fmgs_dat["fpln latrev arr via"] = ""
    fmgs_dat["fpln latrev arr trans"] = ""
end

function fpln_add_airports(origin, destination)
    fpln_add_wpt(fpln_waypoint(NAV_AIRPORT, nil, nil, origin.id, nil, nil, nil, nil, nil, nil, nil))
    fpln_add_wpt(fpln_waypoint(NAV_AIRPORT, nil, nil, destination.id, nil, nil, nil, nil, nil, nil, nil))
end



--DEMO
--fpln_addwpt(NAV_FIX, 1, "chins3", "humpp", nil, 2341, 14, 297, 15000, nil, nil, nil, "aubrn")


