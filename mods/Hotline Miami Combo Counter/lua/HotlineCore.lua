if not _G.HotlineHUD then
	_G.HotlineHUD = {}
	HotlineHUD.Kills = 0
	HotlineHUD.LastKillTime = 0
	HotlineHUD.KillTime = 0
end

Hooks:PostHook(HUDManager, "feed_heist_time", "Combofeed_heist_time", function(self, time, ...)
	self._current_time = time
end)

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "Combo_setup_player_info_hud_pd2", function(self, ...)
	self:add_updator("HotlineMiamiUpdater", callback(self, self, "HotlineMiamiupdate"))
end)

local time_buffer = 3
function HUDManager:HotlineMiamiupdate(t, dt)
	local current_time_buffer = time_buffer - (0.5 * HotlineHUD.Kills)
	if current_time_buffer < 3 then
		current_time_buffer = 3
	end
	if (HotlineHUD.KillTime - (HotlineHUD.LastKillTime or 0)) > time_buffer then
		HotlineHUD.Kills = 1
	end
	if ((managers.hud._current_time or 0) - HotlineHUD.KillTime) > time_buffer then
		HotlineHUD.Kills = 0
	end
	
	if managers.hud._hud_objectives then
		managers.hud._hud_objectives:set_combo(HotlineHUD.Kills)
	end
end