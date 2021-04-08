//
//  RMRAssetCategoryBuilder.m
//  RMRHexColorGen
//
//  Created by Stephen O'Connor (MHP) on 12.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

#import "RMRAssetsCatalogBuilder.h"
#import "RMRHexColorGenParameters.h"
#import "RMRHexColor.h"
#import "RXCollection.h"
#import "NSColor+Hexadecimal.h"
#import "RMRStringTools.h"
#import "Constants.h"



static NSString * const kRMRAssetsCatalogFileExtension = @".xcassets";
static NSString * const kRMRAssetsColorSetFileExtension = @".colorset";
static NSString * const kRMRAssetsContentsFilename = @"Contents.json";



static NSString * const kAssetsContentsJson =
@"{\n"
@"  \"info\" : {\n"
@"    \"version\" : 1,\n"
@"    \"author\" : \"xcode\"\n"
@"  }\n"
@"}";

static NSString * const kColorContentsJsonTemplate =
@"{\n"
@"    \"info\" : {\n"
@"        \"version\" : 1,\n"
@"        \"author\" : \"xcode\"\n"
@"    },\n"
@"    \"colors\" : [\n"
@"                {\n"
@"                    \"idiom\" : \"universal\",\n"
@"                    \"color\" : {\n"
@"                        \"color-space\" : \"srgb\",\n"
@"                        \"components\" : {\n"
@"                            \"red\" : \"0x<*red*>\",\n"
@"                            \"alpha\" : \"<*alpha*>\",\n"
@"                            \"blue\" : \"0x<*blue*>\",\n"
@"                            \"green\" : \"0x<*green*>\"\n"
@"                        }\n"
@"                    }\n"
@"                }\n"
@"             ]\n"
@"}";

static NSString * const kColorContentsJsonTemplateWithDarkMode =
@"{\n"
@"    \"info\" : {\n"
@"        \"version\" : 1,\n"
@"        \"author\" : \"xcode\"\n"
@"    },\n"
@"    \"colors\" : [\n"
@"                {\n"
@"                    \"idiom\" : \"universal\",\n"
@"                    \"color\" : {\n"
@"                        \"color-space\" : \"srgb\",\n"
@"                        \"components\" : {\n"
@"                            \"red\" : \"0x<*red*>\",\n"
@"                            \"alpha\" : \"<*alpha*>\",\n"
@"                            \"blue\" : \"0x<*blue*>\",\n"
@"                            \"green\" : \"0x<*green*>\"\n"
@"                        }\n"
@"                    }\n"
@"                },\n"
@"                {\n"
@"                    \"appearances\" : [\n"
@"                       {\n"
@"                          \"appearance\" : \"luminosity\",\n"
@"                          \"value\" : \"dark\"\n
@"                       }\n"
@"                     ],\n"
@"                    \"idiom\" : \"universal\",\n"
@"                    \"color\" : {\n"
@"                        \"color-space\" : \"srgb\",\n"
@"                        \"components\" : {\n"
@"                            \"red\" : \"0x<*red_dark*>\",\n"
@"                            \"alpha\" : \"<*alpha_dark*>\",\n"
@"                            \"blue\" : \"0x<*blue_dark*>\",\n"
@"                            \"green\" : \"0x<*green_dark*>\"\n"
@"                        }\n"
@"                    }\n"
@"                }\n"
@"             ]\n"
@"}";


@interface RMRAssetsCatalogBuilder()
@property (nonatomic, retain) RMRHexColorGenParameters *parameters;
@end

@implementation RMRAssetsCatalogBuilder

- (instancetype)initWithParameters:(RMRHexColorGenParameters*)parameters
{
    self = [super init];
    if (self) {
        _parameters = parameters;
    }
    return self;
}

