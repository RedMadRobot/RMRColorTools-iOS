//
//  RMRHexColor.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRHexColor.h"


@implementation RMRHexColor

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass: [RMRHexColor class]] == NO) { return false; }
    
    RMRHexColor *other = (RMRHexColor*)object;
    return (
            [self.colorTitle isEqualToString: other.colorTitle] &&
            [self.colorValue isEqualToString: other.colorValue] &&
            [self.alternateColorValue isEqualToString: other.alternateColorValue] &&
            [self.comments isEqualToString: other.comments] &&
            self.isAlias == other.isAlias
            );
    
}

- (NSUInteger)hash {
    return self.colorTitle.hash ^ self.colorValue.hash ^ self.alternateColorValue.hash ^ self.comments.hash ^ (NSUInteger)self.isAlias;
}

@end
