//
//  NSColorList+RMRHexColor.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "NSColorList+RMRHexColor.h"

// Helper
#import "NSColor+Hexadecimal.h"
#import "NSString+RMRHelpers.h"

// Model
#import "RMRHexColor.h"


@implementation NSColorList (RMRHexColor)

- (void)fillWithHexColors:(NSArray *)hexColorList
                   prefix:(NSString *)prefix
{
    prefix = [prefix uppercaseString];

    for (RMRHexColor *hexColor in hexColorList) {
        NSColor *color = [NSColor colorWithHexString:hexColor.colorValue];
        NSString *colorName =
            [prefix stringByAppendingString:[hexColor.colorTitle RMR_uppercaseFisrtSymbol]];
        
        CGFloat red = [color redComponent];
        CGFloat green = [color greenComponent];
        CGFloat blue = [color blueComponent];
        CGFloat alpha = [color alphaComponent];
        color = [NSColor colorWithCalibratedRed:red
                                          green:green
                                           blue:blue
                                          alpha:alpha];

        [self setColor:color forKey:colorName];
    }
}

@end
