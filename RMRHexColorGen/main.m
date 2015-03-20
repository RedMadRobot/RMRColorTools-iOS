//
//  main.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

#import <libgen.h>

#import "RMRStyleSheetReader.h"
#import "RMRColorCategoryBuilder.h"
#import "NSColorList+RMRHexColor.h"
#import "NSString+RMRHelpers.h"


#pragma mark — Helper

NSString* firstNotNilParameter( NSString* first, NSString* second )
{
    return first ? first : second ? second : nil;
}


int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSArray* argumentList = [[NSProcessInfo processInfo] arguments];

        BOOL printHelp =
            [argumentList count] == 0
            || [argumentList containsObject:@"-h"]
            || [argumentList containsObject:@"-help"];

        if (printHelp) {
            printf("Usage: %s [-i <path>] [-o <path>] [-p <prefix>] [-clr]\n", basename((char *)argv[0]));
            printf("       %s -h\n\n", basename((char *)argv[0]));
            printf("Options:\n");
            printf("    -o <path>   Output files at <path>\n");
            printf("    -i <path>   Path to txt colors list file with format:\n\t\t#AARRGGBB ColorName\n\t\t#AARRGGBB ColorName\n");
            printf("    -p <prefix> Use <prefix> as the class prefix in the generated code\n");
            printf("    -clr        Use this flag if you need to generate and install CLR file\n");
            printf("    -h          Print this help and exit\n");

            return EXIT_SUCCESS;
        }

        NSDictionary* arguments =
            [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSArgumentDomain];

        NSString *prefix =  firstNotNilParameter(arguments[@"p"], arguments[@"prefix"]);
        prefix = prefix;

        NSString *inputPath = firstNotNilParameter(arguments[@"i"], arguments[@"input"]);
        if (!inputPath) {
            printf("%s\n", "-i required argumet");
            return EXIT_FAILURE;
        }

        NSString *outputPath = firstNotNilParameter(arguments[@"o"], arguments[@"output"]);
        if (!outputPath) {
            printf("%s\n", "-o required argumet");
            return EXIT_FAILURE;
        }

        NSError *error = nil;
        RMRStyleSheetReader *styleSheetReader = [[RMRStyleSheetReader alloc] init];
        NSArray *colors = [styleSheetReader obtainColorsFromFileAtPath:inputPath error:&error];

        if (error) {
            printf("%s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
            return EXIT_FAILURE;
        }

        NSString *colorListName =
            [[prefix uppercaseString]?:@""
                stringByAppendingString:
                    [[[inputPath stringByDeletingPathExtension] lastPathComponent] RMR_uppercaseFisrtSymbol]];

        RMRColorCategoryBuilder *colorCategoryBuilder =
            [[RMRColorCategoryBuilder alloc] initWithPrefix:prefix categoryName:colorListName];
        error = [colorCategoryBuilder generateColorCategoryForColors:colors
                                                          outputPath:outputPath];
        if (error) {
            printf("%s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
            return EXIT_FAILURE;
        }

        if (![argumentList containsObject:@"-clr"]) return EXIT_SUCCESS;

        NSColorList *colorList = [[NSColorList alloc] initWithName:colorListName];
        [colorList fillWithHexColors:colors prefix:prefix?:@""];
        [colorList writeToFile:nil];
    }

    return EXIT_SUCCESS;
}
