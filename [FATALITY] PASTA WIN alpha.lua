--.name PASTA.WIN lua alpha
--.description Lua with custom AA, resolver and lots of features
--.author P0LACK


utils.print_dev_console("If you have problem dm me POLACK#4273")
--local textbox = gui.add_textbox("PASTA.WIN", "LUA>TAB A")

local IVEngineClient = utils.find_interface("engine.dll", "VEngineClient014") or error("Engine client is invalid")
local IVEngineClientPtr = ffi.cast("void***", IVEngineClient)
local IVEngineClientVtable = IVEngineClientPtr[0]
local ClientCmdPtr = IVEngineClientVtable[108]
local ClientCmd = ffi.cast(ffi.typeof("void(__thiscall*)(void*, const char*)"), ClientCmdPtr)
local first = {
    'nice',
    'good',
    'nice fucking',
    'amazing',
    'insane',
    'sick',
    'plz give',
    'refund that',
    'love you',
    'fuck',
    'FATALITY beast',
    'P0LACK fuck you',
    'P0LACK good',
    'nice fucking',
    'u sell that',
    'send selly link for that sick'
}
local second = {
    ' config',
    ' antiaim',
    ' settings',
    ' resolver',
    ' brain',
    ' kd',
    ' death',
    ' cheat'
}
function on_player_death(event)
    local lp = engine.get_local_player();
    local attacker = engine.get_player_for_user_id(event:get_int('attacker'));
    local userid = engine.get_player_for_user_id(event:get_int('userid'));
    local userInfo = engine.get_player_info(userid);
        if attacker == lp and userid ~= lp then
            engine.exec("say " .. first[utils.random_int(1, #first)] .. second[utils.random_int(1, #second)])
        end
end

-- screen size
local screen_size = {render.get_screen_size()}

-- fonts
local verdana = render.create_font("verdana.ttf", 14, render.font_flag_shadow)

-- menu
local keybinds_cb = gui.add_checkbox("Keybinds PASTA.win", "lua>tab a")
local keybinds_x = gui.add_slider("keybinds_x", "lua>tab a", 0, screen_size[1], 1)
local keybinds_y = gui.add_slider("keybinds_y", "lua>tab a", 0, screen_size[2], 1)
gui.set_visible("lua>tab a>keybinds_x", false)
gui.set_visible("lua>tab a>keybinds_y", false)


function animate(value, cond, max, speed, dynamic, clamp)

    -- animation speed
    speed = speed * global_vars.frametime * 20

    -- static animation
    if dynamic == false then
        if cond then
            value = value + speed
        else
            value = value - speed
        end
    
    -- dynamic animation
    else
        if cond then
            value = value + (max - value) * (speed / 100)
        else
            value = value - (0 + value) * (speed / 100)
        end
    end

    -- clamp value
    if clamp then
        if value > max then
            value = max
        elseif value < 0 then
            value = 0
        end
    end

    return value
end

function drag(var_x, var_y, size_x, size_y)
    local mouse_x, mouse_y = input.get_cursor_pos()

    local drag = false

    if input.is_key_down(0x01) then
        if mouse_x > var_x:get_int() and mouse_y > var_y:get_int() and mouse_x < var_x:get_int() + size_x and mouse_y < var_y:get_int() + size_y then
            drag = true
        end
    else
        drag = false
    end

    if (drag) then
        var_x:set_int(mouse_x - (size_x / 2))
        var_y:set_int(mouse_y - (size_y / 2))
    end

end
function on_paint()

    if not keybinds_cb:get_bool() then return end

    local pos = {keybinds_x:get_int(), keybinds_y:get_int()}

    local size_offset = 0

    local binds =
    {
        gui.get_config_item("rage>aimbot>aimbot>double tap"):get_bool(),
        gui.get_config_item("rage>aimbot>aimbot>hide shot"):get_bool(),
        gui.get_config_item("rage>aimbot>ssg08>scout>override"):get_bool(), -- override dmg is taken from the scout
        gui.get_config_item("rage>aimbot>aimbot>force safepoint"):get_bool(),
        gui.get_config_item("rage>aimbot>aimbot>headshot only"):get_bool(),
        gui.get_config_item("misc>movement>fake duck"):get_bool(),
        gui.get_config_item("misc>movement>pick assist"):get_bool()
    }

    local binds_name = 
    {
        "Doubletap",
        "Hideshots",
        "Min. Damage",
        "Force safepoint",
        "Headshot only",
        "Fake duck",
        "Avto pick",
    }

    if not binds[4] then
        if not binds[5] then
            if not binds[3] then
                if not binds[1] then
                    if not binds[6] then
                        if not binds[2] then
                            if not binds[7] then
                                size_offset = 0
                            else
                                size_offset = 51
                            end
                        else
                            size_offset = 38
                        end
                    else
                        size_offset = 40
                    end
                else
                    size_offset = 41
                end
            else
                size_offset = 54
            end
        else
            size_offset = 63
        end
    else
        size_offset = 70
    end

    animated_size_offset = animate(animated_size_offset or 0, true, size_offset, 60, true, false)

    local size = {100 + animated_size_offset, 22}

    local enabled = "[enabled]"
    local text_size = render.get_text_size(verdana, enabled) + 7

    local override_active = binds[3] or binds[4] or binds[5] or binds[6] or binds[7] or binds[8]
    local other_binds_active = binds[1] or binds[2] or binds[9] or binds[10] or binds[11]

    drag(keybinds_x, keybinds_y, size[1], size[2])

    alpha = animate(alpha or 0, gui.is_menu_open() or override_active or other_binds_active, 1, 0.5, false, true)

    -- glow
    for i = 1, 10 do
        render.rect_filled_rounded(pos[1] - i, pos[2] - i, pos[1] + size[1] + i, pos[2] + size[2] + i, render.color(0, 170, 229, (20 - (2 * i)) * alpha), 10)
    end

    -- top rect
    render.push_clip_rect(pos[1], pos[2], pos[1] + size[1], pos[2] + 5)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + size[2], render.color(0, 170, 229, 255 * alpha), 5)
    render.pop_clip_rect()

    -- bot rect
    render.push_clip_rect(pos[1], pos[2] + 17, pos[1] + size[1], pos[2] + 22)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + 22, render.color(41, 101, 123, 255 * alpha), 5)
    render.pop_clip_rect()

    -- other
    render.rect_filled_multicolor(pos[1], pos[2] + 5, pos[1] + size[1], pos[2] + 17, render.color(0, 170, 229, 255 * alpha), render.color(0, 170, 229, 255 * alpha), render.color(41, 101, 123, 255 * alpha), render.color(41, 101, 123, 255 * alpha))
    render.rect_filled_rounded(pos[1] + 2, pos[2] + 2, pos[1] + size[1] - 2, pos[2] + 20, render.color(24, 24, 26, 255 * alpha), 5)
    render.text(verdana, pos[1] + size[1] / 2 - render.get_text_size(verdana, "keybinds pasta win") / 2 - 1, pos[2] + 3, "keybinds pasta win", render.color(255, 255, 255, 255 * alpha))


    local bind_offset = 0
    dt_alpha = animate(dt_alpha or 0, binds[1], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2, binds_name[1], render.color(255, 255, 255, 255 * dt_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2, enabled, render.color(255, 255, 255, 255 * dt_alpha))
    if binds[1] then
        bind_offset = bind_offset + 15
    end

    hs_alpha = animate(hs_alpha or 0, binds[2], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[2], render.color(255, 255, 255, 255 * hs_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * hs_alpha))
    if binds[2] then
        bind_offset = bind_offset + 15
    end

    dmg_alpha = animate(dmg_alpha or 0, binds[3], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[3], render.color(255, 255, 255, 255 * dmg_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * dmg_alpha))
    if binds[3] then
        bind_offset = bind_offset + 15
    end

    fs_alpha = animate(fs_alpha or 0, binds[4], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[4], render.color(255, 255, 255, 255 * fs_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * fs_alpha))
    if binds[4] then
        bind_offset = bind_offset + 15
    end

    ho_alpha = animate(ho_alpha or 0, binds[5], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[5], render.color(255, 255, 255, 255 * ho_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * ho_alpha))
    if binds[5] then
        bind_offset = bind_offset + 15
    end

    fd_alpha = animate(fd_alpha or 0, binds[6], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[6], render.color(255, 255, 255, 255 * fd_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * fd_alpha))
    if binds[6] then
        bind_offset = bind_offset + 15
    end

    ap_alpha = animate(ap_alpha or 0, binds[7], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[7], render.color(255, 255, 255, 255 * ap_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * ap_alpha))

end

local surface = {}

--#region Crungo surface
local function vmt_bind(module, interface, index, typestring)
	local instance = ffi.cast("void*", client.create_interface(module, interface)) or error("invalid interface")
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, (ffi.cast("void***", instance)[0])[index]) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

local new_intptr = ffi.typeof("int[1]")
local new_widebuffer = ffi.typeof("wchar_t[?]")

local native_Surface_DrawFilledRect     = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 16, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawSetColor       = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_SetFontGlyph       = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 72, "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)")
local native_Surface_CreateFont         = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 71, "unsigned int(__thiscall*)(void*)")
local native_Surface_GetTextSize        = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 79, "void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)")
local native_Surface_DrawSetTextPos     = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 26, "void(__thiscall*)(void*, int, int)")
local native_Surface_DrawSetTextFont    = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 23, "void(__thiscall*)(void*, unsigned long)")
local native_Surface_DrawSetTextColor   = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 25, "void(__thiscall*)(void*, int, int, int, int)")
local native_Surface_DrawPrintText      = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 28, "void(__thiscall*)(void*, const wchar_t*, int, int)")

