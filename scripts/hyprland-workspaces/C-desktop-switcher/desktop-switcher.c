#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// cmd for testing (dev dir): gcc desktop-switcher.c -o demo && ./demo "arg1" "arg2" && rm demo

static inline int getCurrentDesktopNum() {
    char buffer[12];
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    const char* currentDesktop = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    const int currentDesktopNum = atoi(currentDesktop);
    return currentDesktopNum;
}

static inline void pluginCmd(char* userCmd, const int target) {
    char execCmd[50];
    if (strcmp(userCmd, "focus") == 0) {
        sprintf(execCmd, "hyprctl dispatch vdesk %i", target);
        const int result = system(execCmd);
        exit(1);
    }
    if (strcmp(userCmd, "window") == 0) {
        sprintf(execCmd, "hyprctl dispatch movetodesk %i", target);
        const int result = system(execCmd);
        exit(1);
    }
}


/** 
 * @param   target_value - desired activity or desktop direction change value for cmd
 * @param   cmd - operation to do with target_value
 * @param   {name} - {description}
*/
int main(int argc, char* argv[])
{
    // USER SETTINGS
    const int columns = 2;
    const int rows = 2;
    const bool wrapEnable = true;
    // --

    const int currentDesktopNum = getCurrentDesktopNum();
    int targetDesktopNum;
    int modifierNum;

    const int limit = rows + 1;
    for (int i = 1; i < limit; i++) {
        // left most colum
        const int x = i * columns - (columns - 1);
        if (x == currentDesktopNum && 0 == strcmp(argv[1], "left")) {
            if (wrapEnable == true) {
                targetDesktopNum = currentDesktopNum + (columns - 1);
                pluginCmd(argv[2], targetDesktopNum);
            }
            else {
                return 0;
            }
        }
        // right most column
        const int y = i * columns;
        if (x == currentDesktopNum && 0 == strcmp(argv[1], "right")) {
            if (wrapEnable == true) {
                targetDesktopNum = currentDesktopNum - (columns - 1);
                pluginCmd(argv[2], targetDesktopNum);
            }
            else {
                return 0;
            }
        }
    }

    // top row
    if (currentDesktopNum >= 1 && currentDesktopNum <= columns && 0 == strcmp(argv[1], "up")) {
        if (wrapEnable == true) {
            targetDesktopNum = currentDesktopNum + (columns * (rows -1));
            pluginCmd(argv[2], targetDesktopNum);
        }
        else {
            return 0;
        }
    }
    // bottom row
    else if (currentDesktopNum >= (columns * (rows - 1) + 1) && currentDesktopNum <= (rows * columns) && 0 == strcmp(argv[1], "down")) {
        if (wrapEnable == true) {
            targetDesktopNum = currentDesktopNum - (columns * (rows -1));
            pluginCmd(argv[2], targetDesktopNum);
        }
        else {
            return 0;
        }
    }

    if (strcmp(argv[1], "right") == 0) {
        modifierNum = 1;
    }
    else if (strcmp(argv[1], "left") == 0) {
        modifierNum = -1;
    }
    else if (strcmp(argv[1], "up") == 0) {
        modifierNum = -1;
    }
    else if (strcmp(argv[1], "down") == 0) {
        modifierNum = -1;
    }

    targetDesktopNum = currentDesktopNum + modifierNum;
    pluginCmd(argv[2], targetDesktopNum);

    return 0;
}
