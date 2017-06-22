//
//  Dbase.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Dbase.h"
#import "FMDB.h"

Dbase* gdb;

@interface Dbase()

@property(strong, nonatomic)FMDatabase* database;

@end


@implementation Dbase

+(Dbase*)shared {
    if(gdb)
        return gdb;
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"bbzj.sqlite"];
    
    FMDatabase*database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString* key = @"DBVER";
    NSNumber* version = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(version == NULL) {
        [database executeUpdate:@"CREATE TABLE course (id text  PRIMARY KEY , json TEXT DEFAULT NULL, dir integer, parent text)"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:key];
    }
    
    [database close];
    
    Dbase* dbase = [Dbase new];
    
    gdb = dbase;
    return gdb;
}

@end
