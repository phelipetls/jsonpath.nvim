static const char norm_fg[] = "{foreground}";
static const char norm_bg[] = "{background}";
static const char norm_border[] = "{background}";

static const char sel_fg[] = "{background}";
static const char sel_bg[] = "{color2}";
static const char sel_border[] = "{color2}";

static const char *colors[][3]      = {{
    /*               fg           bg         border                         */
    [SchemeNorm] = {{ norm_fg,     norm_bg,   norm_border }}, // unfocused wins
    [SchemeSel]  = {{ sel_fg,      sel_bg,    sel_border }}  // the focused win
}};
