//
//  NSString+RMRHelpers.m
//  RMRSwaggerCodeGen
//
//  Created by Roman Churkin on 20/02/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "NSString+RMRHelpers.h"


@implementation NSString (RMRHelpers)

- (NSString *)RMR_uppercaseFisrtSymbol
{
    return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)RMR_lowercaseFisrtSymbol
{
    return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)RMR_removeLastCharacter
{
    NSUInteger length = [self length];
    NSUInteger lastCharIndex = length - (length > 0);
    NSRange rangeOfLastChar = [self rangeOfComposedCharacterSequenceAtIndex:lastCharIndex];
    return [self substringToIndex:rangeOfLastChar.location];
}

@end
