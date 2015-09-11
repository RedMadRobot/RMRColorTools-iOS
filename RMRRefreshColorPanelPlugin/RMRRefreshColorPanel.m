//
//  RMRRefreshColorPanel.m
//  RMRRefreshColorPanelPlugin
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRRefreshColorPanel.h"

// Helper
#import "NSColorPanel+RMRColorList.h"


#pragma mark — Constants

static NSString * const kBuildOperationDidStop = @"IDEBuildOperationDidStopNotification";

static RMRRefreshColorPanel *sharedPlugin;


@interface RMRRefreshColorPanel()

#pragma mark — Properties

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@end


@implementation RMRRefreshColorPanel

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqualToString:@"Xcode"]) {
        dispatch_once(&onceToken, ^{ sharedPlugin = [[self alloc] initWithBundle:plugin]; });
    }
}

+ (instancetype)sharedPlugin { return sharedPlugin; }

- (instancetype)initWithBundle:(NSBundle *)plugin
{
    self = [super init];
    if (!self) return nil;

    self.bundle = plugin;

    [self beginNotificationObservation];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self createPluginMenuItem];
    }];

    return self;
}

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }

- (void)beginNotificationObservation
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ideBuildOperationDidStopNotification:)
                                                 name:kBuildOperationDidStop
                                               object:nil];
}

- (void)createPluginMenuItem
{
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];

    if (menuItem) {
        NSMenuItem *actionMenuItem =
            [[NSMenuItem alloc] initWithTitle:@"Reload color lists"
                                       action:@selector(reloadCustomColorLists)
                                keyEquivalent:@""];
        [actionMenuItem setTarget:self];

        [menuItem.submenu addItem:[NSMenuItem separatorItem]];
        [menuItem.submenu addItem:actionMenuItem];
    }
}

- (void)ideBuildOperationDidStopNotification:(NSNotification *)notification
{
    [self reloadCustomColorLists];
}

- (void)reloadCustomColorLists
{
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];

    [colorPanel detachCustomColorLists];
    [colorPanel attachCustomColorLists];
}

@end
