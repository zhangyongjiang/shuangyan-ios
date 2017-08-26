//
//  MediaConentView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeleteCallback)(LocalMediaContent* MediaContent);

@interface MediaConentView : BaseView

@property(strong, nonatomic) LocalMediaContent* localMediaContent;
//@property(strong, nonatomic) UIButton* btnDownload;
@property(assign, nonatomic) BOOL repeat;

+(BOOL) isImage:(LocalMediaContent*)localMediaContent;
+(BOOL) isAudio:(LocalMediaContent*)localMediaContent;
+(BOOL) isVideo:(LocalMediaContent*)localMediaContent;
+(BOOL) isPdf:(LocalMediaContent*)localMediaContent;
+(MediaConentView*) createViewForMediaContent:(LocalMediaContent*)localMediaContent;

-(void)downloadOrPlay;
-(void)addRemoveHandler:(DeleteCallback)deleteCallback;
-(void)stop;
-(void)play;
-(void)destroy;

@end
