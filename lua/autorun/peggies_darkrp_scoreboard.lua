if SERVER then return end

scoreboard_var = scoreboard_var or {}

function scoreboard_var:create_scoreboard()
	self.main_frame = vgui.Create("DFrame")
	self.main_frame:SetSize(ScrW(), ScrH())
	self.main_frame:Center()
	self.main_frame:ShowCloseButton(false)
	self.main_frame:SetTitle("")
	self.main_frame:DockPadding(0, 0, 0, 0)
	self.main_frame.Paint = nil

	self.left_frame = self.main_frame:Add("DPanel")
	self.left_frame:Dock(LEFT)
	self.left_frame:SetWide(self.main_frame:GetWide()/5)
	self.left_frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
	end

	self.right_frame = self.main_frame:Add("DPanel")
	self.right_frame:Dock(RIGHT)
	self.right_frame:SetWide(self.main_frame:GetWide()/5)
	self.right_frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
	end

	self.bot_frame = self.main_frame:Add("DPanel")
	self.bot_frame:Dock(BOTTOM)
	self.bot_frame:SetTall(self.main_frame:GetTall()/5)
	self.bot_frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
		draw.SimpleText("Players: " .. player.GetCount() .. "/" .. game.MaxPlayers(), "CloseCaption_Normal", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.top_frame = self.main_frame:Add("DPanel")
	self.top_frame:Dock(TOP)
	self.top_frame:SetTall(self.main_frame:GetTall()/5)
	self.top_frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
		draw.SimpleText(GetHostName(), "CloseCaption_Bold", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.list_frame = self.main_frame:Add("DScrollPanel")
	self.list_frame:Dock(FILL)
	self.list_frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
	end
	self.list_frame:GetVBar():SetHideButtons(true)

	local all_jobs_list = {}
	for k, v in pairs(player.GetAll()) do
		if all_jobs_list[RPExtraTeams[v:Team()]] then continue end
		
		all_jobs_list[RPExtraTeams[v:Team()]] = true
	end

	for k, v in pairs(all_jobs_list) do
		local job_frame = self.list_frame:Add("DPanel")
		job_frame:Dock(TOP)
		job_frame:SetTall(40)
		job_frame.Paint = nil

		local title_frame = job_frame:Add("DPanel")
		title_frame:Dock(TOP)
		title_frame.Paint = function(s, w, h)
			draw.SimpleText(k.category, "CloseCaption_Italic", w/3, h/2, k.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		for _k, _v in pairs(player.GetAll()) do
			if RPExtraTeams[_v:Team()] != k then continue end

			local player_frame = job_frame:Add("DPanel")
			player_frame:Dock(TOP)
			player_frame.Paint = function(s, w, h)
				draw.SimpleText(_v:Nick(), "CreditsText", w/3, h/2, k.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(team.GetName(_v:Team()), "CreditsText", w/2, h/2, k.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			player_frame:SetTall(20)
			player_frame.DoClick = function()
				SetClipboardText(_v:SteamID())
			end
			job_frame:SetTall(job_frame:GetTall() + 20)
		end
	end

	self.main_frame:MakePopup()
end

hook.Add("ScoreboardShow", "show_scoreboard", function()
	scoreboard_var:create_scoreboard() 
	return true 
end)

hook.Add("ScoreboardHide", "hide_scoreboard", function()
	scoreboard_var.main_frame:Remove()
end)