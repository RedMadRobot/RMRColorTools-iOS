//
//  RMRColorCategoryBuilder.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;

#import "RMRHexColorGenParameters.h"

@interface RMRObjcCodeBuilder : NSObject

- (instancetype)init RMR_UNAVAILABLE_INSTEAD("use initWithPrefix:categoryName:");

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters RMR_DESIGNATED_INITIALIZER;

- (NSError *)generateColorCategoryForColors:(NSArray *)colorList;

@end
