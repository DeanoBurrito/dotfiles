/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

/* I build against the flexipatch versions of dmenu/dwm, so select what patches to use. */
#define ALPHA_PATCH 1
#define BORDER_PATCH 1
#define CASEINSENSITIVE_PATCH 1
#define CENTER_PATCH 1
#define FUZZYHIGHLIGHT_PATCH 1
#define FUZZYMATCH_PATCH 1
#define GRID_PATCH 1
#define INCREMENTAL_PATCH 1
#define NUMBERS_PATCH 1

static int topbar = 1; /* -b  option; if 0, dmenu appears at bottom */
static int opacity = 1; /* -o  option; if 0, then alpha is disabled */
static int fuzzy = 1; /* -F  option; if 0, dmenu doesn't use fuzzy matching */
static int incremental = 0; /* -r  option; if 1, outputs text each time a key is pressed */
static int center = 1; /* -c  option; if 0, dmenu won't be centered on the screen */
static int min_width = 700; /* minimum width when centered */
static const char *fonts[] = { "monospace:size=10" };
static const char *prompt = NULL; /* -p  option; prompt to the left of input field */

static const unsigned int baralpha = 0xD0;
static const unsigned int borderalpha = OPAQUE;
static const unsigned int alphas[][3]      = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
	[SchemeBorder] = { OPAQUE, OPAQUE, OPAQUE },
	[SchemeSelHighlight] = { OPAQUE, baralpha, borderalpha },
	[SchemeNormHighlight] = { OPAQUE, baralpha, borderalpha },
};

static const char *colors[][2] = {
	/*               fg         bg       */
	[SchemeNorm] = { "#bbbbbb", "#222222" },
	[SchemeSel]  = { "#eeeeee", "#005577" },
	[SchemeOut]  = { "#000000", "#00ffff" },
	[SchemeBorder] = { "#000000", "#eeeeee" },
	[SchemeSelHighlight]  = { "#ffc978", "#888888" },
	[SchemeNormHighlight] = { "#ffc978", "#222222" },
};

static unsigned int lines = 12; /* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int columns = 0; /* -g option; if nonzero, dmenu uses a grid comprised of columns and lines */
static const char worddelimiters[] = " ";
static unsigned int border_width = 3; /* Size of the window border */
