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
    printf("Usage: %s [-i <path>] [-o <path>] [-n <name>] [-f <format>] [-p <prefix>] [-clr]\n", utilName);
    printf("       %s -h\n\n", utilName);
    printf("Required Parameters:\n");
    printf("    -o <path>   Output files at <path>\n");
    printf("    -i <path>   Path to txt colors list file with format:\n\t\t#RRGGBBAA ColorName\n\t\t#RRGGBBAA ColorName\n\t\t$ColorName NewColorName\n");
    printf("    -n <name>   The Name of your Assets Catalog / ObjC Category / Swift Extension / Swift File / XML File, depending on Output Format.\n");
    printf("    -f <format> Output Format.  Valid values are swift-enum, swift-extension, objc, assets, android.\n");
    printf("Options:\n");
    printf("    -p <prefix> Use <prefix> as the class prefix in the generated code (not used on Android)\n");
    printf("    -vnn        Use this flag if you need to generate colors using RGB values and not Named Colors.  i.e. pre-iOS 11.0 (ignored for Android)\n");
    printf("    -osx        Use this flag if you need to generate code for OSX.  I.e. NSColor not UIColor.  Note: Alternate Colors not supported. (Ignored for Android)\n");
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
