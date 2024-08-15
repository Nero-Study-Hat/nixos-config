#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// cmd for testing (dev dir): gcc desktop-switcher.c -o demo && ./demo "arg1" "arg2" && rm demo
// use `which gcc` to get compiler path for vscode

void echoCorrectInputs(const char* validArgs[], const int numOfValidArgs, const char* issue, const bool failExit) {
    printf("valid examples of %s: ", issue);
    for (int index = 0; index < numOfValidArgs; index++) {
        if (index == (numOfValidArgs - 1)) {
            printf("%s\n", validArgs[index]);
            break;
        }
        printf("%s, ", validArgs[index]);
    }
    if (failExit == true) {
        exit(1);
    }
}

void inputCheck(char* args[], const int numOfDesktops) {
    const bool debugCheckOne = args[2] != NULL && strcmp(args[2],"debug") == 0;
    const bool debugCheckTwo = args[3] != NULL && strcmp(args[3],"debug") == 0;
    if (debugCheckOne == false && debugCheckTwo == false) {
            const char debugArg[] = "exe-path arg-one debug\nexe-path arg-one arg-two debug\n";
            printf("you can enable input checking if things go wrong with the 'debug' arg like below\n%s\n", debugArg);
            return;
    }
    // interger arg one
    const int argOneInt = atoi(args[1]);
    if (argOneInt != 0) {
        if (args[2] != NULL && strcmp(args[2], "debug") != 0) {
            printf("warning: unrequired arguement(s) given past the first\n");
        }
        if (argOneInt > 0 && argOneInt <= numOfDesktops) {
            return;
        }
        if (argOneInt < 0 || argOneInt > numOfDesktops) {
            printf("error: arguement one integer is invalid\n");
            printf("valid integer arguement one can be: an interger between and including 1 and %i\n", numOfDesktops);
            exit(1);
        }
    }
    // string arg one
    const char* validArgOnes[] = {"focus", "window"};
    const int numOfValidArgOne = 2;
    bool isArgOneValid = false;
    for (int index = 0; index < 2; index++) {
        if (strcmp(validArgOnes[index], args[1]) == 0) {
            isArgOneValid = true;
            break;
        }
    }
    if (isArgOneValid == false) {
        printf("error: arguement one string is invalid\n");
        echoCorrectInputs(validArgOnes, numOfValidArgOne, "arguement one", false);
    }
    if (args[4] != NULL) {
        printf("warning: unrequired arguement given: more than three\n");
    }
    // string arg two
    const char* validArgTwos[] = {"up", "down", "left", "right", "activityRofi"};
    const int numOfValidArgTwos = 5;
    if (argOneInt == 0 && args[2] == NULL) {
        printf("error: missing second cmd argument\n");
        echoCorrectInputs(validArgTwos, numOfValidArgTwos, "arguement two", false);
    }
    bool isArgTwoValid = false;
    if (strcmp(args[2], "debug") == 0 && argOneInt == 0) {
        printf("error: with a string in arg one you need a string in arg two; the debug arg can be used as the third arg\n");
        echoCorrectInputs(validArgTwos, numOfValidArgTwos, "arguement two", true);
    }
    for (int index = 0; index < 5; index++) {
        if (strcmp(validArgTwos[index], args[2]) == 0) {
            isArgTwoValid = true;
            break;
        }
        printf("error: arguement two string is invalid\n");
        echoCorrectInputs(validArgTwos, numOfValidArgTwos, "arguement two", true);
    }
}

int getCurrentDesktopNum() {
    char buffer[12];
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    const char* currentDesktop = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    const int currentDesktopNum = atoi(currentDesktop);
    return currentDesktopNum;
}

char* getChosenActivity(char* inputCmd) {
    char execCmd[100];
    char rofiCmd[] = "rofi -dmenu -p 'Choose activity'";
    sprintf(execCmd, "%s | %s", inputCmd, rofiCmd);

    char buffer[150];
    FILE *cmd=popen(execCmd, "r");
    char* chosenActivity = fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    chosenActivity[strcspn ( chosenActivity, "\n" )] = '\0';
    char* rtnPtr = malloc(150);
    strcpy(rtnPtr, chosenActivity);
    return rtnPtr;
}

int changeDesktopActivity(const int currentDesktopNum, const int numOfActivities, const int desktopsInActivity, const int chooseActivity, const char* activities[]) {
    char* chosenActivity;
    bool targetFound = false;
    int targetActivityNum;
    if (chooseActivity == 0) {
        char echoCmd[50];
        sprintf(echoCmd, "printf ");
        strcat(echoCmd, "\"");
        for(int index = 0; index < numOfActivities; index++) {
            strcat(echoCmd, activities[index]);
            strcat(echoCmd, "\\n");
        }
        strcat(echoCmd, "\"");
        chosenActivity = getChosenActivity(echoCmd);

    }
    else {
        targetActivityNum = chooseActivity;
        targetFound = true;
    }
    int currentActivityNum;
    bool currentFound = false;
    for(int counter = 1; counter <= numOfActivities; counter++) {
        if (currentFound == false && currentDesktopNum <= (desktopsInActivity * counter)) {
            currentActivityNum = counter;
            currentFound = true;
        }
        if (targetFound == false && strcmp(activities[counter-1], chosenActivity) == 0) {
            targetActivityNum = counter;
            targetFound = true;
        }
        if (currentFound == true && targetFound == true) {
            break;
        }
    }

    const int activityChangeDiff = targetActivityNum - currentActivityNum;
    const int newDesktop = currentDesktopNum + (activityChangeDiff * desktopsInActivity);
    // printf("new desk: %i\n", newDesktop);
    return newDesktop;
}

