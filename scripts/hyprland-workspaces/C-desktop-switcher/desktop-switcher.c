#include<stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// cmd for testing (dev dir): gcc desktop-switcher.c -o demo && ./demo && rm demo

void getStdoutFromCommand(char* str)
{
    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    str = fgets(str, sizeof(str), cmd);
    pclose(cmd);
}

/** 
 * @param   {name} - {description}
 * @param   {name} - {description}
 * @param   {name} - {description}
*/
int main(int argc, char* argv[])
{
    const int columns = 2;
    const int rows = 2;
    const bool wrapEnable = true;

    char currentDesktop[3];
    getStdoutFromCommand(currentDesktop);
    int currentDesktopNum = atoi(currentDesktop);

    printf("%i \n", currentDesktopNum);
    
    return 0;
}

/**
 * Execute a command and get the result.
 *
 * @param   cmd - The system command to run.
 * @return  The string command line output of the command.
 */


/*  Gets the correct value and prints to stdout when used in main()

    FILE *cmd=popen("hyprctl printdesk | awk '{print $3;}' | sed 's/.$//'", "r");
    char result[24]={0x0};
    while (fgets(result, sizeof(result), cmd) !=NULL)
           printf("%s\n", result);
    pclose(cmd);

    // printf("%i", test);
    return 0;

*/