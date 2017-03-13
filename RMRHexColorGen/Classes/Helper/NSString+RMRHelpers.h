//
//  NSString+RMRHelpers.h
//  RMRSwaggerCodeGen
//
//  Created by Roman Churkin on 20/02/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface NSString (RMRHelpers)

- (NSString *)RMR_uppercaseFirstSymbol;
- (NSString *)RMR_lowercaseFirstSymbol;
- (NSString *)RMR_removeLastCharacter;

@end
