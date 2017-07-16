//
//  MediaContent+Local.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent.h"

@interface MediaContent (Local)

@property(strong, nonatomic)NSString* filePath;

-(BOOL)isDownloaded;
-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock ;
-(NSString*)getFileName;
-(NSString*)getDirName;
-(NSString*)getFileExtension;
-(void)createDirs;

-(NSString*)localFilePath;
-(NSURL*)playUrl;

@end
