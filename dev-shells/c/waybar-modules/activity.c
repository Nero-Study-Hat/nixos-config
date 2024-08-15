#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>

int getCurrentDesktopNum() {
    char buffer[12];
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    const char* currentDesktop = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    return atoi(currentDesktop);
}

char* getCurrentActivity(const int currentDesktopNum, const int numOfActivities, const int desktopsInActivity, const char* activities[]) {
    char* currentActivity;
    for(int counter = 1; counter <= numOfActivities; counter++) {
        if (currentDesktopNum <= (desktopsInActivity * counter)) {
            currentActivity = activities[counter-1];
            break;
        }
    }
    // printf("new desk: %i\n", newDesktop);
    return currentActivity;
}


int main()
{
    const int numOfActivities = 3;
    const int desktopsInActivity = 4;
    const char* activities[] = {"TECH", "WRITING", "SLACK"};
    setbuf(stdout, NULL); // disable buffering on stdout, required by waybar
    char* text;
    const char* class = "activity";
    const int milliseconds = 550;
    char* currentActivity;
    // infinite loop
    for(;;) {
        currentActivity = getCurrentActivity(getCurrentDesktopNum(), numOfActivities, desktopsInActivity, activities);
        text = currentActivity;
        printf("{\"text\": \" %s \", \"class\": \"%s\"}\n", text, class);
        // sleep(1); // whole seconds
        usleep(milliseconds * 1000);
    }
    return 0; // should never be reached
}
