//
//  RMRHexColorGenParameters.h
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, RMRHexColorGenFormat) {
    RMRHexColorGenFormatInvalid,
    RMRHexColorGenFormatObjectiveCCategory,
    RMRHexColorGenFormatSwiftExtension,
    RMRHexColorGenFormatSwiftEnum,
    RMRHexColorGenFormatAssetCatalog,
    RMRHexColorGenFormatAndroid
};

@interface RMRHexColorGenParameters : NSObject

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;
// for obj-C/Swift it's a prefix
@property (nonatomic, copy) NSString *prefix;

/** name is used in different ways, depending on output format:
 outputFormat: RMRHexColorGenFormatObjectiveC
 name is used in the output filename:  UIColor+name.h/m and in category name UIColor(name)
 
 outputFormat: RMRHexColorGenFormatSwift
 name is used in the output filename: UIColor+name.swift
 
 outputFormat: RMRHexColorGenFormatAssetCatalog
 name is used in the output filename: name.swift and in assets catalog name: name.xcassets
 and in the generated enum in name.swift
 internal enum <name> { ... }
 
 */
@property (nonatomic, copy) NSString *name;  // if nil, defaults to MyAppColors

@property (nonatomic, assign) BOOL printHelp;
@property (nonatomic, assign) BOOL needClr;
@property (nonatomic, assign) BOOL useValuesNotNames;  // will use colorWithRed:... instead of colorNamed:
@property (nonatomic, assign) RMRHexColorGenFormat outputFormat;
@property (nonatomic, assign) BOOL isForOSX;  // generates NSColor instead of UIColor

+ (instancetype)obtainParameters;

@end
