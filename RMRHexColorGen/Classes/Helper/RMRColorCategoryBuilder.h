//
//  RMRColorCategoryBuilder.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface RMRColorCategoryBuilder : NSObject

- (instancetype)init RMR_UNAVAILABLE_INSTEAD("use initWithPrefix:categoryName:");

- (instancetype)initWithPrefix:(NSString *)prefix categoryName:(NSString *)categoryName RMR_DESIGNATED_INITIALIZER;

- (NSError *)generateColorCategoryForColors:(NSArray *)colorList outputPath:(NSString *)outputPath;

@end
