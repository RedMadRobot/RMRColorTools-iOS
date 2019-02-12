//
//  RMRAssetCategoryBuilder.h
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 12.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RMRHexColorGenParameters;

@interface RMRAssetCategoryBuilder : NSObject

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters;
- (NSError*)generateAssetsCatalogWithColors:(NSArray*)colors;

@end

NS_ASSUME_NONNULL_END
