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
#import "PureLayout.h"
#import "LocalMediaContentShard.h"
#import "LocalMediaContentShardGroup.h"
#import "PlayerControlView.h"

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
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.controlView.frame = self.bounds;
}

-(void)play {
}

-(void)destroy{
    
}

-(void)downloadOrPlay {
    if ([MediaConentView isAudio:self.localMediaContent]) {
        [SVProgressHUD showWithStatus:@"loading..."];
        LocalMediaContentShard* shard = [self.localMediaContent getShard:0];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self play];
            });
        } enableBackgroundMode:YES];
    }
    else if ([MediaConentView isVideo:self.localMediaContent]) {
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
    if (![MediaConentView isAudio:self.localMediaContent] &&
        ![MediaConentView isVideo:self.localMediaContent]) {
        [self play];
    }
}

+(BOOL)isImage:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"image"];
}
+(BOOL)isAudio:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"audio"];
}
+(BOOL)isVideo:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"video"];
}
+(BOOL)isPdf:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"application/pdf"];
}
+(MediaConentView*) createViewForMediaContent:(LocalMediaContent*)localMediaContent {
    MediaConentView* view;
    if([MediaConentView isImage:localMediaContent]) {
        view = [[MediaContentImageView alloc] init];
    }
    else if([MediaConentView isAudio:localMediaContent]) {
        view = [[MediaContentAudioView alloc] init];
    }
    else if([MediaConentView isVideo:localMediaContent]) {
        view = [[MediaContentVideoView alloc] init];
    }
    else if([MediaConentView isPdf:localMediaContent]) {
        view = [[MediaContentPdfView alloc] init];
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
    
    if (![MediaConentView isAudio:self.localMediaContent] &&
        ![MediaConentView isVideo:self.localMediaContent]) {
        [self play];
    }
}

-(void)stop{}
@end
