//
//  RMRStringTools.h
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 12.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(HexValues)

- (CGFloat)hexAsNormalizedFloatValue;  // returns 1.0 if self is not a valid hex string

@end

NS_ASSUME_NONNULL_END
