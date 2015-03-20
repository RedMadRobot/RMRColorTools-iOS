//
//  NSColorList+RMRHexColor.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Cocoa;


@interface NSColorList (RMRHexColor)

- (void)fillWithHexColors:(NSArray *)hexColorList
                   prefix:(NSString *)prefix;

@end
