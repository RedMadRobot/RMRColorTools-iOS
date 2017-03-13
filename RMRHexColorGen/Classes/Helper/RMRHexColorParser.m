//
//  RMRHexColorParser.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRHexColorParser.h"

#import "RXCollection.h"

// Model
#import "RMRHexColor.h"


@implementation RMRHexColorParser

- (NSArray *)parseColors:(NSString *)string
{
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return [lines rx_mapWithBlock:^id(id each) {
        return [self parseColor:each];
    }];
}

- (RMRHexColor *)parseColor:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }

    NSRegularExpression *expr =
        [NSRegularExpression regularExpressionWithPattern:@"\\s*([a-f0-9]{3,8})\\s*(.*)\\s*"
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];

    RMRHexColor *color = [[RMRHexColor alloc] init];

    void (^enumerateBlock)(NSTextCheckingResult *, NSMatchingFlags, BOOL *) =
        ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result.numberOfRanges == 3) {
                color.colorValue = [string substringWithRange:[result rangeAtIndex:1]];
                color.colorTitle = [string substringWithRange:[result rangeAtIndex:2]];
            }
        };

    [expr enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:enumerateBlock];

    if (!color.colorTitle || !color.colorValue) {
        printf("Can't parse data %s\n", [string cStringUsingEncoding:NSUTF8StringEncoding]);
        return nil;
    }

    return color;
}

@end
