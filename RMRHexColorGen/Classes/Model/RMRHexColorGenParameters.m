//
//  RMRHexColorGenParameters.m
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRHexColorGenParameters.h"


#pragma mark — Constants

// Help
static NSString * const kRMRArgumentHelpShort = @"-h";
static NSString * const kRMRArgumentHelp      = @"-help";

// Prefix
static NSString * const kRMRArgumentPrefixShort = @"p";
static NSString * const kRMRArgumentPrefix      = @"prefix";

// Input path
static NSString * const kRMRArgumentInputPathShort = @"i";
static NSString * const kRMRArgumentInputPath      = @"input";

// Output path
static NSString * const kRMRArgumentOutputPathShort = @"o";
static NSString * const kRMRArgumentOutputPath      = @"output";

// Generate .clr file
static NSString * const kRMRArgumentClr = @"-clr";


@implementation RMRHexColorGenParameters

+ (instancetype)obtainParameters
{
    RMRHexColorGenParameters *parameters = [[RMRHexColorGenParameters alloc] init];

    NSArray *argumentList = [[NSProcessInfo processInfo] arguments];
    parameters.printHelp =
        [argumentList count] == 1 // No params
        || [argumentList containsObject:kRMRArgumentHelpShort]
        || [argumentList containsObject:kRMRArgumentHelp];

    parameters.needClr = [argumentList containsObject:@"-clr"];

    NSDictionary *arguments =
        [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSArgumentDomain];

    parameters.prefix =
        firstNotNilParameter(arguments[kRMRArgumentPrefixShort], arguments[kRMRArgumentPrefix]);

    parameters.inputPath =
        firstNotNilParameter(arguments[kRMRArgumentInputPathShort], arguments[kRMRArgumentInputPath]);

    parameters.outputPath =
        firstNotNilParameter(arguments[kRMRArgumentOutputPathShort], arguments[kRMRArgumentOutputPath]);

    return parameters;
}


#pragma mark — Private helper

NSString *firstNotNilParameter(NSString *first, NSString *second) {
    return first ? first : second ? second : nil;
}

@end
