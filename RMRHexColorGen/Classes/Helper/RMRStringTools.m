//
//  RMRStringTools.m
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 12.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

#import "RMRStringTools.h"

@implementation NSString(HexValues)

- (CGFloat)hexAsNormalizedFloatValue {
    
    if(self.length != 2) {
        return 1.0;
    }
    NSString *hexValue = [@"0x" stringByAppendingString:self];
    NSScanner *scanner = [NSScanner scannerWithString: hexValue];
    
    float result;
    [scanner scanHexFloat:&result];
    
    return (CGFloat)result/255.0;
}

@end
