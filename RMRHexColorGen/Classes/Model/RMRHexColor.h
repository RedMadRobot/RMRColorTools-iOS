//
//  RMRHexColor.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface RMRHexColor : NSObject

@property (nonatomic, nullable, copy) NSString *colorTitle;
@property (nonatomic, nullable, copy) NSString *colorValue;
@property (nonatomic, nullable, copy) NSString *alternateColorValue;  // optional.  For example a dark-mode representation.
@property (nonatomic, assign) BOOL isAlias;
@property (nonatomic, nullable, copy) NSString *comments;

@end
