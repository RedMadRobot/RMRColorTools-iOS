//
//  NSColorPanel+RMRColorList.h
//  RMRRefreshColorPanelPlugin
//
//  Created by Roman Churkin on 20/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Cocoa;


@interface NSColorPanel (RMRColorList)

- (void)detachCustomColorLists;

- (void)attachCustomColorLists;

@end
