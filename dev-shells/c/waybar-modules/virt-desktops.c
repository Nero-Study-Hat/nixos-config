#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>

int getCurrentDesktopNum(const int numOfActivities, const int desktopsInActivity) {
    char buffer[12];
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    const char* currentDesktop = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    int currentDesktopNum = atoi(currentDesktop);

    int currentActivityNum;
    const int targetActivityNum = 1;
    bool currentFound = false;
    for(int index = 1; index <= numOfActivities; index++) {
        if (currentDesktopNum <= (desktopsInActivity * index) && currentFound == false) {
            currentActivityNum = index;
            currentFound = true;
        }
        if (currentFound == true) {
            break;
        }
    }
    const int activityChangeDiff = targetActivityNum - currentActivityNum;
    const int newDesktop = currentDesktopNum + (activityChangeDiff * desktopsInActivity);
    return newDesktop;
}


int main(int argc, char* argv[])
{
    const int numOfActivities = 3;
    const int desktopsInActivity = 4;
    const int moduleDesktopNum = atoi(argv[1]);
    setbuf(stdout, NULL); // disable buffering on stdout, required by waybar
    char* text;
    char* class;
    const int milliseconds = 550;
    // infinite loop
    for(;;) {
        if (argv[1][0] == '1') {
            text = "一";
        }
        else if (argv[1][0] == '2') {
            text = "二";
        }
        else if (argv[1][0] == '3') {
            text = "三";
        }
        else if (argv[1][0] == '4') {
            text = "四";
        }
        const int currentDesktopNum = getCurrentDesktopNum(numOfActivities, desktopsInActivity);
        if (moduleDesktopNum == currentDesktopNum) {
            text = "◈";
            class = "virt-desktop-active";
        }
        printf("{\"text\": \" %s \", \"class\": \"%s\"}\n", text, class);
        // sleep(1); // whole seconds
        usleep(milliseconds * 1000);
    }
    return 0; // should never be reached
}
