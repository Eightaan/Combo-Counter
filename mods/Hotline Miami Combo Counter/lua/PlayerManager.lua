Hooks:PostHook(PlayerManager, "on_killshot", "combo_update", function(self, killed_unit)
    if not CopDamage.is_civilian(killed_unit:base()._tweak_table) then
        managers.hud:HMHCC_OnKillshot()
    end
end)