local native_Localize_ConvertAnsiToUnicode 	= vmt_bind("localize.dll", "Localize_001", 15, "int(__thiscall*)(void*, const char*, wchar_t*, int)")

function surface.draw_filled_rect(x, y, x2, y2, c)
	native_Surface_DrawSetColor(c.r, c.g, c.b, c.a)
	return native_Surface_DrawFilledRect(x, y, x2, y2)
end


function surface.text(font, x, y, text, c)
	native_Surface_DrawSetTextPos(x, y)
	native_Surface_DrawSetTextFont(font)
	native_Surface_DrawSetTextColor(c.r, c.g, c.b, c.a)
	local wb_size = 1024
	local wide_buffer = new_widebuffer(wb_size)

	native_Localize_ConvertAnsiToUnicode(text, wide_buffer, wb_size)
	return native_Surface_DrawPrintText(wide_buffer, text:len(), 0)
end

function surface.create_font(windows_font_name, tall, weight)
	local font = native_Surface_CreateFont()
	native_Surface_SetFontGlyph(font, windows_font_name, tall, weight, 0, 0, 0, 0, 0)
	return font
end

function surface.get_text_size(font, text)
	local wide_buffer = new_widebuffer(1024)
	local w_ptr = new_intptr()
	local h_ptr = new_intptr()

	native_Localize_ConvertAnsiToUnicode(text, wide_buffer, 1024)
	native_Surface_GetTextSize(font, wide_buffer, w_ptr, h_ptr)

	local w = tonumber(w_ptr[0])
	local h = tonumber(h_ptr[0])

	return w, h
