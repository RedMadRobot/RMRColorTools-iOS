//
//  RMRHexColorGenTests.m
//  RMRHexColorGenTests
//
//  Created by Stephen O'Connor (MHP) on 07.04.21.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMRHexColorParser.h"
#import "RMRHexColor.h"

@interface RMRHexColorParser(Publicize)
- (RMRHexColor *)parseColor:(id)rawData definedColors:(NSArray*)definedColors;
@end

@interface RMRHexColorGenTests : XCTestCase

@property (nonatomic, retain) RMRHexColorParser *parser;

@end

@implementation RMRHexColorGenTests

- (void)setUp {
    self.parser = [[RMRHexColorParser alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.parser = nil;
}



- (void)testCommentLine {
    NSString *sut = @"// This is to indicate to the dev what he should know.";
    
    RMRHexColor *expectedResult = nil;  // lines that begin with // should be ignored by the parser.
    
    RMRHexColor *result = [self.parser parseColor:sut];
    XCTAssertNil(expectedResult, @"These two are not the same.");
    XCTAssertNil(result, @"These two are not the same.");
    
}

- (void)testBasicLine {
    NSString *sut = @"#A0B1C2 BlueGrey This is some comment now.";
    RMRHexColor *expectedResult = [[RMRHexColor alloc] init];
    expectedResult.colorTitle = @"BlueGrey";
    expectedResult.colorValue = @"#A0B1C2";
    expectedResult.alternateColorValue = nil;
    expectedResult.comments = @"This is some comment now.";
    expectedResult.isAlias = NO;
    
    RMRHexColor *result = [self.parser parseColor:sut];
    XCTAssert([expectedResult isEqual:result], @"These two are not the same.");
}

- (void)testBasicAliasLine {
    NSString *sut = @"$BlueGrey StandardBackgroundColor This is some other comment now.";
    
    RMRHexColor *existingColor = [[RMRHexColor alloc] init];
    existingColor.colorTitle = @"BlueGrey";
    existingColor.colorValue = @"#A0B1C2";
    existingColor.alternateColorValue = nil;
    existingColor.comments = @"This is some comment now.";
    existingColor.isAlias = NO;
    
    RMRHexColor *expectedResult = [[RMRHexColor alloc] init];
    expectedResult.colorTitle = @"StandardBackgroundColor";
    expectedResult.colorValue = @"#A0B1C2";
    expectedResult.alternateColorValue = nil;
    expectedResult.comments = @"This is some comment other now.";
    expectedResult.isAlias = YES;
    RMRHexColor *result = [self.parser parseColor:sut definedColors:@[existingColor]];
    XCTAssert([expectedResult isEqual:result], @"These two are not the same.");
    
}

- (void)testDarkModeLine {
    NSString *sut = @"#A0B1C2 #D1E2F3 BlueGrey This is some comment now with dark mode.";
    RMRHexColor *expectedResult = [[RMRHexColor alloc] init];
    expectedResult.colorTitle = @"BlueGrey";
    expectedResult.colorValue = @"#A0B1C2";
    expectedResult.alternateColorValue = @"#D1E2F3";
    expectedResult.comments = @"This is some comment now with dark mode.";
    expectedResult.isAlias = NO;
    
    RMRHexColor *result = [self.parser parseColor:sut];
    XCTAssert([expectedResult isEqual:result], @"These two are not the same.");
}

- (void)testAliasToDarkModeColor {
    RMRHexColor *existingColor = [[RMRHexColor alloc] init];
    existingColor.colorTitle = @"BlueGrey";
    existingColor.colorValue = @"#A0B1C2";
    existingColor.alternateColorValue = @"#D1E2F3";
    existingColor.comments = @"This is some comment now with dark mode.";
    existingColor.isAlias = NO;
    
    NSString *sut = @"$BlueGrey StandardBackgroundColor This is some comment now for alias with dark mode.";
    
    RMRHexColor *expectedResult = [[RMRHexColor alloc] init];
    expectedResult.colorTitle = @"StandardBackgroundColor";
    expectedResult.colorValue = @"#A0B1C2";
    expectedResult.alternateColorValue = @"#D1E2F3";
    expectedResult.comments = @"This is some comment now for alias with dark mode.";
    expectedResult.isAlias = YES;
    
    RMRHexColor *result = [self.parser parseColor:sut definedColors: @[existingColor]];
    XCTAssert([expectedResult isEqual:result], @"These two are not the same.");
}

@end
