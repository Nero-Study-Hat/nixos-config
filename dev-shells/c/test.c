#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>

/* bash approach to getting variables from a file
cat switcher-settings.txt | grep "column" | awk -F "=" {'print $2'}
*/

struct settings {
    const int columns;
    const int rows;
    const bool wrapEnable;
    const bool activitiesEnable;
    const int numOfActivities;
    const char* activities[];
};

int setActivities(char activities[15][40]) {
    char bufferActivityName[40];
    char addActivity[1] = "y";
    for (int index = 0; index < 15; index++) {
        printf("Create an activity with the name: ");
        if (fgets(bufferActivityName, 40, stdin))
        {
            bufferActivityName[strcspn(bufferActivityName, "\n")] = 0;
            strcpy(activities[index], bufferActivityName);
        }

        printf("Another activity ('n' to escape): ");
        int addPromptResult = scanf("%1[yn]", addActivity);
        int c;
        printf("\33[2K\r");
        while((c = getchar()) != '\n' && c != EOF);
        if (addActivity[0] == "n"[0]) {
            return index + 1;
        }
    }
    return 14;
}

int main(int argc, char* argv[]) {
    char activities[15][40];
    int numOfActivities = setActivities(activities);
    printf("\nchecking the data: \n");
    for (int i = 0; i < numOfActivities; i++) {
        printf("%s\n", activities[i]);
        if (strcmp(activities[i+1], "") == 0 || strcmp(activities[i+1], "@") == 0) {
            break;
        }
    }

    return 0;
}
