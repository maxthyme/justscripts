--Edit certain worldgen parameters while it is running.
local gui = require 'gui'
local widgets = require 'gui.widgets'
local wv = df.global.gview.view.child.child
local wd = df.global.world.world_data
local wg = df.global.world.worldgen.worldgen_parms
local stn
local stc
local pop
local eny

genedit=defclass(genedit,gui.Screen)
genedit.focus_path = 'worldgenedit'
function genedit:init()
    self:addviews{
        widgets.Label{
		view_id="main",
		frame = {t=18,l=0}, 
		text={
			{text="Quit: Enter/Esc        "},{id="prec", text="Site Num: "}, {id="curs", text=self:callback("getSites")},NEWLINE,
			{text="Edit: Left/Right(Fast) "},{id="pres", text="Site Cap: "}, {id="caps", text=self:callback("getCaps")},NEWLINE,
			{text="Edit: Up/Down(Fast/Z)  "},{id="ends", text="End Year: "}, {id="endy", text=self:callback("getEny")},NEWLINE,
			{text="Edit: PgUp/Dn(Fast)    "},{id="pops", text="Pop Cap: "}, {id="popc", text=self:callback("getPops")},
				}
			}
}
end

function genedit:getSites()
	if df.viewscreen_new_regionst:is_instance(wv) then
		stn = wd.next_site_id-1
	else
		qerror("Should be used during worldgen.")
	end
	return stn
end

function genedit:getCaps()
	if df.viewscreen_new_regionst:is_instance(wv) then
		stc = wg.site_cap
	else
		qerror("Should be used during worldgen.")
	end
	return stc
end

function genedit:getPops()
	if df.viewscreen_new_regionst:is_instance(wv) then
		pop = wg.total_civ_population
	else
		qerror("Should be used during worldgen.")
	end
	return pop
end

function genedit:getEny()
	if df.viewscreen_new_regionst:is_instance(wv) then
		eny = wg.end_year
	else
		qerror("Should be used during worldgen.")
	end
	return eny
end

function genedit:onInput(keys)
	if df.viewscreen_new_regionst:is_instance(wv) then
		if keys.LEAVESCREEN or keys.SELECT then
		       	self:dismiss()
		end
		if keys.CURSOR_LEFT then 
			wg.site_cap = wg.site_cap-25
		elseif keys.CURSOR_RIGHT then
			wg.site_cap = wg.site_cap+25
		elseif keys.CURSOR_LEFT_FAST then
			wg.site_cap = wg.site_cap-100
		elseif keys.CURSOR_RIGHT_FAST then
			wg.site_cap = wg.site_cap+100
		elseif keys.CURSOR_DOWN then
			wg.end_year = wg.end_year-1
		elseif keys.CURSOR_UP then
			wg.end_year = wg.end_year+1
		elseif keys.CURSOR_DOWN_FAST then
			wg.end_year = wg.end_year-25
		elseif keys.CURSOR_UP_FAST then
			wg.end_year = wg.end_year+25
		elseif keys.CURSOR_DOWN_Z then
			wg.end_year = wg.end_year-1000
		elseif keys.CURSOR_UP_Z then
			wg.end_year = wg.end_year+1000
		elseif keys.STANDARDSCROLL_PAGEDOWN then
			wg.total_civ_population = wg.total_civ_population-250
		elseif keys.STANDARDSCROLL_PAGEUP then
			wg.total_civ_population = wg.total_civ_population+250
		elseif keys.SECONDSCROLL_PAGEDOWN then
			wg.total_civ_population = wg.total_civ_population-1000
		elseif keys.SECONDSCROLL_PAGEUP then
			wg.total_civ_population = wg.total_civ_population+1000
		end
	elseif not df.viewscreen_new_regionst:is_instance(wv) then
		if keys then
			self:dismiss()
			qerror("Should be used during worldgen.")
		end
	end
	self.super.onInput(self,keys)
end

function genedit:onRenderBody(dc)
	self._native.parent:render()
end

genedit():show()
