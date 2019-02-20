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

// Output Format and allowed values
static NSString * const kRMRArgumentFormatShort = @"f";
static NSString * const kRMRArgumentFormat      = @"format";
static NSString * const kRMRArgumentValueSwift  = @"swift";
static NSString * const kRMRArgumentValueObjC   = @"objc";
static NSString * const kRMRArgumentValueAssets = @"assets";

// Catalog Name
static NSString * const kRMRArgumentNameShort = @"n";
static NSString * const kRMRArgumentName      = @"name";


@implementation RMRHexColorGenParameters

+ (RMRHexColorGenFormat)parseFormatFromString:(NSString*)formatString {
    
    RMRHexColorGenFormat defaultFormat = RMRHexColorGenFormatInvalid;
    
    if (formatString == nil) {
        return defaultFormat;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueObjC]) {
        return RMRHexColorGenFormatObjectiveC;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueSwift]) {
        return RMRHexColorGenFormatSwift;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueAssets]) {
        return RMRHexColorGenFormatAssetCatalog;
    }
    
    return defaultFormat;
}

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
    
    parameters.outputFormat =
    [self parseFormatFromString: firstNotNilParameter(arguments[kRMRArgumentFormatShort],
                                                      arguments[kRMRArgumentFormat])];
    
    parameters.name =
    firstNotNilParameter(arguments[kRMRArgumentNameShort], arguments[kRMRArgumentName]);
    
    if (parameters.name == nil) {
        parameters.name = @"MyAppColors";
    }
    
    // make sure you're using it correctly.
    if(parameters.outputFormat == RMRHexColorGenFormatInvalid ||
       parameters.inputPath == nil ||
       parameters.outputPath == nil) {
        parameters.printHelp = YES;
    }
    
    
    return parameters;
}


#pragma mark — Private helper

NSString *firstNotNilParameter(NSString *first, NSString *second) {
    return first ? first : second ? second : nil;
}

@end
