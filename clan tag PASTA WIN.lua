--.name Clan Tag Custom
--.description Puts your custom clan tag
--.author P0LACK


local local menu_elements = {
    textbox = gui.add_textbox("Сlan tag", "LUA>TAB B"),
    enable_ping = gui.add_checkbox("Аnimation", "Lua>Tab B"), -- does not work
    ping_amount = gui.add_slider("Speed", "Lua>Tab B", 5, 15, 1) -- does not work
}
function clan_tag(string)
    local new_clan_tage = textbox:get_string()
    utils.set_clan_tag(new_clan_tage)
end