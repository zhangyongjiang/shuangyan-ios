//
//  OfflineFilePage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/8/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Page.h"
#import "LocalMediaContent.h"

@interface OfflineFilePage : Page

@property(strong, nonatomic) LocalMediaContent* localMediaContent;

-(BOOL)downloaded;
-(void)download;
-(void) downloadWithProgressBlock:(void(^)(CGFloat progress))progressBlock
                  completionBlock:(void(^)(BOOL completed))completionBlock ;

@end
