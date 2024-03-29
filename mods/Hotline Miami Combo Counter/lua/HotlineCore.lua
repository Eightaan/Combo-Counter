local kill_flash = true  -- Enable / Disable the flashing text when killin a new enemy

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "Combo_setup_player_info_hud_pd2", function(self, ...)
    self._hud_combo_counter = HUDComboCounter:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
    self:add_updator("HHM_CC_Updater", callback(self._hud_combo_counter, self._hud_combo_counter, "update"))
end)

function HUDManager:HMHCC_OnKillshot()
    self._hud_combo_counter:OnKillshot()
end

HUDComboCounter = HUDComboCounter or class()
function HUDComboCounter:init(hud)
    self._t = 0
    self._kill_time = 0
    self._last_kill_time = 0
    self._kills = 0
    local font = "fonts/hmcc_font"
    if not managers.dyn_resource:has_resource(Idstring("font"), Idstring(font), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
        managers.dyn_resource:load(Idstring("font"), Idstring(font), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
    end
    self._hud_panel = hud.panel
    self._full_hud_panel = managers.hud._fullscreen_workspace:panel():gui(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2, {})
    self._combo_panel = self._full_hud_panel:panel({
        visible = false,
        name = "combo_panel",
        x = 0,
        y = 0,
        h = 256,
        w = 512,
        valign = "top",
        blend_mode = "normal"
    })
    self._combo_panel:set_top(40)
    local Combo_text = self._combo_panel:text({
        name = "Combo_text",
        visible = true,
        layer = 2,
        color = Color("e2087c"),
        text = "0",
        font_size = 96,
        font = "fonts/hmcc_font",
        x = 6,
        y = 0,
        align = "left",
        vertical = "top"
    })
    local Combo_text_bg = self._combo_panel:text({
        name = "Combo_text_bg",
        visible = true,
        layer = 1,
        color = Color.black,
        text="0",
        font_size = 96,
        font = "fonts/hmcc_font",
        x = 8,
        y = 1,
        align = "left",
        vertical = "top"
    })
    local Combo_bg = self._combo_panel:bitmap({
        name = "Combo_bg",
        visible = true,
        layer = 0,
        texture = "guis/textures/hmcc_bg",
        x = 8,
        w = 200,
        h = 64,
        vertical = "top"
    })
    Combo_bg:set_left(self._full_hud_panel:left())
    Combo_bg:set_top(40 + 5)
end

function HUDComboCounter:set_combo(combo)
    local Combo_text = self._combo_panel:child("Combo_text")
    local Combo_text_bg = self._combo_panel:child("Combo_text_bg")
    local Combo_bg = self._combo_panel:child("Combo_bg")
    if combo > 1 then 
		self._combo_panel:set_visible(true)  
	else
		Combo_text:animate(callback(self, self, "close_anim"))
		Combo_text_bg:animate(callback(self, self, "close_anim"))
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

function HUDComboCounter:open_anim(panel)
    local speed = 50
    panel:set_x(-150)
    local TOTAL_T = 10/speed
    local t = TOTAL_T
	local panel_position = HMHCC:GetOption("panel_position") or 40
    while t > 0 do
        local dt = coroutine.yield()
        t = t - dt
        panel:set_x((1 - t / TOTAL_T) * 60)
    end
	self._combo_panel:set_top(panel_position)
end


function HUDComboCounter:close_anim( panel )
	local Combo_text = self._combo_panel:child("Combo_text")
	local Combo_text_bg = self._combo_panel:child("Combo_text_bg")
	local speed = 2000
	local cw = panel:x()
	local TOTAL_T = cw/speed
	local t = TOTAL_T
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		panel:set_x((1 - t/TOTAL_T) * -80 )
	end
	self._combo_panel:set_visible(false) 
    self._combo_panel:set_x(0)
    Combo_text:set_x(6)
    Combo_text_bg:set_x(8)	
	Combo_text:animate(callback(self, self, "open_anim"))
    Combo_text_bg:animate(callback(self, self, "open_anim"))
end

function HUDComboCounter:kill_anim(panel)
	local Combo_text = self._combo_panel:child("Combo_text")
	local Combo_text_bg = self._combo_panel:child("Combo_text_bg")
	over(0.4 , function(p)
        local n = 1 - math.sin((p / 2 ) * 180)
        Combo_text:set_font_size(math.lerp(96, 96 + 125, n))
		Combo_text_bg:set_font_size(math.lerp(96, 96 + 125, n))
    end)
end


function HUDComboCounter:flash_text(text, config)
	local Combo_text_bg = self._combo_panel:child("Combo_text_bg")
	local TOTAL_T = 0.4
	local t = TOTAL_T
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		local cv = math.abs((math.sin(t * 180 * 16)))
		text:set_color(Color("e2087c") * cv + Color("e2087c") * cv)
	end
	text:set_color(Color("e2087c"))
end

function HUDComboCounter:OnKillshot()
    local Combo_text = self._combo_panel:child("Combo_text")
	local Combo_text_bg = self._combo_panel:child("Combo_text_bg")
    self._kills = self._kills + 1
    self._last_kill_time = self._kill_time
    self._kill_time = self._t
	local kill_anim = HMHCC:GetOption("kill_anim") or false
	if kill_anim then
		Combo_text:animate(callback(self, self, "kill_anim"))
        Combo_text_bg:animate(callback(self, self, "kill_anim"))
	end
	if kill_flash then
		Combo_text:animate(callback(self, self, "flash_text"))
	end
end

local time_buffer = 3
function HUDComboCounter:update(t, dt)
    self._t = t
    if (self._kill_time - self._last_kill_time) > time_buffer then
        self._kills = 1
    end
    if (t - self._kill_time) > time_buffer then
        self._kills = 0
    end
    self:set_combo(self._kills)
end