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

local COMMAND_MAP_NETWORK = "nmap-auto-wrapper &"
local COMMAND_SCAN_HOST = "nmap-auto-scanner "
local COMMAND_EXPLOIT_AUTO = "exploit-auto-select"

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

function arrayfy_by_slash(input)
    --This turns the output of a command into a table by splitting it along the
    --newlines.
    local sep = "\/;"
    local t = {};
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        if string.match(str,"\*") then
        else
        table.insert(t, str)
        end
    end
    return t
end

function arrayfy_by_semicolon(input)
    --This turns the output of a command into a table by splitting it along the
    --newlines.
    local sep = "\;"
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

function enumerate_potential_attacks(ip, port, svc)
    local result_exploits = sanitize_program_output(get_program_output(COMMAND_EXPLOIT_AUTO .. " " .. ip .. " " .. port .. " " .. svc .. " &"))
    local result_array = arrayfy_by_semicolon(result_exploits)
    return result_array
end

function scan_a_host(ip)
    local result = sanitize_program_output(get_program_output(COMMAND_SCAN_HOST .. ip .. " &"))
    local result_array = arrayfy_by_semicolon(result)
    return result_array
end

function generate_widget_map()
	local attached_hosts = {}
	local count = 0
	for key, host in pairs(get_nearby_hosts()) do
		w = arrayfy_by_whitespace(host)
		work = {}
		if w[1] ~= nil then
			local scan_results = scan_a_host(w[1])
			if scan_results ~= nil then
				local servcount = 0
				for ky, service in pairs(scan_results) do
				    if service ~= nil then
					p = arrayfy_by_whitespace(service)
					q = {}
					if p[1] ~= nil then
						q = arrayfy_by_slash(p[1])
					end
					l = nil
					m = {}
					if q[1] ~= nil then
						l = enumerate_potential_attacks(w[1], q[1], p[3])
						if l ~= nil then
							for k, v in pairs(l) do
								c = arrayfy_by_whitespace(v)
								if c[3] ~= nil then
									table.insert(m, { c[1] , c[3] .. " " .. c[2] } )
								end
--								l = terminal .. COMMAND_EXPLOIT_AUTO .. w[1] .. " " .. q[1] .. " " .. q[2]
							end
						end
					end
					if m[1] ~= nil then
						a = "Attack service at " .. w[1] .. ":" .. q[1] .. " [" .. p[3] .. "]"
						table.insert( work, { service , {{ a , m }} } )
					else
						a = "No Attacks Available for Service"
						l = terminal .. " ping " .. w[1]
						table.insert( work, { service , {{ a , l }} } )
					end
				    end
				    servcount = servcount + 1
				end
				table.remove(work, servcount)
				device = { host, work }
				table.insert( attached_hosts, device )
			end
		else
			work = terminal .. " ping -c 1 duckduckgo.com"
		end
		count = count + 1
	end
	table.remove(attached_hosts, count)
	return attached_hosts
end
