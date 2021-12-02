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

-- Adapted from: https://aviation.stackexchange.com/a/77300/12643

local ms_per_kt = 0.51444
local feet_per_metre = 3.28
local T_0C = 273.15   -- 0 degrees C in Kelvin


local g=9.81          -- Acceleration due to gravity
local R=287           -- Specific gas constant for air
local L=0.0065        -- Lapse rate in K/m
local T0 = 288.15     -- ISA sea level temp in K
local p0 = 101325     -- ISA sea level pressure in Pa
local k = 1.4         -- k is a shorthand for Gamma, the ratio of specific heats for air
local lss0 = math.sqrt(k*R*T0) -- ISA sea level speed sound
local rho0 = 1.225    -- ISA sea level density in Kg/m3

local function kt(m)
    return m/ms_per_kt
end

-- Return pressure ratio given a Mach number and static pressure,
-- assuming compressible flow
local function compressible_pitot(M)
    return (M*M*(k-1)/2 + 1) ^ (k/(k-1)) - 1
end

-- Return Mach number, given a pressure ratio d=p_d/p_s
local function pitot_to_Mach(d)
    return math.sqrt(((d+1)^((k-1)/k) - 1)*2/(k-1))
end

-- Given an altitude h, return the temperature, assuming we're
-- using the International Standard Atmosphere and are flying
-- in the troposphere.
local function temperature(h)
    return T0 - h*L
end

-- Given an altitude h, return the local spead of sound, assuming
-- we're using the International Standard Atmosphere and are flying
-- in the troposphere.
local function lss(h)
    return math.sqrt(k*R*temperature(h))
end

-- Given an altitude h, return the pressure, assuming we're
-- using the International Standard Atmosphere and are flying
-- in the troposphere.
local function pressure(h)
    return p0 * (temperature(h) / T0) ^ (g / L / R)
end

-- Given an altitude h, return the density, assuming we're
-- using the International Standard Atmosphere and are flying
-- in the troposphere.
local function density(h)
    return pressure(h) / (R * temperature(h))
end

function convert_to_eas_tas_mach(cas, alt)
    cas = cas * ms_per_kt
    alt = alt / feet_per_metre

    local ps = pressure(alt)
    local lss = lss(alt)
    local oat = temperature(alt)
    local rho = density(alt)
    local pd = compressible_pitot(cas/lss0) * p0

    local M = pitot_to_Mach(pd / ps)
    local eas = lss0 * M * math.sqrt(ps/p0)
    local tas = lss * M

    return kt(eas), kt(tas), M
end

function m_to_nm(m)
    return m * 0.000539957;
end

function nm_to_m(nm)
    return nm * 1852;
end

function kts_to_ms(kts)
    return kts * 0.514444
end