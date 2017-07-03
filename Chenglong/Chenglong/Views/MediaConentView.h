//
//  MediaConentView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"
#import "LocalMediaContent.h"

@interface MediaConentView : BaseView

@property(strong, nonatomic) LocalMediaContent* localMediaContent;

@property(strong, nonatomic) UIButton* btnDownload;

+(BOOL) isImage:(MediaContent*)mediaContent;
+(BOOL) isAudio:(MediaContent*)mediaContent;
+(BOOL) isVideo:(MediaContent*)mediaContent;
+(BOOL) isPdf:(MediaContent*)mediaContent;
+(MediaConentView*) createViewForMediaContent:(MediaContent*)mediaContent;

-(void)downloadOrPlay;

@end
