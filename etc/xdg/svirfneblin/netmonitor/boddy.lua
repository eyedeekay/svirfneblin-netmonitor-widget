local io = io
local math = math
local naughty = require("naughty")
local beautiful = require("beautiful")
local tonumber = tonumber
local tostring = tostring
local print = print
local pairs = pairs
local string = require("string")
local table = require("table")

local COMMAND_MAP_NETWORK = "nmap-auto-wrapper"
local COMMAND_SCAN_HOST = "nmap-auto-scanner"

module("netmntr")

terminal = "x-terminal-emulator"

function get_program_output(const)
    local handle = io.popen(const)
    local result = handle:read('*all')
    handle:close()
    return result
end

function sanitize_program_output(input)
    --This function doesn't do anything yet, but I'd hate to neglect it if it's
    --necessary, so I'm putting it here at the top and since I'm sure I won't
    --finish this tonight while I'm playing monopoly and drinking heavily, aka
    --saying yes to life, then I'll revisit it when I get the chance.
    return input
end

function arrayfy_by_whitespace(input)
    --This turns the output of a command into a table by splitting it along the
    --whitespace.
    local t = {};
    for str in input:gmatch("%S+") do
        table.insert(t, str)
    end
    return t
end

function arrayfy_by_semicolon(input)
    --This turns the output of a command into a table by splitting it along the
    --newlines.
    local sep = ";"
    local t = {};
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        if string.match(str,"\*") then
        else
        table.insert(t, str)
        end
    end
    return t
end

function get_nearby_hosts()
    --Make a table of the local interfaces
    local result_nmapped = sanitize_program_output(get_program_output(COMMAND_MAP_NETWORK))
    local result_array = arrayfy_by_semicolon(result_nmapped)
    return result_array
end

function generate_widget_map(){
	local attached_hosts = {}
	for key, host in pairs(get_nearby_hosts()) do
		w = arrayfy_by_whitespace(host)
		work = "ping -c 1 " .. w[1]
		table.insert(attached_hosts, work)
	end
}
