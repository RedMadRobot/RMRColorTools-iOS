//
//  RMRStyleSheetReader.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRStyleSheetReader.h"

// Helper
#import "RMRHexColorParser.h"


@implementation RMRStyleSheetReader

- (NSArray *)obtainColorsFromFileAtPath:(NSString *)path error:(NSError **)error
{
    NSString *styleSheet = [NSString stringWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:error];
    if (*error) return nil;

    RMRHexColorParser *parser = [[RMRHexColorParser alloc] init];

    return [parser parseColors:styleSheet];
}

@end
