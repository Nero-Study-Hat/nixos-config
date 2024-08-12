#include <stdio.h>
#include <unistd.h>

static inline char getCurrentDesktopNum() {
    char buffer[12];
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    const char* currentDesktop = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    return buffer[0];
}


int main(int argc, char* argv[])
{
    int currentDesktopNum;
    char* text;
    char* class;
    const int milliseconds = 700;
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
        currentDesktopNum = getCurrentDesktopNum();
        if (argv[1][0] == currentDesktopNum) {
            text = "◈";
            class = "virt-desktop-active";
        }
        printf("{\"text\": \" %s \", \"class\": \"%s\"}\n", text, class);
        // sleep(1); // whole seconds
        usleep(milliseconds * 1000);
    }
    return 0; // should never be reached
}
