//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"
#import "MediaContentImageView.h"
#import "MediaContentVideoView.h"
#import "MediaContentPdfView.h"
#import "MediaContentTextView.h"
#import "PureLayout.h"
#import "LocalMediaContentShard.h"
#import "LocalMediaContentShardGroup.h"
#import "PlayerControlView.h"
#import "MediaPlayer.h"

@interface MediaConentView()

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];

    return self;
}

-(void)play {
}

+(MediaConentView*) createViewForMediaContent:(LocalMediaContent*)localMediaContent {
    MediaConentView* view;
    if([localMediaContent isImage]) {
        view = [[MediaContentImageView alloc] init];
    }
    else if([localMediaContent isAudio]) {
//        view = [[MediaContentAudioView alloc] init];
        view = [[MediaContentVideoView alloc] init];
    }
    else if([localMediaContent isVideo]) {
        view = [[MediaContentVideoView alloc] init];
    }
    else if([localMediaContent isPdf]) {
        view = [[MediaContentPdfView alloc] init];
    }
    else if([localMediaContent isText]) {
        view = [[MediaContentTextView alloc] init];
    }
    else
        return nil;
    view.width = [UIView screenWidth];
    view.height = [UIView screenWidth];
    view.localMediaContent = localMediaContent;
    
    view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    view.layer.borderWidth = 1;
//    view.layer.borderColor = [UIColor colorFromRGB:0xeeeeee].CGColor;
    
    return view;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    _localMediaContent = localMediaContent;
    BOOL downloaded = [localMediaContent isDownloaded];
    
    if(!downloaded) {
        CGFloat progress = 0.;
        if(localMediaContent.length.floatValue>1)
            progress = ((CGFloat)localMediaContent.currentLocalFileLength) /localMediaContent.length.floatValue * 100.;
    }
    
    if (![self.localMediaContent isAudio] &&
        ![self.localMediaContent isVideo]) {
        [self play];
    }
}

-(void)stop{}

-(void)showCoverImage
{
}
@end
