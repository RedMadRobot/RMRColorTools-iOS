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

// Generate OSX/AppKit colors
static NSString * const kRMRArgumentOSX = @"-osx";

// Generate Values Not Names
static NSString * const kRMRArgumentValuesNotNames = @"-vnn";

// Output Format and allowed values
static NSString * const kRMRArgumentFormatShort             = @"f";
static NSString * const kRMRArgumentFormat                  = @"format";
static NSString * const kRMRArgumentValueSwiftExtension     = @"swift-extension";
static NSString * const kRMRArgumentValueSwiftEnum          = @"swift-enum";
static NSString * const kRMRArgumentValueCategory           = @"objc";
static NSString * const kRMRArgumentValueAssetsCatalog      = @"assets";
static NSString * const kRMRArgumentValueAndroidXML         = @"android";

// Catalog Name
static NSString * const kRMRArgumentNameShort = @"n";
static NSString * const kRMRArgumentName      = @"name";


@implementation RMRHexColorGenParameters

+ (RMRHexColorGenFormat)parseFormatFromString:(NSString*)formatString {
    
    RMRHexColorGenFormat defaultFormat = RMRHexColorGenFormatInvalid;
    
    if (formatString == nil) {
        return defaultFormat;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueCategory]) {
        return RMRHexColorGenFormatObjectiveCCategory;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueSwiftExtension]) {
        return RMRHexColorGenFormatSwiftExtension;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueSwiftEnum]) {
        return RMRHexColorGenFormatSwiftEnum;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueAssetsCatalog]) {
        return RMRHexColorGenFormatAssetCatalog;
    }
    
    if ([formatString isEqualToString:kRMRArgumentValueAndroidXML]) {
        return RMRHexColorGenFormatAndroid;
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
    
    parameters.needClr = [argumentList containsObject:kRMRArgumentClr];
    parameters.isForOSX = [argumentList containsObject:kRMRArgumentOSX];
    parameters.useValuesNotNames = [argumentList containsObject:kRMRArgumentValuesNotNames];
    
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
    
    // if we haven't explicitly overriden this, which is no longer supported though the flag is still in the code.
    if(!parameters.useValuesNotNames) {
        switch (parameters.outputFormat) {
            case RMRHexColorGenFormatSwiftEnum:
            case RMRHexColorGenFormatSwiftExtension:
            case RMRHexColorGenFormatObjectiveCCategory:
                parameters.useValuesNotNames = YES;
            default:
                break;
        }
    }
    
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
