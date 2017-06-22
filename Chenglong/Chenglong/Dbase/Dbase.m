//
//  Dbase.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Dbase.h"
#import "FMDB.h"
#import "ObjectMapper.h"

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
        NSString* sql = @"CREATE TABLE courseDetails (id text  PRIMARY KEY , json TEXT NOT NULL, isDir integer NOT NULL, parentCourseId text, userId text NOT NULL, updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)";
        BOOL success = [database executeUpdate:sql];
        NSLog(@"update db %@ :%i", sql, success);
        version = [NSNumber numberWithInt:100000];
    }
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    
    [database close];
    
    Dbase* dbase = [Dbase new];
    
    gdb = dbase;
    return gdb;
}

-(BOOL)saveList:(CourseDetailsList*)list {
    [self save:list.courseDetails];
    for (CourseDetails* cd in list.items) {
        [self save:cd];
    }
    return TRUE;
}

-(BOOL)save:(CourseDetails *)cd {
    if(cd == NULL)
        return TRUE;
    NSString* json = [cd toJson];
    [self.database open];
    NSString* cid = cd.course.id;
    int dir = cd.course.isDir.intValue;
    NSString* userId = cd.course.userId;
    NSString* parent = cd.course.parentCourseId;
    
    NSString* sql = @"delete from courseDetails where id=?";
    [self.database executeUpdate:sql, cid];
    
    sql = @"insert into courseDetails (id, json, idDir, parentCourseId, userId) values (?, ?, ?, ?, ?)";
    BOOL success = [self.database executeUpdate:sql, cid, json, dir, parent, userId];
    [self.database close];
    return success;
}

-(CourseDetails*)getCourseDetailsById:(NSString *)cid {
    NSMutableArray* array = [self getCourseDetailsListByColumn:@"id" andValue:cid];
    if(array.count ==0 )
        return NULL;
    return [array objectAtIndex:0];
}

-(CourseDetails*)fromJsonString:(NSString*)jsonstr {
    NSData* data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    ObjectMapper* mapper = [ObjectMapper mapper];
    CourseDetails* resp = [mapper mapObject:json toClass:[CourseDetails class] withError:&error];
    return resp;
}

-(NSMutableArray*)getChildCourseDetails:(NSString*)parent {
    return [self getCourseDetailsListByColumn:@"parentCourseId" andValue:parent];
}

-(NSMutableArray*)getCourseDetailsListByColumn:(NSString*)columnName andValue:(NSObject*)value {
    [self.database open];
    NSString* sql = @"select json from courseDetails where ?=?";
    FMResultSet *s = [self.database executeQuery:sql, columnName, value];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    while ([s next]) {
        NSString* jsonstr = [s stringForColumnIndex:0];
        CourseDetails* resp = [self fromJsonString:jsonstr];
        [array addObject:resp];
    }
    [self.database close];
    return array;
}

-(CourseDetailsList*)getCourseDetailsList:(NSString*)cid {
    CourseDetailsList* list = [CourseDetailsList new];
    list.courseDetails = [self getCourseDetailsById:cid];
    list.items = [self getChildCourseDetails:cid];
    return list;
}

-(CourseDetailsList*)getUserRootCourseDetailsList:(NSString*)userId {
    NSMutableArray* array = [self getCourseDetailsListByColumn:@"userId" andValue:userId];
    CourseDetailsList* list = [CourseDetailsList new];
    list.items = array;
    return list;
}
@end
