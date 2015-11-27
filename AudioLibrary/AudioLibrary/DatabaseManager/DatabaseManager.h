//
//  DatabaseManager.h
//  AudioLibrary
//
//  Created by Admin on 27/11/15.
//  Copyright (c) 2015 itsculptors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong) FMDatabase *database;

+(DatabaseManager *)sharedDatabaseManager;
-(void)createDatabase;
-(void)openDatabase;

@end
