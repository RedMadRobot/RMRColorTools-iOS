//
//  RMRHexColorParser.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

@class RMRHexColor;


@interface RMRHexColorParser : NSObject

- (NSArray *)parseColors:(id)rawData;
- (RMRHexColor *)parseColor:(id)rawData;

@end
