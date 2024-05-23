local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "IR_Black"
config.colors = {
	cursor_bg = "#ff69b4",
}
config.font = wezterm.font(
	"BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons"
)
config.font_size = 14
config.audible_bell = "Disabled"

return config
