//
//  RMRSwiftCodeBuilder.h
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 20.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMRHexColorGenParameters.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RMRSwiftOutputType) {
    RMRSwiftOutputTypeStandalone,
    RMRSwiftOutputTypeAssetsCatalogNamedColors
};

@interface RMRSwiftCodeBuilder : NSObject

- (instancetype)init RMR_UNAVAILABLE_INSTEAD("use initWithPrefix:swiftFilename:outputType:");

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters outputType:(RMRSwiftOutputType)swiftOutputType;
- (NSError *)generateSwiftCodeForColors:(NSArray *)colorList;

@end

NS_ASSUME_NONNULL_END
