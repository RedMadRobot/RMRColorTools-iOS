//
//  RMRColorCategoryBuilder.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRColorCategoryBuilder.h"

#import "RXCollection.h"

// Helper
#import "NSString+RMRHelpers.h"
#import "NSColor+Hexadecimal.h"

// Model
#import "RMRHexColor.h"
#import "RMRCheckedFileWriter.h"


#pragma mark — Constants

NSString *const kTemplateKeyClassName = @"<*class_name*>";
NSString *const kTemplateKeyPathClassName = @"<*path_class_name*>";
NSString *const kTemplateKeyMethods = @"<*methods*>";

NSString *const kColorCategoryHeaderTemplate = @""
    @"//\n"
    @"// <*path_class_name*>.h\n"
    @"//\n"
    @"// Automatically generated file. Please do not edit.\n"
    @"//\n"
    @"\n"
    @"@import UIKit;\n"
    @"\n"
    @"\n"
    @"@interface <*class_name*>\n"
    @"\n"
    @"<*methods*>"
    @"@end\n";

NSString *const kColorCategorySourceTemplate = @""
    @"//\n"
    @"// <*path_class_name*>.m\n"
    @"//\n"
    @"// Automatically generated file. Please do not edit.\n"
    @"//\n"
    @"\n"
    @"#import \"<*path_class_name*>.h\"\n"
    @"\n"
    @"\n"
    @"@implementation <*class_name*>\n"
    @"\n"
    @"<*methods*>"
    @"@end\n";


@interface RMRColorCategoryBuilder ()

#pragma mark — Properties

@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *categoryName;

@end


@implementation RMRColorCategoryBuilder

- (instancetype)initWithPrefix:(NSString *)prefix categoryName:(NSString *)categoryName
{
    self = [super init];
    if (self) {
        self.prefix = prefix;
        self.categoryName = categoryName;
    }
    return self;
}

- (NSError *)generateColorCategoryForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSError *error = nil;

    error = [self buildHeaderFileForColors:colorList outputPath:outputPath];
    if (error) {
        return error;
    }

    error = [self buildSourceFileForColors:colorList outputPath:outputPath];
    if (error) {
        return error;
    }

    return nil;
}

- (NSError *)buildHeaderFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *className = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    NSString *methods = [self buildMethodGroupForHeaderFileWithColorList:colorList];

    NSString *content =
        [[[kColorCategoryHeaderTemplate
            stringByReplacingOccurrencesOfString:kTemplateKeyClassName withString:className]
            stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
            stringByReplacingOccurrencesOfString:kTemplateKeyMethods withString:methods];

    NSString *outputFilePath =
        [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".h"];

    NSError *error = nil;
    RMRCheckedFileWriter *writer = [RMRCheckedFileWriter new];
    [writer writeString:content toFile:outputFilePath error:&error];

    return error;
}

- (NSError *)buildSourceFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *className = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    NSString *methods = [self buildMethodGroupForSourceFileWithColorList:colorList];

    NSString *content =
        [[[kColorCategorySourceTemplate
            stringByReplacingOccurrencesOfString:kTemplateKeyClassName withString:className]
            stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
            stringByReplacingOccurrencesOfString:kTemplateKeyMethods withString:methods];

    NSString *outputFilePath =
        [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".m"];

    NSError *error = nil;
    RMRCheckedFileWriter *writer = [RMRCheckedFileWriter new];
    [writer writeString:content toFile:outputFilePath error:&error];

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

- (NSString *)buildMethodSignatureForColor:(RMRHexColor *)hexColor
{
    NSString *const prefixKey = @"<*prefix*>";
    NSString *const colorNameKey = @"<*color_name*>";

    NSString *const colorMethodSignatureTemplate =
        @"+ (UIColor *)<*prefix*><*color_name*>Color";

    NSString *prefix = self.prefix.lowercaseString;
    prefix = prefix ? [prefix stringByAppendingString:@"_"] : @"";

    NSString *colorName = [hexColor.colorTitle RMR_lowercaseFirstSymbol];

    return
        [[colorMethodSignatureTemplate
            stringByReplacingOccurrencesOfString:prefixKey withString:prefix]
            stringByReplacingOccurrencesOfString:colorNameKey withString:colorName];
}

- (NSString *)buildMethodBodyForColor:(RMRHexColor *)hexColor
{
    NSString *const signatureKey = @"<*method_signature*>";
    NSString *const redKey = @"<*red*>";
    NSString *const greenKey = @"<*green*>";
    NSString *const blueKey = @"<*blue*>";
    NSString *const alphaKey = @"<*alpha*>";

    NSString *const methodTemplate = @""
        @"<*method_signature*>\n"
        @"{\n"
        @"    return [UIColor colorWithRed:<*red*> green:<*green*> blue:<*blue*> alpha:<*alpha*>];\n"
        @"}\n";

    NSString *methodSignature = [self buildMethodSignatureForColor:hexColor];

    NSColor *rgbColor = [NSColor colorWithHexString:hexColor.colorValue];

    NSString *redComponent = @(rgbColor.redComponent).stringValue;
    NSString *greenComponent = @(rgbColor.greenComponent).stringValue;
    NSString *blueComponent = @(rgbColor.blueComponent).stringValue;
    NSString *alphaComponent = @(rgbColor.alphaComponent).stringValue;

    return
        [[[[[methodTemplate
            stringByReplacingOccurrencesOfString:signatureKey withString:methodSignature]
            stringByReplacingOccurrencesOfString:redKey withString:redComponent]
            stringByReplacingOccurrencesOfString:greenKey withString:greenComponent]
            stringByReplacingOccurrencesOfString:blueKey withString:blueComponent]
            stringByReplacingOccurrencesOfString:alphaKey withString:alphaComponent];
}

- (NSString *)buildMethodGroupForHeaderFileWithColorList:(NSArray *)colorList
{
    return
        [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
            return [[self buildMethodSignatureForColor:hexColor] stringByAppendingString:@";\n"];
        }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
            return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
        }];
}

- (NSString *)buildMethodGroupForSourceFileWithColorList:(NSArray *)colorList
{
    return
        [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
            return [self buildMethodBodyForColor:hexColor];
        }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
            return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
        }];
}

@end
