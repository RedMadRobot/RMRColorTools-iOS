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
NSString *const kRMRArgumentHelpShort = @"-h";
NSString *const kRMRArgumentHelp = @"-help";

// Prefix
NSString *const kRMRArgumentPrefixShort = @"p";
NSString *const kRMRArgumentPrefix = @"prefix";

// Input path
NSString *const kRMRArgumentInputPathShort = @"i";
NSString *const kRMRArgumentInputPath = @"input";

// Output path
NSString *const kRMRArgumentOutputPathShort = @"o";
NSString *const kRMRArgumentOutputPath = @"output";

// Generate .clr file
NSString *const kRMRArgumentClr = @"-clr";


@implementation RMRHexColorGenParameters

NSString *firstNotNilParameter(NSString *first, NSString *second)
{
    return first ? first : second ? second : nil;
}

+ (instancetype)obtainParameters
{
    RMRHexColorGenParameters *parameters = [[RMRHexColorGenParameters alloc] init];

    NSArray *argumentList = [NSProcessInfo processInfo].arguments;
    parameters.printHelp =
        argumentList.count == 1 // No params
        || [argumentList containsObject:kRMRArgumentHelpShort]
        || [argumentList containsObject:kRMRArgumentHelp];

    parameters.needClr = [argumentList containsObject:kRMRArgumentClr];

    NSDictionary *arguments = [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSArgumentDomain];

    parameters.prefix = firstNotNilParameter(arguments[kRMRArgumentPrefixShort], arguments[kRMRArgumentPrefix]);
    parameters.inputPath = firstNotNilParameter(arguments[kRMRArgumentInputPathShort], arguments[kRMRArgumentInputPath]);
    parameters.outputPath = firstNotNilParameter(arguments[kRMRArgumentOutputPathShort], arguments[kRMRArgumentOutputPath]);

    return parameters;
}

@end
