//
//  MediaContent+Local.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContent.h"

@interface MediaContent (Local)

-(BOOL)isDownloaded;
-(NSString*)localFilePath;
-(NSURL*)localUrl;

@end
