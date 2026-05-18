-- =============================================================================
-- Hyprland Native Lua Configuration
-- =============================================================================

-- --- Variables ---
local mainMod = "SUPER"
local terminal = "rio"
local fileManager = "dolphin"
local menu = "uwsm app -- walker"

-- --- Monitors ---
hl.monitor("DP-1, 5120x1440@144, 0x0, 1")

-- --- Environment Variables ---
hl.env("XCURSOR_SIZE, 24")
hl.env("HYPRCURSOR_SIZE, 24")
hl.env("HYPRCURSOR_THEME, Nordzy-cursor")

-- --- Core Configuration ---
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        ["col.active_border"] = "rgba(952c59ed)",
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle"
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696
        }
    },

    animations = {
        enabled = true,
        bezier = {
            "easeOutQuint, 0.23, 1, 0.32, 1",
            "easeInOutCubic, 0.65, 0.05, 0.36, 1",
            "linear, 0, 0, 1, 1",
            "almostLinear, 0.5, 0.5, 0.75, 1.0",
            "quick, 0.15, 0, 0.1, 1"
        },
        animation = {
            "global, 1, 10, default",
            "border, 1, 5.39, easeOutQuint",
            "windows, 1, 4.79, easeOutQuint",
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%",
            "windowsOut, 1, 1.49, linear, popin 87%",
            "fadeIn, 1, 1.73, almostLinear",
            "fadeOut, 1, 1.46, almostLinear",
            "fade, 1, 3.03, quick",
            "layers, 1, 3.81, easeOutQuint",
            "layersIn, 1, 4, easeOutQuint, fade",
            "layersOut, 1, 1.5, linear, fade",
            "fadeLayersIn, 1, 1.79, almostLinear",
            "fadeLayersOut, 1, 1.39, almostLinear",
            "workspaces, 1, 1.94, almostLinear, fade",
            "workspacesIn, 1, 1.21, almostLinear, fade",
            "workspacesOut, 1, 1.94, almostLinear, fade"
        }
    },

    dwindle = {
        preserve_split = true -- pseudotile dropped globally in newer versions
    },

    master = {
        new_status = "master"
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true
    },

    input = {
        kb_layout = "us, ua",
        kb_options = "grp:win_space_toggle",
        follow_mouse = 0,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false
        }
    },

    device = {
        {
            name = "epic-mouse-v1",
            sensitivity = -0.5
        }
    },

    -- --- Window Rules ---
    windowrulev2 = {
        -- Picture-in-Picture Modern Configuration
        {
            title = "^(Picture-in-Picture)$",
            float = true,
            pin = true,
            size = "800 450",
            move = "4310 980",
            no_initial_focus = true
        },
        -- Suppress maximize events
        {
            suppress_event = "maximize",
            class = ".*"
        },
        -- XWayland drag fix
        {
            class = "^$",
            title = "^$",
            xwayland = 1,
            floating = 1,
            fullscreen = 0,
            pinned = 0,
            focus = false
        }
    }
})

-- --- Autostart Applications ---
hl.exec_once("hypridle")
hl.exec_once("dunst")
hl.exec_once("sleep 10 && hyprpaper")
hl.exec_once("wl-paste --type image --watch cliphist store")
hl.exec_once("wl-clip-persist --clipboard regular")

-- --- Keybindings ---
-- General System & Apps
hl.bind(mainMod .. ", Q", "exec, " .. terminal)
hl.bind(mainMod .. ", C", "killactive")
hl.bind(mainMod .. ", M", "exit")
hl.bind(mainMod .. ", E", "exec, " .. fileManager)
hl.bind(mainMod .. ", V", "togglefloating")
hl.bind(mainMod .. ", R", "exec, " .. menu .. " | xargs hyprctl dispatch exec --")
hl.bind(mainMod .. ", P", "pin")
hl.bind(mainMod .. ", J", "layoutmsg, togglesplit")
hl.bind(mainMod .. ", l", "exec, hyprlock")
hl.bind(mainMod .. ", B", "exec, walker -m clipboard")
hl.bind(mainMod .. ", F", "fullscreen")
hl.bind(mainMod .. " SHIFT, F", "fullscreenstate, 0 2")
hl.bind(mainMod .. ", Tab", "cyclenext")
hl.bind(mainMod .. ", Tab", "bringactivetotop")
hl.bind(mainMod .. " SHIFT, P", "exec, poweroff")
hl.bind(mainMod .. " SHIFT, O", "exec, systemctl suspend")

-- Screenshots (Hyprshot)
hl.bind(mainMod .. ", PRINT", "exec, hyprshot -m window --clipboard-only")
hl.bind("", "PRINT", "exec, hyprshot -m output --clipboard-only")
hl.bind(mainMod .. " SHIFT, PRINT", "exec, hyprshot -m region --clipboard-only")

-- Focus Management (Arrow Keys)
hl.bind(mainMod .. ", left", "movefocus, l")
hl.bind(mainMod .. ", right", "movefocus, r")
hl.bind(mainMod .. ", up", "movefocus, u")
hl.bind(mainMod .. ", down", "movefocus, d")

-- Workspace Switching (1-10)
for i = 1, 9 do
    hl.bind(mainMod .. ", " .. i, "workspace, " .. i)
    hl.bind(mainMod .. " SHIFT, " .. i, "movetoworkspace, " .. i)
end
hl.bind(mainMod .. ", 0", "workspace, 10")
hl.bind(mainMod .. " SHIFT, 0", "movetoworkspace, 10")

-- Scratchpad / Special Workspace
hl.bind(mainMod .. ", S", "togglespecialworkspace, magic")
hl.bind(mainMod .. " SHIFT, S", "movetoworkspace, special:magic")

-- Workspace Scrolling
hl.bind(mainMod .. ", mouse_down", "workspace, e+1")
hl.bind(mainMod .. ", mouse_up", "workspace, e-1")

-- Mouse Window Actions (Move/Resize)
hl.bindm(mainMod .. ", mouse:272", "movewindow")
hl.bindm(mainMod .. ", mouse:273", "resizewindow")

-- Hardware Keys (Volume, Brightness, Media Control)
hl.bindel("", "XF86AudioRaiseVolume", "exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
hl.bindel("", "XF86AudioLowerVolume", "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
hl.bindel("", "XF86AudioMute", "exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
hl.bindel("", "XF86AudioMicMute", "exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
hl.bindel("", "XF86MonBrightnessUp", "exec, brightnessctl -e4 -n2 set 5%+")
hl.bindel("", "XF86MonBrightnessDown", "exec, brightnessctl -e4 -n2 set 5%-")

hl.bindl("", "XF86AudioNext", "exec, playerctl next")
hl.bindl("", "XF86AudioPause", "exec, playerctl play-pause")
hl.bindl("", "XF86AudioPlay", "exec, playerctl play-pause")
hl.bindl("", "XF86AudioPrev", "exec, playerctl previous")
