Hooks:PostHook(PlayerManager, "on_killshot", "combo_update", function(self, killed_unit)
	if not CopDamage.is_civilian(killed_unit:base()._tweak_table) then
	  HotlineHUD.Kills = HotlineHUD.Kills + 1
	  HotlineHUD.LastKillTime = HotlineHUD.KillTime
	  HotlineHUD.KillTime = managers.hud._current_time
    end
end)