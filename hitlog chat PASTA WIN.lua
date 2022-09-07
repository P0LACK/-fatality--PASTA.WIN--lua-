local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local TextColors = {"{white}", "{darkred}", "{team}", "{green}", "{lightgreen}", "{lime}", "{red}", "{grey}", "{yellow}", "{bluegrey}", "{blue}", "{darkblue}", "{purple}", "{violet}", "{lightred}", "{orange}"}
local textbox = gui.add_textbox("Log Prefix", "LUA>TAB A")
local Prefixcolr = gui.add_combo("Prefix color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
local textclr = gui.add_combo("Text Color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
local misscolor = gui.add_combo("Miss Color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
function on_shot_registered(shot)
    if shot.manual then return end
    local p = entities.get_entity(shot.target)
    local n = p:get_player_info()
    local hitgroup = shot.server_hitgroup
    local health = p:get_prop("m_iHealth")
    local Prefix = textbox:get_string()
    local Colors = {gui.get_combo_items("LUA>TAB A>Prefix color")}
    local precolr = Prefixcolr:get_int()
    local txtclr = textclr:get_int()
    local Missclr = misscolor:get_int()
    if shot.server_damage > 0 then
        utils.print_console( TextColors[txtclr + 1],"[", TextColors[precolr + 1], string.len(Prefix) ~= 0 and Prefix or "Fatality.win",TextColors[txtclr + 1] ,"] Hit " , n.name  , " in the ", hitgroup_names[hitgroup + 1]," for " , shot.server_damage, " ( remaining health: ", health, " )\n")
    else
        utils.print_console( TextColors[txtclr + 1],"[", TextColors[precolr + 1], string.len(Prefix) ~= 0 and Prefix or "Fatality.win",TextColors[txtclr + 1] ,"] Shot " , n.name  , " missed due to ", TextColors[Missclr + 1], shot.result, "\n")
    end
end

