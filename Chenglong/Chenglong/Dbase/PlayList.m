//
//  PlayList.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/3/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayList.h"
#import "ObjectMapper.h"

@implementation PlayList

-(FMDatabaseQueue*) database {
    return Dbase.shared.database;
}

-(BOOL)savePlayList:(NSArray*)list {
    for (CourseDetails* cd in list) {
        __block BOOL success = NO;
        [self.database inDatabase:^(FMDatabase *db) {
            NSString* json = [cd toJson];
            NSString* sql = @"insert into PlayList (id, json) values (?, ?)";
            success = [db executeUpdate:sql, cd.course.id, json];
            if (!success) {
                NSLog(@"insert play list failed");
            }
        }];
        if (!success) {
            return success;
        }
    }
    return TRUE;
}

-(BOOL)deleteAllPlayList {
    __block BOOL success = NO;
    [self.database inDatabase:^(FMDatabase *db) {
        NSString* sql = @"delete from PlayList";
        success = [db executeUpdate:sql];
        if (!success) {
            NSLog(@"delete play list failed");
        }
    }];
    return success;
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

-(NSMutableArray*)getPlayList {
    __block NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    [self.database inDatabase:^(FMDatabase *db) {
        NSString* sql = @"select json from PlayList";
        FMResultSet *s = [db executeQuery:sql];
        while ([s next]) {
            NSString* jsonstr = [s stringForColumnIndex:0];
            CourseDetails* resp = [self fromJsonString:jsonstr];
            [array addObject:resp];
        }
    }];
    return array;
}

@end

