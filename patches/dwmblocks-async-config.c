#include "config.h"

#include "block.h"
#include "util.h"

Block blocks[] = {
    { "status-cpu", 2, 0 },
    { "status-network", 2, 1 },
    { "status-power", 5, 2 },
    { "status-volume", 0, 3 },
    { "status-backlight", 0, 4 },
    { "status-time", 10, 0 },
};

const unsigned short blockCount = LEN(blocks);
