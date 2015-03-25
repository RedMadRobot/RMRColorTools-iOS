//
//  RMRHexColorGenParameters.h
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface RMRHexColorGenParameters : NSObject

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, assign) BOOL printHelp;
@property (nonatomic, assign) BOOL needClr;


+ (instancetype)obtainParameters;

@end
