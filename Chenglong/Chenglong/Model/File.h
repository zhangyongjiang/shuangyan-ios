//
//  File.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/18/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

-(id)initWithFullPath:(NSString*)path;
-(id)initWithDir:(NSString*)dir andName:(NSString*)name;
-(NSString*)getExt;
-(void)mkdirs;
-(long)length;
-(NSDate*)lastModifiedTime;
-(BOOL)exists;
-(BOOL)isDir;
-(BOOL)isFile;
-(void)writeStringContent:(NSString*)content;
-(NSArray*)ls;
-(NSMutableArray*)deepLs;
-(File*)next:(File*)top;
-(File*)parent;
+(NSString*)homeDir;
+(NSString*)mediaHomeDir;

@property(strong, nonatomic) NSString* dir;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* fullPath;
@property(strong, nonatomic) NSData* content;

@end
