//
// RMRCheckedFileWriter
// RMRColorTools
//
// Created by Eugene Egorov on 16 March 2016.
// Copyright (c) 2016 RedMadRobot. All rights reserved.
//

#import "RMRCheckedFileWriter.h"


@implementation RMRCheckedFileWriter

- (BOOL)writeString:(NSString *)string toFile:(NSString *)filePath error:(NSError *__nullable *__nullable)error
{
    NSString *currentString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if ([currentString isEqualToString:string]) {
        if (error) {
            *error = nil;
        }
        return YES;
    }

    BOOL result = [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error];
    return result;
}

- (BOOL)writeData:(NSData *)data toFile:(NSString *)filePath error:(NSError *__nullable *__nullable)error
{
    NSData *currentData = [NSData dataWithContentsOfFile:filePath];
    if ([currentData isEqualToData:data]) {
        if (error) {
            *error = nil;
        }
        return YES;
    }

    BOOL result = [data writeToFile:filePath options:NSDataWritingAtomic error:error];
    return result;
}

@end
