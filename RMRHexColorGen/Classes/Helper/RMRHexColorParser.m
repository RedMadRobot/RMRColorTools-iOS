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
    NSArray *definedColors = [lines rx_mapWithBlock:^id(id each) { return [self parseColor:each definedColors: nil]; }];
    NSArray *referenceColors = [lines rx_mapWithBlock:^id(id each) { return [self parseColor:each definedColors: definedColors]; }];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(colorTitle)) ascending:YES];
    definedColors = [definedColors sortedArrayUsingDescriptors:@[sorter]];
    referenceColors = [referenceColors sortedArrayUsingDescriptors:@[sorter]];
    
    return [definedColors arrayByAddingObjectsFromArray:referenceColors];
}

- (RMRHexColor *)parseColor:(id)rawData {
    return [self parseColor:rawData definedColors:nil];
}

- (RMRHexColor *)parseColor:(id)rawData definedColors:(NSArray*)definedColors
{
    if (![rawData length]) return nil;

    // comments
    if ([rawData hasPrefix:@"//"]) return nil;
    
    // hex color definitions
    if ([rawData hasPrefix:@"#"] && definedColors == nil) {
        
        // you can test this on regextester.com
        // will capture 3 digit, 6 digit, or 8 (RRGGBBAA) hex strings
        NSString *captureValidHexString = @"#([a-fA-F0-9]{3}){1,2}([a-fA-F0-9]{2})?";
        
        NSRegularExpression *expr =
        [NSRegularExpression regularExpressionWithPattern:captureValidHexString
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];
        
        __block NSString *colorValue = nil;
        __block NSString *alternateValue = nil;
        
        __block NSRange lastRange = NSMakeRange(NSNotFound, 0);
        
        void(^enumerateBlock)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) =
        ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (flags & NSMatchingCompleted) {
                /* DONE. */
                // It fires this block one last time if you specify the option NSMatchingReportCompleted
                // which as you see below, can mess up our lastRange variable
                
            } else {
                if(colorValue == nil) {
                    colorValue = [rawData substringWithRange: [result range]];
                    lastRange = [result range];
                } else {
                    alternateValue = [rawData substringWithRange: [result range]];
                    lastRange = [result range];
                }
            }
            
        };
        
        [expr enumerateMatchesInString:rawData
                               options:0
                                 range:NSMakeRange(0, [rawData length])
                            usingBlock:enumerateBlock];
        
        if (!colorValue) {
            printf("Can't parse data %s\n", [rawData cStringUsingEncoding:NSUTF8StringEncoding]);
            return nil;
        }
        
        // here we should have the one or two colors, now we can get the color name
        NSUInteger offset = lastRange.location + lastRange.length;
        NSRange textContentRange = NSMakeRange(offset, [rawData length] - offset);
        
        // trim any leading / trailing whitespace
        NSString *nonHexColorContent = [[rawData substringWithRange:textContentRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        NSString *colorTitle = [[nonHexColorContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] firstObject];
        NSString *comments = [nonHexColorContent substringFromIndex:colorTitle.length];
        if([comments length] > 0) {
            comments = [comments substringFromIndex:1]; // the first character is most likely a space.
        }
        
        
        RMRHexColor *color = [[RMRHexColor alloc] init];
        color.colorTitle = colorTitle;
        color.colorValue = colorValue;
        color.alternateColorValue = alternateValue;
        color.comments = comments;
        
        return color;
    }
    
    if ([rawData hasPrefix:@"$"]  && definedColors != nil) {
        
        // strip the $$ from the string
        NSString *line = [rawData stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSArray *elements = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//[line componentsSeparatedByString:@" "];
        elements = [elements rx_filterWithBlock:^BOOL(NSString* each) {
            return (each.length > 0);
        }];
        
        
        if (elements.count < 2) {
            printf("There is something wrong with your formatting of color: %s.  It should be $$<ColorReferenceName> <NewName>", [line cStringUsingEncoding:NSUTF8StringEncoding]);
            return nil;
        }
        
        // first element should match a colorTitle in definedColors, then use its color value
        NSString *colorReferenceName = elements[0];
        NSString *newColorTitle = elements[1];
        
        NSString *comments = [[elements subarrayWithRange:(NSRange){2, elements.count - 2}] componentsJoinedByString:@" "];
        //printf([comments cStringUsingEncoding:NSUTF8StringEncoding]);
        
        
        __block RMRHexColor *newColor = nil;
        [definedColors enumerateObjectsUsingBlock:^(RMRHexColor * _Nonnull color, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([color.colorTitle isEqualToString:colorReferenceName]){
                newColor = [[RMRHexColor alloc] init];
                newColor.colorTitle = newColorTitle;
                newColor.colorValue = color.colorValue;
                newColor.alternateColorValue = color.alternateColorValue;
                newColor.isAlias = YES;
                newColor.comments = comments;
                *stop = YES;
            }
        }];
        
         return newColor;
    }
    
    return nil;
}

@end
