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
        
        NSRegularExpression *expr =
        [NSRegularExpression regularExpressionWithPattern:@"\\s*([a-f0-9]{3,8})\\s*(.*)\\s*"
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];
        
        __block NSString *colorValue = nil;
        __block NSString *colorTitleAndComments = nil;
        
        
        void(^enumerateBlock)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) =
        ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result.numberOfRanges == 3) {
                colorValue   = [rawData substringWithRange:[result rangeAtIndex:1]];
                
                NSRange titleRange = [result rangeAtIndex:2];
                colorTitleAndComments = [rawData substringWithRange:titleRange];
            }
        };
        
        [expr enumerateMatchesInString:rawData
                               options:0
                                 range:NSMakeRange(0, [rawData length])
                            usingBlock:enumerateBlock];
        
        if (!colorTitleAndComments || !colorValue) {
            printf("Can't parse data %s\n", [rawData cStringUsingEncoding:NSUTF8StringEncoding]);
            return nil;
        }
        
        NSString *colorTitle = [[colorTitleAndComments componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] firstObject];
        NSString *comments = [colorTitleAndComments substringFromIndex:colorTitle.length];
        
        
        RMRHexColor *color = [[RMRHexColor alloc] init];
        color.colorTitle = colorTitle;
        color.colorValue = colorValue;
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
