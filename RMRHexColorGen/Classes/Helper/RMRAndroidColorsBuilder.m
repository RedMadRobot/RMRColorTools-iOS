//
//  RMRAndroidColorsBuilder.m
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 19.04.21.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

#import "RMRAndroidColorsBuilder.h"
#import "RXCollection.h"

// Helper
#import "NSString+RMRHelpers.h"
#import "NSColor+Hexadecimal.h"

// Model
#import "RMRHexColor.h"
#import "Constants.h"

static NSString * const kTemplateKeyInputFileName                 = @"<*input_file_name*>";
static NSString * const kTemplateKeyFileName                      = @"<*file_name*>";
static NSString * const kTemplateKeyBuildDate                     = @"<*build_date*>";
static NSString * const kTemplateKeyColorList                     = @"<*colorlist*>";
static NSString * const kTemplateKeyColorName                     = @"<*color_name*>";
static NSString * const kTemplateKeyColorHexValue                 = @"<*color_value*>";
static NSString * const kTemplateKeyColorComments                 = @"<*color_comments*>";

static NSString * const kColorsXMLAndroidTemplate =
@"<!--\n"
@"    <*file_name*>\n"
@"    Generation Date: <*build_date*>\n"
@"    (This file was autogenerated by RMRHexColorGen, which parsed an\n"
@"    input file: <*input_file_name*>.\n"
@"    Do not modify as it can easily be overwritten.)\n"
@"-->\n"
@""
@"<resources>"
@"<*colorlist*>"
@"</resources>";

static NSString * const kColorItemTemplate =
@"    <color name=\"<*color_name*>\"><*color_value*></color>";

static NSString * const kColorItemWithCommentsTemplate =
@"    <!-- <*color_comments*> -->\n"
@"    <color name=\"<*color_name*>\"><*color_value*></color>";


@interface RMRAndroidColorsBuilder ()

#pragma mark — Properties
@property (nonatomic, retain) RMRHexColorGenParameters *parameters;
@property (nonatomic, copy) NSDate   *initializationDate;
@end


@implementation RMRAndroidColorsBuilder

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters
{
    self = [super init];
    if (self) {
        _parameters = parameters;
        _initializationDate = [NSDate date];
    }
    return self;
}

- (NSError *)generateAndroidXMLForColors:(NSArray *)colorList
{
    RMRHexColorGenParameters *parameters = self.parameters;
    
    if (parameters.outputFormat == RMRHexColorGenFormatInvalid ||
        parameters.outputFormat != RMRHexColorGenFormatAndroid ) {
        return [NSError errorWithDomain:kRMRErrorDomain
                                   code:500
                               userInfo:@{NSLocalizedDescriptionKey: @"You tried building android assets by specifying the wrong parameter for format."}];
    }
    
    NSString *outputFilePath;

    NSString *filename = [self buildOutputFileName];
    outputFilePath = [[parameters.outputPath stringByExpandingTildeInPath] stringByAppendingPathComponent: filename];
    
    
    // check for existence, remove if so, then create folder
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    NSError *error = nil;
    
    if([fm fileExistsAtPath:outputFilePath isDirectory:&isDir]) {
        [fm removeItemAtPath:outputFilePath error:&error];
    }
    
    if (error) {
        return error;
    }
    
    error = [self buildAndroidColorsFileWith: colorList
                                  outputPath: outputFilePath];
    
    return error;
}

- (NSError *)buildAndroidColorsFileWith:(NSArray *)colorList outputPath:(NSString *)outputFileDestination
{
    NSString *inputFilename = self.parameters.inputPath.lastPathComponent;
    NSString *filename     = [self buildOutputFileName];
    NSString *buildCreateDate = [self buildCreateDate];
    
    NSString *colorListXML;
    colorListXML = [self buildColorListXMLForOutputFileWithColorList:colorList];
    
    NSString *headerFile =
    [[[[kColorsXMLAndroidTemplate
        stringByReplacingOccurrencesOfString:kTemplateKeyInputFileName withString:inputFilename]
       stringByReplacingOccurrencesOfString:kTemplateKeyFileName     withString:filename]
      stringByReplacingOccurrencesOfString:kTemplateKeyBuildDate withString:buildCreateDate]
     stringByReplacingOccurrencesOfString:kTemplateKeyColorList       withString:colorListXML];
    
    NSError *error = nil;
    [headerFile writeToFile:outputFileDestination
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error];
    
    return error;
}

- (NSString *)buildColorListXMLForOutputFileWithColorList:(NSArray *)colorList {
    
    
    // the colorList will be sorted first with defined colors, then aliases.
    // so the first alias we encounter, we should generate some more text
    __block BOOL firstColor = YES;
    __block BOOL definedColorsFinished = NO;
    __block BOOL firstReference = NO;
    
    return
    [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
        
        NSString *sectionComments = nil;
        
        if(firstColor) {
            sectionComments = @"\n\n    <!--  Defined colors with provided Hex Values -->\n\n";
            firstColor = NO;
        }
        
        // this works because the assumption is that colorList has been sorted first by non-aliases then aliases.
        if(hexColor.isAlias && !definedColorsFinished) {
            definedColorsFinished = YES;
            firstReference = YES;
        }

        if (firstReference) {
            sectionComments = @"\n\n    <!--  Color Aliases below are references to defined colors above -->\n\n";
            firstReference = NO;
        }
        
        
        NSString *template = hexColor.comments.length > 0 ? kColorItemWithCommentsTemplate : kColorItemTemplate;
        
        NSString *outputLine =
        [[[template
               stringByReplacingOccurrencesOfString:kTemplateKeyColorName withString:hexColor.colorTitle]
              stringByReplacingOccurrencesOfString:kTemplateKeyColorHexValue withString:hexColor.colorValue]
             stringByReplacingOccurrencesOfString:kTemplateKeyColorComments withString:hexColor.comments];
        
        
        
        if(hexColor.alternateColorValue != nil) {
            
            NSString *colorTitle = [NSString stringWithFormat:@"%@_dark", hexColor.colorTitle];
            
            NSString *alternateColorOutputLine =
            [[[template
                   stringByReplacingOccurrencesOfString:kTemplateKeyColorName withString:colorTitle]
                  stringByReplacingOccurrencesOfString:kTemplateKeyColorHexValue withString:hexColor.colorValue]
                 stringByReplacingOccurrencesOfString:kTemplateKeyColorComments withString:@"Dark Version of above color"];

            outputLine = [outputLine stringByAppendingFormat:@"\n%@", alternateColorOutputLine];
            outputLine = [outputLine stringByAppendingString:@"\n"];
            
        }
        
        if (sectionComments) {
            return [sectionComments stringByAppendingString:outputLine];
        } else {
            return outputLine;
        }
        
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
    }];
}


#pragma mark — Private helper

- (NSString *)buildOutputFileName
{
    return [NSString stringWithFormat:@"%@.xml", self.parameters.name];
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

@end
