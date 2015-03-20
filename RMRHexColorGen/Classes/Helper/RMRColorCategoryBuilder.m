//
//  RMRColorCategoryBuilder.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRColorCategoryBuilder.h"

#import <RXCollections/RXCollection.h>

// Helper
#import "NSString+RMRHelpers.h"
#import "NSColor+Hexadecimal.h"

// Model
#import "RMRHexColor.h"


#pragma mark — Constants

static NSString * const kTemplateKeyClassName     = @"<*class_name*>";
static NSString * const kTemplateKeyPathClassName = @"<*path_class_name*>";
static NSString * const kTemplateKeyCreateDate    = @"<*create_date*>";
static NSString * const kTemplateKeyMethods       = @"<*methods*>";

static NSString * const kColorCategoryHeaderTemplate =
    @"//\n//  <*path_class_name*>.h\n//\n//  Created on <*create_date*>.\n//\n"
    @"\n@import UIKit;\n\n"
    @"\n@interface <*class_name*>\n"
    @"\n<*methods*>"
    @"@end\n";

static NSString * const kColorCategorySourceTemplate =
    @"//\n//  <*path_class_name*>.m\n//\n//  Created on <*create_date*>.\n//\n"
    @"\n#import \"<*path_class_name*>.h\"\n\n"
    @"\n@implementation <*class_name*>\n"
    @"\n<*methods*>"
    @"@end\n";


@interface RMRColorCategoryBuilder ()

#pragma mark — Properties

@property (nonatomic, copy) NSDate   *initializationDate;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *categoryName;

@end


@implementation RMRColorCategoryBuilder

- (instancetype)initWithPrefix:(NSString *)prefix categoryName:(NSString *)categoryName
{
    self = [super init];
    if (!self) return nil;

    self.prefix = prefix;
    self.initializationDate = [NSDate date];
    self.categoryName = categoryName;

    return self;
}

- (NSError *)generateColorCategoryForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSError *error = nil;

    [self buildHeaderFileForColors:colorList outputPath:outputPath];
    if (error) return error;

    [self buildSourceFileForColors:colorList outputPath:outputPath];
    if (error) return error;

    return nil;
}

- (NSError *)buildHeaderFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *className     = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    NSString *createDate    = [self buildCreateDate];
    NSString *methods       = [self buildMethodGroupForHeaderFileWithColorList:colorList];

    NSString *headerFile =
        [[[[kColorCategoryHeaderTemplate
            stringByReplacingOccurrencesOfString:kTemplateKeyClassName     withString:className]
            stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
            stringByReplacingOccurrencesOfString:kTemplateKeyCreateDate    withString:createDate]
            stringByReplacingOccurrencesOfString:kTemplateKeyMethods       withString:methods];

    NSString *outputFilePath =
        [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".h"];

    NSError *error = nil;
    [headerFile writeToFile:outputFilePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error];

    return error;
}

- (NSError *)buildSourceFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *className     = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    NSString *createDate    = [self buildCreateDate];
    NSString *methods       = [self buildMethodGroupForSourceFileWithColorList:colorList];

    NSString *headerFile =
        [[[[kColorCategorySourceTemplate
            stringByReplacingOccurrencesOfString:kTemplateKeyClassName     withString:className]
            stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
            stringByReplacingOccurrencesOfString:kTemplateKeyCreateDate    withString:createDate]
            stringByReplacingOccurrencesOfString:kTemplateKeyMethods       withString:methods];

    NSString *outputFilePath =
        [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".m"];

    NSError *error = nil;
    [headerFile writeToFile:outputFilePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error];

    return error;
}


#pragma mark — Private helper

- (NSString *)buildClassName
{
    return [NSString stringWithFormat:@"UIColor (%@)", self.categoryName];
}

- (NSString *)buildPathClassName
{
    return [NSString stringWithFormat:@"UIColor+%@", self.categoryName];
}

- (NSString *)buildCreateDate
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }

    return [dateFormatter stringFromDate:self.initializationDate];
}

- (NSString *)buildMethodSignatureForColor:(RMRHexColor *)hexColor
{
    static NSString * prefixKey    = @"<*prefix*>";
    static NSString * colorNameKey = @"<*color_name*>";

    static NSString *colorMethodSignatureTemplate =
        @"+ (UIColor *)<*prefix*><*color_name*>Color";

    NSString *prefix = [self.prefix lowercaseString];
    prefix = prefix? [prefix stringByAppendingString:@"_"] : @"";

    NSString *colorName = [hexColor.colorTitle RMR_lowercaseFisrtSymbol];

    return
        [[colorMethodSignatureTemplate
            stringByReplacingOccurrencesOfString:prefixKey withString:prefix]
            stringByReplacingOccurrencesOfString:colorNameKey withString:colorName];
}

- (NSString *)buildMethodGroupForHeaderFileWithColorList:(NSArray *)colorList
{
    return
        [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
            return
                [[self buildMethodSignatureForColor:hexColor] stringByAppendingString:@";\n"];
        }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
            return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
        }];
}

- (NSString *)buildMethodGroupForSourceFileWithColorList:(NSArray *)colorList
{
    static NSString * signatureKey = @"<*method_signature*>";
    static NSString * redKey       = @"<*red*>";
    static NSString * greenKey     = @"<*green*>";
    static NSString * blueKey      = @"<*blue*>";
    static NSString * alphaKey     = @"<*alpha*>";

    static NSString *methodTemplate =
        @"<*method_signature*>\n{\n"
        @"    return [UIColor colorWithRed:<*red*>\n"
        @"                           green:<*green*>\n"
        @"                            blue:<*blue*>\n"
        @"                           alpha:<*alpha*>];\n"
        @"}\n";

    return
    [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
        NSString *methodSignature = [self buildMethodSignatureForColor:hexColor];

        NSColor *rgbColor = [NSColor colorWithHexString:hexColor.colorValue];

//        NSString *redComponent   = [NSString stringWithFormat:@"%ff", rgbColor.redComponent];
//        NSString *greenComponent = [NSString stringWithFormat:@"%ff", rgbColor.greenComponent];
//        NSString *blueComponent  = [NSString stringWithFormat:@"%ff", rgbColor.blueComponent];
//        NSString *alphaComponent = [NSString stringWithFormat:@"%ff", rgbColor.alphaComponent];

        NSString *redComponent   = [@(rgbColor.redComponent) stringValue];
        NSString *greenComponent = [@(rgbColor.greenComponent) stringValue];
        NSString *blueComponent  = [@(rgbColor.blueComponent) stringValue];
        NSString *alphaComponent = [@(rgbColor.alphaComponent) stringValue];

        return
            [[[[[methodTemplate
                stringByReplacingOccurrencesOfString:signatureKey withString:methodSignature]
                stringByReplacingOccurrencesOfString:redKey       withString:redComponent]
                stringByReplacingOccurrencesOfString:greenKey     withString:greenComponent]
                stringByReplacingOccurrencesOfString:blueKey      withString:blueComponent]
                stringByReplacingOccurrencesOfString:alphaKey     withString:alphaComponent];

    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
    }];
}

@end
