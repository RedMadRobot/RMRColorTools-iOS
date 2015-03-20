//
//  RMRRefreshColorPanel.h
//  RMRRefreshColorPanelPlugin
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import AppKit;


@interface RMRRefreshColorPanel : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end