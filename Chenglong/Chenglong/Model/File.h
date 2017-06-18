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
-(NSData*)getContent;

@property(strong, nonatomic) NSString* dir;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* fullPath;

@end
