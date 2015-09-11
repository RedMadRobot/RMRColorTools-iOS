//
//  RMRHexColorGen.m
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRHexColorGen.h"

#import "NSColorList+RMRHexColor.h"
#import "NSString+RMRHelpers.h"
#import "RMRColorCategoryBuilder.h"
#import "RMRHexColorGenParameters.h"
#import "RMRStyleSheetReader.h"


@interface RMRHexColorGen ()

#pragma mark — Properties

@property (nonatomic, strong) RMRHexColorGenParameters *parameters;

@end


@implementation RMRHexColorGen

- (instancetype)initWithParameters:(RMRHexColorGenParameters *)parameters
{
    self = [super init];
    if (!self) return nil;

    self.parameters = parameters;

    return self;
}

- (int)generateFiles
{
    RMRHexColorGenParameters *parameters = self.parameters;

    NSError *error = nil;

    RMRStyleSheetReader *styleSheetReader = [[RMRStyleSheetReader alloc] init];
    NSArray *colors = [styleSheetReader obtainColorsFromFileAtPath:parameters.inputPath error:&error];
    if ([self checkError:error]) return EXIT_FAILURE;


    NSString *colorListName =
        [[parameters.prefix uppercaseString]?:@""
            stringByAppendingString:
                [[[parameters.inputPath stringByDeletingPathExtension] lastPathComponent] RMR_uppercaseFisrtSymbol]];


    [[NSFileManager defaultManager] createDirectoryAtPath:parameters.outputPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if ([self checkError:error]) return EXIT_FAILURE;


    RMRColorCategoryBuilder *colorCategoryBuilder =
        [[RMRColorCategoryBuilder alloc] initWithPrefix:parameters.prefix categoryName:colorListName];
    error = [colorCategoryBuilder generateColorCategoryForColors:colors
                                                      outputPath:parameters.outputPath];
    if ([self checkError:error]) return EXIT_FAILURE;


    if (!parameters.needClr) return EXIT_SUCCESS;

    NSColorList *colorList = [[NSColorList alloc] initWithName:colorListName];
    [colorList fillWithHexColors:colors prefix:parameters.prefix?:@""];
    [colorList writeToFile:nil];

    return EXIT_SUCCESS;
}


#pragma mark — Private helper

- (BOOL)checkError:(NSError *)error
{
    if (error) {
        printf("%s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
        return YES;
    } return NO;
}

@end
