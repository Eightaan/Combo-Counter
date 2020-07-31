if not _G.HotlineHUD then
	_G.HotlineHUD = {}
	HotlineHUD.Kills = 0
	HotlineHUD.LastKillTime = 0
	HotlineHUD.KillTime = 0
	
	function HotlineHUD:LoadFiles()
		for _, file in pairs(SystemFS:list(ModPath.. "assets/guis/textures/")) do
			DB:create_entry(Idstring("texture"), Idstring("assets/guis/textures/".. file:gsub(".texture", "")), ModPath.. "assets/guis/textures/".. file)
		end
	end
	
	HotlineHUD:LoadFiles()
end