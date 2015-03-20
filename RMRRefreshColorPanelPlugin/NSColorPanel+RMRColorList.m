//
//  NSColorPanel+RMRColorList.m
//  RMRRefreshColorPanelPlugin
//
//  Created by Roman Churkin on 20/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "NSColorPanel+RMRColorList.h"


#pragma mark — Constants

static NSString * const kColorListFileExtension = @"clr";
static NSString * const kColorListPath = @"~/Library/Colors/";


@implementation NSColorPanel (RMRColorList)

- (void)detachCustomColorLists
{
    for (NSColorList *colorList in [[NSColorList availableColorLists] copy]) {
        if (colorList.isEditable) [self detachColorList:colorList];
    }
}

- (void)attachCustomColorLists
{
    NSString *colorsPath = [kColorListPath stringByExpandingTildeInPath];

    NSArray *dirFiles =
        [[NSFileManager defaultManager] contentsOfDirectoryAtPath:colorsPath
                                                            error:nil];

    for (NSString *fileName in dirFiles) {
        NSString  *fileExtension = fileName.pathExtension;
        if ([fileExtension isEqualToString:kColorListFileExtension]) {
            NSString *colorListName = fileName.stringByDeletingPathExtension;
            NSString *colorListPath =
                [[colorsPath stringByAppendingPathComponent:colorListName]
                    stringByAppendingPathExtension:kColorListFileExtension];

            NSColorList *colorList = [[NSColorList alloc] initWithName:colorListName
                                                              fromFile:colorListPath];
            [self attachColorList:colorList];
        }
    }
}

@end
