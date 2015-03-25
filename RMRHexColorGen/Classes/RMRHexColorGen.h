//
//  RMRHexColorGen.h
//  RMRColorTools
//
//  Created by Roman Churkin on 25/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

@class RMRHexColorGenParameters;


@interface RMRHexColorGen : NSObject

- (instancetype)init RMR_UNAVAILABLE_INSTEAD("initWithParameters:");

- (instancetype)initWithParameters:(RMRHexColorGenParameters *)parameters RMR_DESIGNATED_INITIALIZER;

- (int)generateFiles;

@end
