//
//  DatabaseManager.m
//  AudioLibrary
//
//  Created by Admin on 27/11/15.
//  Copyright (c) 2015 itsculptors. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

+(DatabaseManager *)sharedDatabaseManager {
    static dispatch_once_t taken;
    static DatabaseManager *shared = nil;
    dispatch_once(&taken, ^{
        shared = [DatabaseManager new];
    });
    return shared;
}
-(void)createDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //Trying to read sqlite file from the document directory path
    NSString *writablePath = [documentDirectory stringByAppendingPathComponent:@"audioDB.sqlite"];
    success = [fileManager fileExistsAtPath:writablePath];
    
    NSError *error;
    // if sqlite path is not found, try to create sqlite file by copying from nsbundle
    if(success) {
        self.database = [FMDatabase databaseWithPath:writablePath];
    }else {
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"audioDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultPath toPath:writablePath error:&error];
        self.database = [FMDatabase databaseWithPath:writablePath];
    }
}
-(void)openDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //Trying to read sqlite file from the document directory path
    NSString *writablePath = [documentDirectory stringByAppendingPathComponent:@"audioDB.sqlite"];
    success = [fileManager fileExistsAtPath:writablePath];
    if(success) {
        self.database =  [FMDatabase databaseWithPath:writablePath];
    }
}
@end
