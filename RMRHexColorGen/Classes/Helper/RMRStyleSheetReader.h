//
//  RMRStyleSheetReader.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface RMRStyleSheetReader : NSObject

- (NSArray *)obtainColorsFromFileAtPath:(NSString *)path error:(NSError **)error;

@end
