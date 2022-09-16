if not _G.HMHCC then
    _G.HMHCC = {}
    HMHCC._path = ModPath
    HMHCC._data_path = SavePath .. "HMHCC.txt"
    HMHCC._data = {} 

    function HMHCC:Save()
	    local file = io.open( self._data_path, "w+" )
	    if file then
	    	file:write( json.encode( self._data ) )
	    	file:close()
    	end
    end

    function HMHCC:Load()
    	local file = io.open( self._data_path, "r" )
    	if file then
    		self._data = json.decode( file:read("*all") )
    		file:close()
    	end
    end

    function HMHCC:GetOption(id)
	    return self._data[id]
    end
	
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_Combo", function( loc )
		local localization = HMHCC._path .. "loc/"
		local GetFiles = _G.file.GetFiles
		local Idstring = _G.Idstring
		local activelanguagekey = SystemInfo:language():key()
		for __, filename in ipairs(GetFiles(localization)) do
			if Idstring(filename:match("^(.*).json$") or ""):key() == activelanguagekey then
				loc:load_localization_file(localization .. filename)
				break
			end
		end
		loc:load_localization_file(localization .. "english.json", false)
	end)

    Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_Combo", function( menu_manager )
		MenuCallbackHandler.callback_kill_anim = function(self, item)
    		HMHCC._data.kill_anim = (item:value() == "on" and true or false)
    		HMHCC:Save()
    	end
		MenuCallbackHandler.callback_panel_position = function(self, item)
            HMHCC._data.panel_position = item:value()
		    HMHCC:Save()
        end
	    HMHCC:Load()
	    MenuHelper:LoadFromJsonFile( HMHCC._path .. "options/options.json", HMHCC, HMHCC._data )
    end )
end