- (NSError*)generateAssetsCatalogWithColors:(NSArray*)colorList
{
    RMRHexColorGenParameters *parameters = self.parameters;
    
    if (parameters.outputFormat != RMRHexColorGenFormatAssetCatalog) {
        return [NSError errorWithDomain:kRMRErrorDomain
                                   code:500
                               userInfo:@{NSLocalizedDescriptionKey: @"You tried building an assets catalog by specifying the wrong parameter for format.  You should include \"-format assets\" to generate an assets catalog"}];
    }
    
    NSString *catalogName = parameters.name;  // this will be non-nil, look to where params are parsed.
    
    NSString *outputCatalogPath =
    [[[parameters.outputPath stringByExpandingTildeInPath] stringByAppendingPathComponent:catalogName] stringByAppendingString:kRMRAssetsCatalogFileExtension];
    
    // check for existence, remove if so, then create folder
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    NSError *error = nil;
    
    if([fm fileExistsAtPath:outputCatalogPath isDirectory:&isDir]) {
        if(!isDir) {
            return [NSError errorWithDomain:@"RMRErrorDomain" code:500 userInfo:@{NSLocalizedDescriptionKey: @"We expected a folder at the assets catalog output path, but it wasn't!"}];
        }
        [fm removeItemAtPath:outputCatalogPath error:&error];
        
    }
    
    [fm createDirectoryAtPath:outputCatalogPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        return error;
    }
    
    
    NSString *contentsJsonPath = [outputCatalogPath stringByAppendingPathComponent:kRMRAssetsContentsFilename];
    
    if([fm fileExistsAtPath:contentsJsonPath isDirectory:nil]) {
        [fm removeItemAtPath:contentsJsonPath error:&error];
    }
    
    if (error) {
        return error;
    }
    
    //[fm createFileAtPath:contentsJsonPath contents:contents attributes:nil];
    [kAssetsContentsJson writeToFile:contentsJsonPath
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error];
    
    if (error) {
        return error;
    }
    
    
    static NSString * redKey       = @"<*red*>";  // expects 2 characters
    static NSString * greenKey     = @"<*green*>";
    static NSString * blueKey      = @"<*blue*>";
    static NSString * alphaKey     = @"<*alpha*>"; // expects a decimal as string
    
    static NSString * redKey       = @"<*red_dark*>";  // expects 2 characters
    static NSString * greenKey     = @"<*green_dark*>";
    static NSString * blueKey      = @"<*blue_dark*>";
    static NSString * alphaKey     = @"<*alpha_dark*>"; // expects a decimal as string
    
    for(RMRHexColor *hexColor in colorList) {
        
        NSString *folderName = [hexColor.colorTitle stringByAppendingString:kRMRAssetsColorSetFileExtension];
        
        BOOL needsDarkMode = (hexColor.alternateColorValue != nil);
        
        NSString *colorString = [[hexColor.colorValue stringByReplacingOccurrencesOfString:@"#"
                                                                                withString:@""] uppercaseString];
        colorString = [colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString *redComponent   = [colorString substringWithRange:NSMakeRange(0, 2)];
        NSString *greenComponent = [colorString substringWithRange:NSMakeRange(2, 2)];
        NSString *blueComponent  = [colorString substringWithRange:NSMakeRange(4, 2)];
        NSString *alphaComponent = @"1.0";
        
        if(colorString.length == 8) {
            alphaComponent = [colorString substringWithRange:NSMakeRange(6, 2)];
            alphaComponent = [NSString stringWithFormat:@"%f", [alphaComponent hexAsNormalizedFloatValue]];
        }
        
        
        
        NSString *fileContents = [[[[kColorContentsJsonTemplate
            stringByReplacingOccurrencesOfString:redKey       withString:redComponent]
           stringByReplacingOccurrencesOfString:greenKey     withString:greenComponent]
          stringByReplacingOccurrencesOfString:blueKey      withString:blueComponent]
         stringByReplacingOccurrencesOfString:alphaKey     withString:alphaComponent];
        
        NSError *colorGenError = nil;
        
        // now create the folder
        NSString *folderPath = [outputCatalogPath stringByAppendingPathComponent:folderName];
        BOOL isFolder;
        if([fm fileExistsAtPath:folderPath isDirectory:&isFolder]) {
            if(!isFolder) {
                return [NSError errorWithDomain:@"RMRErrorDomain" code:500 userInfo:@{NSLocalizedDescriptionKey: @"We expected a folder at the colorset output path, but it wasn't!"}];
            }
            [fm removeItemAtPath:folderPath error:&colorGenError];
            
        } else {
            [fm createDirectoryAtPath:folderPath withIntermediateDirectories:true attributes:nil error:&colorGenError];
        }
        
        if(colorGenError) {
            return colorGenError;
        }

        // then write the file (contents.json)
        
        NSString *colorContentsPath = [folderPath stringByAppendingPathComponent:kRMRAssetsContentsFilename];
        [fileContents writeToFile:colorContentsPath
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:&colorGenError];
        
        if(colorGenError) return colorGenError;
    }
    
    return nil;
}

@end
