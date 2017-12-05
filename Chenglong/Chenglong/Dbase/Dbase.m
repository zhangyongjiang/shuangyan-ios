//
//  Dbase.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Dbase.h"

Dbase* gdb;

@interface Dbase()


@end


@implementation Dbase

+(Dbase*)shared {
    if(gdb)
        return gdb;
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"bbzj.sqlite"];
    
    FMDatabaseQueue*database = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [database inDatabase:^(FMDatabase *db) {
        NSString* key = @"DBVER";
        NSNumber* version = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if(version == NULL) {
            {
                NSString* sql = @"CREATE TABLE PlayList (id text  PRIMARY KEY , json TEXT NOT NULL)";
                BOOL success = [db executeUpdate:sql];
                NSLog(@"update db %@ :%i", sql, success);
            }
            {
                NSString* sql = @"CREATE TABLE Config (name text  PRIMARY KEY , value TEXT NOT NULL)";
                BOOL success = [db executeUpdate:sql];
                NSLog(@"update db %@ :%i", sql, success);
            }

            version = [NSNumber numberWithInt:100000];
        }
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    }];
    
    Dbase* dbase = [Dbase new];
    dbase.database = database;
    gdb = dbase;
    return gdb;
}


@end
