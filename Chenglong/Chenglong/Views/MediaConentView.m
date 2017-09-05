//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"
#import "MediaContentImageView.h"
#import "MediaContentAudioView.h"
#import "MediaContentVideoView.h"
#import "MediaContentPdfView.h"
#import "MediaContentTextView.h"
#import "PureLayout.h"
#import "LocalMediaContentShard.h"
#import "LocalMediaContentShardGroup.h"
#import "PlayerControlView.h"
#import "MediaPlayer.h"

@interface MediaConentView()
{
}
@property(strong,nonatomic)PlayerControlView* controlView;

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.controlView = [[PlayerControlView alloc] initWithFrame:self.bounds];
    [self addSubview:self.controlView];
    [self.controlView autoPinEdgesToSuperviewMargins];
    [self.controlView.btn addTarget:self action:@selector(downloadOrPlay)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.controlView.frame = self.bounds;
}

-(void)playEnd:(NSNotification*)noti
{
    if(![self.localMediaContent isEqual:noti.object])
        return;
}

-(void)play {
}

-(void)destroy{
    [[MediaPlayer shared] stopIfPlayingOnView:self];
}

-(void)downloadOrPlay {
    if ([self.localMediaContent isAudio] || [self.localMediaContent isVideo]) {
        NSMutableArray* array = [NSMutableArray new];
        LocalMediaContentShard* shard = [self.localMediaContent getShard:0];
        if(!shard.isDownloaded)
            [array addObject:shard];
        LocalMediaContentShard* shardLast = [self.localMediaContent getShard:self.localMediaContent.numOfShards-1];
        if(!shardLast.isDownloaded)
            [array addObject:shardLast];
        if(array.count==0) {
            [self play];
        } else {
            [SVProgressHUD showWithStatus:@"loading..."];
            __block LocalMediaContentShardGroup* group = [[LocalMediaContentShardGroup alloc] initWithShards:array];
            [group downloadWithCompletionBlock:^(BOOL completed) {
                [SVProgressHUD dismiss];
                NSLog(@"%@", group);
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self play];
                });
            }];
        }
    }
    else  {
        [self play];
    }
}

-(void)preloadAndPlay:(int)numOfShards {
    __block int minShards = numOfShards;
    __block int currentDownloading = 0;
    for(; currentDownloading<numOfShards;currentDownloading++) {
        LocalMediaContentShard* shard = [self.localMediaContent getShard:currentDownloading];
        if(shard.isDownloaded) {
            if(currentDownloading!=(numOfShards-1))
                continue;
            else {
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self play];
                });
                break;
            }
        }
        WeakSelf(weakSelf)
        [self.localMediaContent downloadShard:currentDownloading WithProgressBlock:^(CGFloat progress) {
            NSLog(@"loading %d %f .... ", currentDownloading, progress);
        } completionBlock:^(BOOL completed) {
            [weakSelf preloadAndPlay:minShards];
        }];
        break;
    }
}

-(void)download {
    [self.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
        [self downloadInProgress:progress];
    } completionBlock:^(BOOL completed) {
        [self downloadCompleted];
    }];
}

-(void)downloadInProgress:(CGFloat)progress
{
    int downloaded = (int)(progress*100);
    if(progress < 0) {
        downloaded = -100. * progress / self.localMediaContent.length.floatValue;
    }
    NSString* txt = [NSString stringWithFormat:@"下载 %i%% of %@", downloaded, self.localMediaContent.length];
}

-(void)downloadCompleted
{
    if (![self.localMediaContent isAudio] &&
        ![self.localMediaContent isVideo]) {
        [self play];
    }
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
        [self.localMediaContent isDownloadingProgressBlock:^(CGFloat progress) {
            [self downloadInProgress:progress];
        } completionBlock:^(BOOL completed) {
            [self downloadCompleted];
        }];
    }
    
    if (![self.localMediaContent isAudio] &&
        ![self.localMediaContent isVideo]) {
        [self play];
    }
}

-(void)stop{}
@end