end
--#endregion

local function CreateTextureFromBytes(Bytes)
    local CBytes = ffi.new("unsigned char[?]", #Bytes - 1)
    for i, Byte in pairs(Bytes) do
        CBytes[i - 1] = Byte
    end
    return render.create_texture_bytes(tonumber(ffi.cast("uintptr_t", CBytes)), #Bytes - 1)
end

local g_OuterPadding = 6
local g_InnerPadding = 3
local g_ScreenSpacing = 10
local g_ContainerSpacing = 5
local g_HighlightHeight = 5
local g_ItemPadding = 11
local g_ItemSpacing = 12

local g_BorderColor1 = render.color(0, 0, 0, 200)
local g_BorderColor2 = render.color(56, 54, 52)
local g_BorderColor3 = render.color(18, 18, 18)
local g_BorderColor4 = render.color(34, 34, 34)

local g_BackgroundColor1 = render.color(39, 36, 34)
local g_BackgroundColor2 = render.color(21, 20, 19)
local g_BackgroundColor3 = render.color(12, 12, 12)

local g_HighlightColor = render.color(140, 196, 73)

local DrawStep = 
{
    {0, g_BorderColor1},
    {1, g_BorderColor2},
    {2, g_BackgroundColor1},
    {g_OuterPadding - 1, g_BorderColor2},
    {g_OuterPadding, g_BorderColor3},
    {g_OuterPadding + 1, g_BackgroundColor2},
}

local g_ScreenSize = math.vec3(render.get_screen_size())
local g_Font = surface.create_font("smallest pixel-7", 11, 0, 0)
local g_Logo = CreateTextureFromBytes({
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0F, 0x08, 0x06, 0x00, 0x00, 0x00, 0xDD, 0xFF, 0x5E, 0x0E, 0x00, 0x00, 0x00, 0x09, 0x70, 0x48, 0x59, 0x73, 0x00, 0x00, 0x0B, 0x13, 0x00, 0x00, 0x0B, 
    0x13, 0x01, 0x00, 0x9A, 0x9C, 0x18, 0x00, 0x00, 0x00, 0x20, 0x63, 0x48, 0x52, 0x4D, 0x00, 0x00, 0x7A, 0x25, 0x00, 0x00, 0x80, 0x83, 0x00, 0x00, 0xF9, 0xFF, 0x00, 0x00, 0x80, 0xE9, 0x00, 0x00, 0x75, 0x30, 0x00, 0x00, 0xEA, 0x60, 0x00, 0x00, 0x3A, 0x98, 0x00, 0x00, 0x17, 0x6F, 0x92, 0x5F, 
    0xC5, 0x46, 0x00, 0x00, 0x00, 0x2D, 0x49, 0x44, 0x41, 0x54, 0x78, 0xDA, 0x62, 0xFC, 0xFF, 0xFF, 0xFF, 0x7F, 0x06, 0x22, 0x00, 0x13, 0x03, 0x91, 0x80, 0x68, 0x85, 0x2C, 0x68, 0x7C, 0xC6, 0x81, 0xB3, 0x1A, 0x57, 0x08, 0x30, 0x0E, 0x2B, 0x5F, 0x0F, 0xA0, 0x42, 0x00, 0x00, 0x00, 0x00, 0xFF, 
    0xFF, 0x03, 0x00, 0x1B, 0xD3, 0x05, 0x22, 0xAB, 0x85, 0x8A, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
})
local g_TextureSizes = {}

local function DrawContainer(Position, Data, IsLogo)
    if not IsLogo and #Data == 0 then
        return 0
    end

    local RectFunc = IsLogo and render.rect_filled or surface.draw_filled_rect

    local Width, Height  = -1, 50

    if IsLogo then
        Width = Height
    else
        Width = (g_OuterPadding + g_InnerPadding + 3) * 2
        for _, Info in pairs(Data) do
            local LabelW, LabelH = surface.get_text_size(g_Font, Info.Label)
            local ValueW, ValueH = surface.get_text_size(g_Font, tostring(Info.CustomValueSize or Info.Value))

            Width = Width + LabelW + ValueW + 3 + ((#Data == 1 or _ == #Data) and g_ItemPadding or g_ItemSpacing)
        end
        Width = Width + g_ItemPadding
    end

    Position = Position - math.vec3(Width, 0)

    local Min, Max = Position, math.vec3(Position.x + Width, Position.y + Height)

    for _, Step in pairs(DrawStep) do
        RectFunc(Min.x + Step[1], Min.y+ Step[1], Max.x - Step[1], Max.y - Step[1], Step[2])
    end
    
    local PaddingOffset = (g_OuterPadding + g_InnerPadding + 1)
    local InnerMin, InnerMax = Min + PaddingOffset + math.vec3(0, g_HighlightHeight), Max - PaddingOffset

    RectFunc(InnerMin.x, InnerMin.y, InnerMax.x, InnerMax.y, g_BorderColor4)
    RectFunc(InnerMin.x + 1, InnerMin.y + 1, InnerMax.x - 1, InnerMax.y - 1, g_BackgroundColor3)
    RectFunc(InnerMin.x, InnerMin.y - g_HighlightHeight, InnerMax.x, InnerMin.y, render.color(g_HighlightColor.r, g_HighlightColor.g, g_HighlightColor.b, g_HighlightColor.a * 0.05))
    RectFunc(InnerMin.x + 1, InnerMin.y - g_HighlightHeight + 1, InnerMax.x - 1, InnerMin.y - 1, g_HighlightColor)

    InnerMin = InnerMin + math.vec3(1, 1)
    InnerMax = InnerMax + math.vec3(1, 1)

    -- We are finally at the true background area
    if IsLogo then
        if not g_TextureSizes[g_Logo] then
            local w, h = render.get_texture_size(g_Logo)
            g_TextureSizes[g_Logo] = {w = w, h = h}
        end

        local TextureSize = g_TextureSizes[g_Logo]

        local BoundsSize    = InnerMax - InnerMin
        local DrawPos       = InnerMin + BoundsSize / 2 - math.vec3(TextureSize.w / 2 + 1, TextureSize.h / 2 + 1)

        render.push_texture(g_Logo)
        render.rect_filled(DrawPos.x, DrawPos.y, DrawPos.x + TextureSize.w, DrawPos.y + TextureSize.h, g_HighlightColor)
        render.pop_texture()
    else
        local XOffset = 0
        local BoundsSize    = InnerMax - InnerMin
        local StartPos      = InnerMin + math.vec3(g_ItemPadding, BoundsSize.y / 2)

        for _, Info in pairs(Data) do
            local LabelW, LabelH = surface.get_text_size(g_Font, Info.Label)
            local ValueW, ValueH = surface.get_text_size(g_Font, tostring(Info.CustomValueSize or Info.Value))

            surface.text(g_Font, StartPos.x + XOffset, StartPos.y - LabelH / 2 - 1, Info.Label, render.color("#FFFFFF"))
            surface.text(g_Font, StartPos.x + XOffset + LabelW + 3, StartPos.y - LabelH / 2 - 1, tostring(Info.Value), g_HighlightColor)
            XOffset = XOffset + LabelW + ValueW + 3 + g_ItemSpacing    
        end
    end
    return Width
end

local Enable = gui.add_checkbox("Watermark", "lua>tab a")
local ColorPicker = gui.add_colorpicker("lua>tab a>watermark", false, g_HighlightColor)
local FPS, Ping, Rate, Time = gui.add_multi_combo("Watermark options", "lua>tab a", {"FPS", "Ping", "Rate", "Time"})

local g_LogoContainerSize = 0
function on_paint()
    if not Enable:get_bool() then
        g_LogoContainerSize = 0
        return false
    end
    g_HighlightColor = ColorPicker:get_color()


    g_LogoContainerSize = DrawContainer(math.vec3(g_ScreenSize.x - g_ScreenSpacing, g_ScreenSpacing), nil, true)
end

function on_paint_traverse()
    if not Enable:get_bool() then
        return false
    end

    local ContainerPos = math.vec3(g_ScreenSize.x - g_ScreenSpacing - g_LogoContainerSize - g_ContainerSpacing, g_ScreenSpacing)
    local ContainerOffset = math.vec3(0, 0)

    local Info = {}
    if FPS:get_bool() then
        table.insert(Info, {Label = "FPS:", Value = math.floor(1 / global_vars.frametime), CustomValueSize = "999"})
    end

    if Ping:get_bool() then
        table.insert(Info, {Label = "PING:", Value = string.format("%iMS", math.floor((utils.get_rtt() or 0) * 1000))})
    end

    if Rate:get_bool() then
        table.insert(Info, {Label = "RATE:", Value = math.floor(1 / global_vars.interval_per_tick)})
    end

    local InfoContainerSize = DrawContainer(ContainerPos - ContainerOffset, Info)
    if InfoContainerSize > 0 then
        ContainerOffset.x = ContainerOffset.x + InfoContainerSize + g_ContainerSpacing
    end

    if Time:get_bool() then
        local Time = utils.get_time()
        DrawContainer(ContainerPos - ContainerOffset, {{Label = "TIME:", Value = string.format("%02i:%02i:%02i", Time.hour, Time.min, Time.sec), CustomValueSize = "01:58:47"}})
    end
end

local hook=require("hooks")

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", utils.find_interface(module, interface)) or error(interface .. " is nil.")
    return ffi.cast(ffi.typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this)
    return function(...)
        return func(this, ...)
    end
end

local function vtable_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            local addr=ffi.cast("void***", instance)
            return __thiscall(ffi.cast(t, (addr[0])[index]),addr)
        end
    end
end

local cheat_refs = {
    fast_fire_ref = gui.get_config_item("rage>aimbot>aimbot>double tap"),
    anti_exploit = gui.get_config_item("rage>aimbot>aimbot>anti-exploit")
}

local menu_elements = {
    enable_ping = gui.add_checkbox("Ping Spike", "Lua>Tab A"),
    bind_ping = gui.add_keybind("Lua>Tab A>Ping Spike"),
    ping_amount = gui.add_slider("Amount", "Lua>Tab A", 5, 180, 1) -- increase at own risk, anything above this value causes inaccuracy issues.
}

ffi.cdef[[
    typedef struct
    {
        char   pad0[0x14];             //0x0000
        bool        bProcessingMessages;    //0x0014
        bool        bShouldDelete;          //0x0015
        char   pad1[0x2];              //0x0016
        int         iOutSequenceNr;         //0x0018 last send outgoing sequence number
        int         iInSequenceNr;          //0x001C last received incoming sequence number
        int         iOutSequenceNrAck;      //0x0020 last received acknowledge outgoing sequence number
        int         iOutReliableState;      //0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int         iInReliableState;       //0x0028 state of incoming reliable data
        int         iChokedPackets;         //0x002C number of choked packets
        char   pad2[0x414];            //0x0030
    } INetChannel; // Size: 0x0444
]]

local nullptr = ffi.new('void*')

local nativeGetNetChannel = __thiscall(vtable_bind("engine.dll", "VEngineClient014", 78, "INetChannel*(__thiscall*)(void*)"))

local INetChannelPtr=nullptr

local nativeINetMessageGetType=vtable_thunk(7,"int(__thiscall*)(void*)")
local nativeINetChannelGetLatency=vtable_thunk(9,"float(__thiscall*)(void*,int)")

local vecSequences={}
local nLastIncomingSequence=0

local function UpdateIncomingSequences(pNetChannel)
        if nLastIncomingSequence==0 then nLastIncomingSequence=pNetChannel.iInSequenceNr end
        if pNetChannel.iInSequenceNr > nLastIncomingSequence then
            nLastIncomingSequence=pNetChannel.iInSequenceNr
            table.insert(vecSequences,1,{pNetChannel.iInReliableState,pNetChannel.iChokedPackets,pNetChannel.iInSequenceNr,global_vars.realtime})
        end
        if #vecSequences > 128 then
            table.remove(vecSequences)
        end
    end

local function ClearIncomingSequences()
    nLastIncomingSequence=0
    if #vecSequences~=0 then
        vecSequences={}
    end
end

function SendDatagramHook(originalFunction)
    local originalFunction=originalFunction
    local sv_maxunlag = cvar["sv_maxunlag"]

    function clamp(min, max, value)
        return math.min(math.max(min, value), max)
    end

    function AddLatencyToNetChannel(pNetChannel,flMaxLatency)
        for i,sequence in ipairs(vecSequences) do
            if global_vars.realtime-sequence[4]>=flMaxLatency then
                pNetChannel.iInReliableState=sequence[1]
                pNetChannel.iInSequenceNr=sequence[3]
                break
            end
        end
    end

    function SendDatagram(this,pDatagram)
        local local_player = entities.get_entity(engine.get_local_player())
        if not engine.is_in_game() or not local_player:is_valid() or not menu_elements.enable_ping:get_bool() or cheat_refs.anti_exploit:get_bool() or pDatagram~=nullptr then
            return originalFunction(this,pDatagram)
        end

        local iOldInReliableState=this.iInReliableState
        local iOldInSequenceNr=this.iInSequenceNr

        local flMaxLatency=math.max(0,clamp(0,sv_maxunlag:get_float(),menu_elements.ping_amount:get_int()/1000)-nativeINetChannelGetLatency(this)(0))
        AddLatencyToNetChannel(this,flMaxLatency)

        local res=originalFunction(this,pDatagram)

        this.iInReliableState=iOldInReliableState
        this.iInSequenceNr=iOldInSequenceNr

        return res
    end
    return SendDatagram
end

local INetChannel

local initialize=false

function on_setup_move(cmd)
    INetChannelPtr=nativeGetNetChannel()
    if menu_elements.enable_ping:get_bool() then
        UpdateIncomingSequences(INetChannelPtr)
    else
        ClearIncomingSequences()
    end
    if initialize then return end
    initialize=true
    INetChannel=hook.jmp.new("int(__thiscall*)(INetChannel*,void*)",SendDatagramHook,ffi.cast("intptr_t**",INetChannelPtr)[0][46],6,true)
end

function on_frame_stage_notify(stage, pre_original)
    if engine.is_in_game() then return end
    ClearIncomingSequences()
end

function on_shutdown()
    if INetChannel~=nil then INetChannel.stop() end
end

local function handle_visiblity()
    if menu_elements.enable_ping:get_bool() then
        gui.set_visible("Lua>Tab A>Amount", true)
    else
        gui.set_visible("Lua>Tab A>Amount", false)
    end
end

local screen_width, screen_height = render.get_screen_size()
local y = screen_height / 2

local function indicator()
    render.text(render.font_indicator, 10, y + 130 , "PING", render.color(5,150,195,255), render.align_left, render.align_center)
end

function on_paint()
    handle_visiblity()
    local local_player = entities.get_entity(engine.get_local_player())
    if not engine.is_in_game() or not local_player:is_valid() or not menu_elements.enable_ping:get_bool() then
        return
    end

    indicator()
end