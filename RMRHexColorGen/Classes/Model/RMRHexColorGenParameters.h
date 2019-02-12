//
//  RMRHexColorGenParameters.h
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, RMRHexColorGenFormat) {
    RMRHexColorGenFormatObjectiveC,
    RMRHexColorGenFormatSwift,
    RMRHexColorGenFormatAssetCatalog
};

@interface RMRHexColorGenParameters : NSObject

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;
// for obj-C/Swift it's a prefix
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *catalogName; // for AssetCatalog it's the name.  (Otherwise defaults to MyAppColors.xcassets)

@property (nonatomic, assign) BOOL printHelp;
@property (nonatomic, assign) BOOL needClr;
@property (nonatomic, assign) RMRHexColorGenFormat outputFormat;

+ (instancetype)obtainParameters;

@end