void pluginCmd(char* userCmd, const int target) {
    // printf("final func cmd: %s\n", userCmd);
    // printf("final func target: %i\n", target);
    if (target < 0) {
        printf("invalid final result: target desktop is %i", target);
        exit(1);
    }
    char execCmd[50];
    if (strcmp(userCmd, "focus") == 0) {
        sprintf(execCmd, "hyprctl dispatch vdesk %i", target);
    }
    if (strcmp(userCmd, "window") == 0) {
        sprintf(execCmd, "hyprctl dispatch movetodesk %i", target);
    }
    // printf("end cmd: %s", execCmd);
    const int result = system(execCmd);
    exit(1);
}

/** 
 * @param   cmd             operation to do with target_value
 * @param   target_value    value for cmd (direction or activity change)
*/
int main(int argc, char* argv[])
{
    // USER SETTINGS
    const int columns = 2;
    const int rows = 2;
    const bool wrapEnable = true;

    const bool activitiesEnable = true;
    // can comment out below settings if activitiesEnable is set to false
    const int numOfActivities = 3;
    const char* activities[] = {"tech", "writing", "slack"};
    // --

    const int numOfDesktopsInActivity = 4;
    if (argv[1] == NULL) {
        const char debugArg[] = "exe-path arg-one debug\nexe-path arg-one arg-two debug\n";
        printf("you can enable input checking if things go wrong with the 'debug' arg like below\n%s\n", debugArg);
        printf("error: no arguments have been passed in\n");
        const char* validArgOnes[] = {"focus", "window"};
        const int numOfValidArgOne = 2;
        printf("valid arguement one with no arguement two (unless debug) can be: an interger between and including 1 and %i\n", numOfDesktopsInActivity);
        echoCorrectInputs(validArgOnes, numOfValidArgOne, "arguement one", false);
        const char* validArgTwos[] = {"up", "down", "left", "right", "activityRofi"};
        const int numOfValidArgTwos = 5;
        echoCorrectInputs(validArgTwos, numOfValidArgTwos, "arguement two", true);
    }
    inputCheck(argv, numOfDesktopsInActivity);
    char inputCmd[10];
    strcpy(inputCmd, argv[1]);
    char inputTargetValue[15];
    strcpy(inputTargetValue, argv[2]);

    const int currentDesktopNum = getCurrentDesktopNum();
    const int desktopsInActivity = rows * columns;

    const int targetDeskInGroup = atoi(inputCmd);
    if (targetDeskInGroup > 0 && targetDeskInGroup <= desktopsInActivity) {
        int currentActivityNum;
        for(int index = 0; index < numOfActivities; index++) {
            if (currentDesktopNum < (desktopsInActivity * index)) {
                currentActivityNum = index;
                break;
            }
        }
        int groupEnd = currentActivityNum * desktopsInActivity;
        int groupStart = groupEnd - (desktopsInActivity - 1);
        int newDesktop = groupStart + (targetDeskInGroup - 1);
        pluginCmd("focus", newDesktop);
    }

    // converts any desktop # to its equivalent in activity 1 if activities are enabled
    int normalizedCurrentDesktop = currentDesktopNum;
    if (strcmp(inputTargetValue, "activityRofi") == 0 && activitiesEnable == true) {
        const int newDesktop = changeDesktopActivity(currentDesktopNum, numOfActivities, desktopsInActivity, 0, activities);
        pluginCmd(inputCmd, newDesktop);
    }
    else if (activitiesEnable == true) {
        normalizedCurrentDesktop = changeDesktopActivity(currentDesktopNum, numOfActivities, desktopsInActivity, 1, activities);
    }

    int targetDesktopNum;
    int modifierNum;
    for (int i = 1; i < (rows + 1); i++) {
        // left most colum
        const int leftColNum = i * columns - (columns - 1);
        if (leftColNum == normalizedCurrentDesktop && 0 == strcmp(inputTargetValue, "left")) {
            if (wrapEnable == true) {
                targetDesktopNum = currentDesktopNum + (columns - 1);
                pluginCmd(inputCmd, targetDesktopNum);
            }
            else {
                return 0;
            }
        }
        // right most column
        const int rightColNum = i * columns;
        if (rightColNum == normalizedCurrentDesktop && 0 == strcmp(inputTargetValue, "right")) {
            if (wrapEnable == true) {
                targetDesktopNum = currentDesktopNum - (columns - 1);
                pluginCmd(inputCmd, targetDesktopNum);
            }
            else {
                return 0;
            }
        }
    }

    // top row
    if (normalizedCurrentDesktop >= 1 && normalizedCurrentDesktop <= columns && 0 == strcmp(inputTargetValue, "up")) {
        if (wrapEnable == true) {
            targetDesktopNum = currentDesktopNum + (columns * (rows -1));
            pluginCmd(inputCmd, targetDesktopNum);
        }
        else {
            return 0;
        }
    }
    // bottom row
    else if (normalizedCurrentDesktop >= (columns * (rows - 1) + 1) && normalizedCurrentDesktop <= (rows * columns) && 0 == strcmp(inputTargetValue, "down")) {
        if (wrapEnable == true) {
            targetDesktopNum = currentDesktopNum - (columns * (rows -1));
            pluginCmd(inputCmd, targetDesktopNum);
        }
        else {
            return 0;
        }
    }

    if (strcmp(inputTargetValue, "right") == 0) {
        modifierNum = 1;
    }
    else if (strcmp(inputTargetValue, "left") == 0) {
        modifierNum = -1;
    }
    else if (strcmp(inputTargetValue, "up") == 0) {
        modifierNum = rows * -1;
    }
    else if (strcmp(inputTargetValue, "down") == 0) {
        modifierNum = rows;
    }

    targetDesktopNum = currentDesktopNum + modifierNum;
    pluginCmd(inputCmd, targetDesktopNum);

    return 0;
}
