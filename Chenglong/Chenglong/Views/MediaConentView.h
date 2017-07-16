//
//  MediaConentView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeleteCallback)(MediaContent* MediaContent);

@interface MediaConentView : BaseView

@property(strong, nonatomic) MediaContent* mediaContent;
@property(strong, nonatomic) UIButton* btnDownload;
@property(strong,nonatomic)UIImageView* btnRemove;
@property(assign, nonatomic) BOOL repeat;

+(BOOL) isImage:(MediaContent*)mediaContent;
+(BOOL) isAudio:(MediaContent*)mediaContent;
+(BOOL) isVideo:(MediaContent*)mediaContent;
+(BOOL) isPdf:(MediaContent*)mediaContent;
+(MediaConentView*) createViewForMediaContent:(MediaContent*)mediaContent;

-(void)downloadOrPlay;
-(void)addRemoveHandler:(DeleteCallback)deleteCallback;
-(void)stop;

@end
