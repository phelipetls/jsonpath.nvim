/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

#include "/home/phelipe/.cache/wal/colors-wal-slock.h"

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds to cancel lock with mouse movement */
static const int timetocancel = 5;
