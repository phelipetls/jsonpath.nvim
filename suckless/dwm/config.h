/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int gappx     = 0;        /* gap pixel between windows */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const char *fonts[]          = { "SourceCodePro-SemiBold:size=9", "FontAwesome:style=Regular" };
static const char dmenufont[]       = "monospace:size=10";
#include "colors-wal-dwm.h"

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class         instance  title        tags mask  iscentered  isfloating  monitor */
	{ "R_x11",       NULL,     NULL,        0,         0,          1,          -1 },
	{ "Matplotlib",  NULL,     NULL,        0,         0,          1,          -1 },
	{ "Thunar",      NULL,     NULL,        0,         1,          1,          -1 },
	{ "Peek",        NULL,     NULL,        0,         0,          1,          -1 },
	{ "appfinder",   NULL,     NULL,        0,         1,          1,          -1 },
	{ "scrcpy",      NULL,     NULL,        0,         0,          1,          -1 },
	{ NULL,          NULL,     "Emulator",  0,         0,          1,          -1 },
	{ "spotify",     NULL,     NULL,        1 << 0,    0,          0,          -1 },
	{ "Slack",       NULL,     NULL,        1 << 6,    0,          0,          -1 },
	{ "discord",     NULL,     NULL,        1 << 6,    0,          0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int decorhints  = 1;    /* 1 means respect decoration hints */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2]                     = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]               = { "$HOME/suckless/dmenu/dmenu_run" };
static const char *appfinder[]              = { "xfce4-appfinder" };
static const char *lockcmd[]                = { "slock" };
static const char *termcmd[]                = { "st", NULL };
static const char *browsercmd[]             = { "firefox", NULL };
static const char *shutdown[]               = { "$HOME/scripts/shutdown", NULL };
static const char *brightnessup[]           = { "$HOME/scripts/change-brightness", "up", NULL };
static const char *brightnessdown[]         = { "$HOME/scripts/change-brightness", "down", NULL };
static const char *upvol[]                  = { "$HOME/scripts/change-volume", "up", NULL };
static const char *downvol[]                = { "$HOME/scripts/change-volume", "down", NULL };
static const char *mutevol[]                = { "$HOME/scripts/change-volume", "mute", NULL };

#include "focusurgent.c"

static Key keys[] = {
    /* modifier                         key                       function        argument */
	{ 0,                            XF86XK_AudioLowerVolume,  spawn,          {.v = downvol } },
	{ 0,                            XF86XK_AudioMute,         spawn,          {.v = mutevol } },
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn,          {.v = upvol } },
	{ 0,                            XF86XK_MonBrightnessUp,   spawn,          {.v = brightnessup } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn,          {.v = brightnessdown } },
	{ 0,                            XK_Print,                 spawn,          SHCMD("$HOME/scripts/scrot-share") },
	{ ControlMask,                  XK_Print,                 spawn,          SHCMD("sleep 0.2; $HOME/scripts/scrot-share -s") },
	{ MODKEY,                       XK_r,                     spawn,          {.v = appfinder } },
	{ MODKEY,                       XK_p,                     spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,                spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_w,                     spawn,          {.v = browsercmd } },
	{ MODKEY,                       XK_F4,                    spawn,          {.v = shutdown } },
	{ MODKEY,                       XK_l,                     spawn,          {.v = lockcmd } },
	{ MODKEY,                       XK_b,                     togglebar,      {0} },
	{ MODKEY,                       XK_j,                     focusstackvis,  {.i = +1 } },
	{ MODKEY,                       XK_k,                     focusstackvis,  {.i = -1 } },
	{ Mod1Mask,                     XK_Tab,                   focusstackvis,  {.i = +1 } },
	{ Mod1Mask|ShiftMask,           XK_Tab,                   focusstackvis,  {.i = -1 } },
	{ MODKEY,                       XK_i,                     incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,                     incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_h,                     setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_l,                     setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_j,                     setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_k,                     setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,                     setcfact,       {.f =  0.00} },
	{ MODKEY,                       XK_Return,                zoom,           {0} },
	{ MODKEY,                       XK_Tab,                   view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,                     killclient,     {0} },
	{ Mod1Mask,                     XK_F4,                    killclient,     {0} },
	{ MODKEY,                       XK_t,                     setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,                     setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,                     setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,                 setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,                 togglefloating, {0} },
	{ MODKEY,                       XK_0,                     view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,                     tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,                 focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,                focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,                 tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,                tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_s,                     show,           {0} },
	{ MODKEY,                       XK_h,                     hide,           {0} },
	TAGKEYS(                        XK_1,                     0)
	TAGKEYS(                        XK_2,                     1)
	TAGKEYS(                        XK_3,                     2)
	TAGKEYS(                        XK_4,                     3)
	TAGKEYS(                        XK_5,                     4)
	TAGKEYS(                        XK_6,                     5)
	TAGKEYS(                        XK_7,                     6)
	TAGKEYS(                        XK_8,                     7)
	TAGKEYS(                        XK_9,                     8)
	{ MODKEY|ShiftMask,             XK_q,                     quit,           {0} },
	{ MODKEY,                       XK_u,                     focusurgent,    {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkWinTitle,          0,              Button1,        togglewin,      {0} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
