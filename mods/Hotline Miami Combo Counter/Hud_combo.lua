Hooks:PostHook(HUDObjectives, "init", "ComboInit", function(self, hud, ...)
	local font = "fonts/font_digital"
	if not managers.dyn_resource:has_resource(Idstring("font"), Idstring(font), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("font"), Idstring(font), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
	end
	self._full_hud_panel = managers.hud._fullscreen_workspace:panel():gui(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2, {})

	self.Combo_panel = self._full_hud_panel:panel( {
		visible = false, 
		name = "Combo_panel",
		x = 0,
		y = 0,
		h = 256, 
		w = 512,
		valign = "top", 
		blend_mode = "normal"
	})
	local Combo_text = self.Combo_panel:text( {
		name = "Combo_text",
		visible = true, 
		layer = 2, 
		color = Color(226/255, 8/255, 124/255),
		text = "0", 
		font_size = 96,
		font = "fonts/font_digital",
		x = 6, 
		y = 0, 
		align = "left",
		vertical = "top"
	}) 
	local Combo_text_bg = self.Combo_panel:text( {
		name = "Combo_text_bg",
		visible = true, 
		layer = 1, 
		color = Color.black,
		text="0", 
		font_size = 96  ,
		font = "fonts/font_digital",
		x = 8, 
		y = 1, 
		align = "left",
		vertical = "top"
	})	
	local Combo_bg = self.Combo_panel:bitmap( {
		name = "Combo_bg",
		visible = true, 
		layer = 0, 
		texture = "assets/guis/textures/bg",
		x = 8, 
		w = 200,
		h = 64,
		vertical = "top"
	})
	self.Combo_panel:set_top(40)
	Combo_bg:set_left(self._full_hud_panel:left())
	Combo_bg:set_top(40 + 5)	
	Combo_bg:set_left(self._full_hud_panel:left())
end)

function HUDObjectives:set_combo(combo)
	local Combo_text = self.Combo_panel:child("Combo_text")
	local Combo_text_bg = self.Combo_panel:child("Combo_text_bg")
	local Combo_bg = self.Combo_panel:child("Combo_bg")
	if combo > 1 then 
		self.Combo_panel:set_visible(true)  
	else
		self.Combo_panel:set_visible(false)
	end
	if combo .. "x" ~= Combo_text:text() and combo ~= 0 then
		Combo_text:set_text(combo.."x")
		Combo_text_bg:set_text(combo.."x")
	    if combo == 2 then
		    Combo_text:animate(callback(self, self, "open_anim"))
	        Combo_text_bg:animate(callback(self, self, "open_anim"))	
	    end
	    
		if combo > 9 then
            Combo_bg:set_w(240)
	    end	
	    
		if combo > 99 then 
            Combo_bg:set_w(310)
	    end
	end
end

function HUDObjectives:open_anim( panel )
    local speed = 50
	panel:set_x( - 150 )
	panel:set_visible( true )
	local TOTAL_T = 10/speed
	local t = TOTAL_T
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		panel:set_x((1 - t/TOTAL_T) * 60 )
	end
end