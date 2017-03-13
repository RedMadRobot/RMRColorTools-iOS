//
// RMRCheckedFileWriter
// RMRColorTools
//
// Created by Eugene Egorov on 16 March 2016.
// Copyright (c) 2016 RedMadRobot. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/*
 File writer that update files if their content has changed.
 */
@interface RMRCheckedFileWriter : NSObject

- (BOOL)writeString:(NSString *)string toFile:(NSString *)filePath error:(NSError *__nullable *__nullable)error;

- (BOOL)writeData:(NSData *)data toFile:(NSString *)filePath error:(NSError *__nullable *__nullable)error;

@end


NS_ASSUME_NONNULL_END
