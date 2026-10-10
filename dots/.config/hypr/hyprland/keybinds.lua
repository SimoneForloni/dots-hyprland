local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd(launcher), { description = "Launcher: Open Launcher" })
hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd("kill rofi"))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Terminal: Open Terminal" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
    { description = "System: Shutdown or Exit" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "FileManager: Open FileManager" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser), { description = "Browser: Open Browser" })
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Window: Pseudo" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Layout: Toggle Split" }) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind("ALT + F4",
    function()
        hl.exec_cmd(
            "notify-send \"Wrong close keybind\" \"Super+Q to close. Use Alt+F4 for Windows VMs\" -a Hyprland")
    end,
    { non_consuming = true })
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Window: Forcefully zap a window" })

--# Window split ratio
--#/# binde = SUPER, ;/',, -- Adjust split ratio
hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"),
    { repeating = true, description = "Layout: Decrease Split Ratio" })
hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"),
    { repeating = true, description = "Layout: Increase Split Ratio" })
--# Positioning mode
hl.bind("SUPER + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })
hl.bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Window: Maximize" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Window: Fullscreen" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
    { description = "Window: Fullscreen spoof" })
hl.bind("SUPER + P", hl.dsp.window.pin(), { description = "Window: Pin" })

--#/# bind = SUPER + SHIFT, ←/↑/→/↓,, -- Move in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }),
        { description = "Window: Move " .. arrowkey[i] })
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }),
        { description = "Workspace: Focus Workspace " .. key })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }),
        { description = "Workspace: Move Window to Workspace " .. key })
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"),
    { description = "Workspace: Toggle Special Workspace" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }),
    { description = "Workspace: Move Window to Special Workspace" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }),
    { description = "Workspace: Scroll through Workspaces" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }),
    { description = "Workspace: Scroll through Workspaces" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
