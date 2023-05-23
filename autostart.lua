obs = obslua
filePath = ""
closeOnExit = false
arguments = ""

local ffi = require("ffi")

function get_file_name(file)
    return file:match("([^/\\]+)$")
end

function start_program()
    local file = filePath
    local args = arguments
    if file ~= nil and file ~= "" then
        if args ~= nil and args ~= "" then
            if ffi.os == "Windows" then
                os.execute(script_path().."/scripts/autostart.bat \""..file.."\" "..args)
            elseif ffi.os == "Linux" or ffi.os == "OSX" then
                os.execute(script_path().."/scripts/autostart.sh \""..file.."\" "..args)
            end
        else
            if ffi.os == "Windows" then
                os.execute(script_path().."/scripts/autostart.bat \""..file.."\" "..args)
            elseif ffi.os == "Linux" or ffi.os == "OSX" then
                os.execute(script_path().."/scripts/autostart.sh \""..file.."\" "..args)
            end
        end
    end
end

function script_description()
    return "Auto start a program with OBS. Works on Windows and should work on Linux and OSX (not tested)."
end

function script_load(settings)
    filePath = obs.obs_data_get_string(settings, "file")
    arguments = obs.obs_data_get_string(settings, "args")
    start_program()
end

function script_unload()
    if closeOnExit then 
        if filePath ~= nil and filePath ~= "" then
            local name = get_file_name(filePath)
            if ffi.os == "Windows" then
                os.execute(script_path().."/scripts/autokill.bat \""..name.."\"")
            elseif ffi.os == "Linux" or ffi.os == "OSX" then
                os.execute(script_path().."/scripts/autokill.sh \""..name.."\"")
            end
        end
    end
end

function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "close_on_unload", true)
end

function script_update(settings)
    filePath = obs.obs_data_get_string(settings, "file")
    closeOnExit = obs.obs_data_get_bool(settings, "close_on_unload")
    arguments = obs.obs_data_get_string(settings, "args");
end

function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_path(props, "file", "Program to launch", obs.OBS_PATH_FILE, "All files (*.*)", nil)
    obs.obs_properties_add_text(props, "args", "Arguments", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_bool(props, "close_on_unload", "Close the program on exit")
    obs.obs_properties_add_button(props, "start_now", "Start program", start_program)

    return props
end

