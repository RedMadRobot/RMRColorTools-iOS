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

- (NSArray *)parseColors:(id)rawData
{
    NSArray *lines =
        [rawData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return [lines rx_mapWithBlock:^id(id each) { return [self parseColor:each]; }];
}

- (RMRHexColor *)parseColor:(id)rawData
{
    if (![rawData length]) return nil;

    NSRegularExpression *expr =
        [NSRegularExpression regularExpressionWithPattern:@"\\s*([a-f0-9]{3,8})\\s*(.*)\\s*"
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];

    __block NSString *colorValue = nil;
    __block NSString *colorTitle = nil;

    void(^enumerateBlock)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) =
        ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result.numberOfRanges == 3) {
                colorValue   = [rawData substringWithRange:[result rangeAtIndex:1]];
                colorTitle = [rawData substringWithRange:[result rangeAtIndex:2]];
            }
        };

    [expr enumerateMatchesInString:rawData
                           options:0
                             range:NSMakeRange(0, [rawData length])
                        usingBlock:enumerateBlock];

    if (!colorTitle || !colorValue) {
        printf("Can't parse data %s\n", [rawData cStringUsingEncoding:NSUTF8StringEncoding]);
        return nil;
    }


    RMRHexColor *color = [[RMRHexColor alloc] init];
    color.colorTitle = colorTitle;
    color.colorValue = colorValue;
    
    return color;
}

@end
