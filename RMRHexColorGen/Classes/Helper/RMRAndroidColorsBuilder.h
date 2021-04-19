//
//  RMRAndroidColorsBuilder.h
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 19.04.21.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMRHexColorGenParameters.h"


NS_ASSUME_NONNULL_BEGIN

@interface RMRAndroidColorsBuilder : NSObject

- (instancetype)init RMR_UNAVAILABLE_INSTEAD("use initWithPrefix:swiftFilename:outputType:");

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters;
- (NSError *)generateAndroidXMLForColors:(NSArray *)colorList;

@end

NS_ASSUME_NONNULL_END
