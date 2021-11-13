static const char norm_fg[] = "{color15}";
static const char norm_bg[] = "{background}";
static const char norm_border[] = "{background}";

static const char sel_fg[] = "{color15}";
static const char sel_bg[] = "{color8}";
static const char sel_border[] = "{color8}";

static const char hid_fg[] = "{color15}";
static const char hid_bg[] = "{color0}";
static const char hid_border[] = "{color8}";

static const char *colors[][3]      = {{
    /*               fg           bg         border                         */
    [SchemeNorm] = {{ norm_fg,     norm_bg,   norm_border }}, // unfocused wins
    [SchemeSel]  = {{ sel_fg,      sel_bg,    sel_border }},  // the focused win
    [SchemeHid]  = {{ hid_fg,      hid_bg,    hid_border }}  // the hidden win
}};
