//
//  main.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

#import <libgen.h>
#import "RMRHexColorGen.h"
#import "RMRHexColorGenParameters.h"


#pragma mark — Helper

void printHelp(char *utilName) {
    printf("Usage: %s [-i <path>] [-o <path>] [-p <prefix>] [-clr]\n", utilName);
    printf("       %s -h\n\n", utilName);
    printf("Options:\n");
    printf("    -o <path>   Output files at <path>\n");
    printf("    -i <path>   Path to txt colors list file with format:\n\t\t#AARRGGBB ColorName\n\t\t#AARRGGBB ColorName\n");
    printf("    -p <prefix> Use <prefix> as the class prefix in the generated code\n");
    printf("    -clr        Use this flag if you need to generate and install CLR file\n");
    printf("    -h          Print this help and exit\n");
}


#pragma mark — Main

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        RMRHexColorGenParameters *parameters = [RMRHexColorGenParameters obtainParameters];

        if (parameters.printHelp) {
            printHelp(basename((char *)argv[0]));
            return EXIT_SUCCESS;
        }

        RMRHexColorGen *hexColorGen = [[RMRHexColorGen alloc] initWithParameters:parameters];
        return [hexColorGen generateFiles];
    }

    return EXIT_SUCCESS;
}
