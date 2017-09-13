//
//  MediaContentVideoView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/11/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer.h"
#import "LocalMediaContentShard.h"
#import "LocalMediaContentShardGroup.h"

@interface MediaContentVideoView()

@property(strong, nonatomic) UIImageView* coverImageView;
@property(strong, nonatomic) LocalMediaContentShardGroup* group;

@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.coverImageView = [[UIImageView alloc] initWithFrame:frame];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.coverImageView.image = [UIImage imageNamed:@"logo-300x300"];
    [self addSubview:self.coverImageView];
    [self.coverImageView autoPinEdgesToSuperviewMargins];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlaying object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];

    [self addTarget:self action:@selector(clicked)];
    
    return self;
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    self.coverImageView.hidden = YES;
}

-(void)playEnd:(NSNotification*)noti
{
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MediaPlayer* player = [MediaPlayer shared];
    if([player isPlaying:self.localMediaContent]) {
        [player removeTask:self.localMediaContent];
    }
}

-(void)clicked {
    if ([self.localMediaContent isAudio] || [self.localMediaContent isVideo]) {
        NSMutableArray* array = [NSMutableArray new];
        LocalMediaContentShard* shard = [self.localMediaContent getShard:0];
        if(!shard.isDownloaded)
            [array addObject:shard];
        LocalMediaContentShard* shardLast = [self.localMediaContent getShard:self.localMediaContent.numOfShards-1];
        if(!shardLast.isDownloaded)
            [array addObject:shardLast];
        if(array.count > 0) {
            [SVProgressHUD showWithStatus:@"loading..."];
            self.group = [[LocalMediaContentShardGroup alloc] initWithShards:array];
            WeakSelf(weakSelf)
            [self.group downloadWithCompletionBlock:^(BOOL completed) {
                if(completed) {
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [weakSelf play];
                        weakSelf.group = nil;
                    });
                }
                else {
                    [SVProgressHUD showWithStatus:@"下载异常"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }];
            return;
        }
    }

    
    [self play];
}

-(void)play {
    MediaPlayer* player = [MediaPlayer shared];
    if([player isPlaying:self.localMediaContent] && [player isAvplayerPlaying]) {
        [player stop];
    }
    else if([player isPlaying:self.localMediaContent]) {
        [player setAttachedView:self];
        [player play];
    }
    else {
        player.attachedView = self;
        PlayTask* task = [[PlayTask alloc] init];
        task.localMediaContent = self.localMediaContent;
        [player playTask:task];
    }
}

-(void)destroy
{
    MediaPlayer* player = [MediaPlayer shared];
    [player stop];
    [player removeTask:self.localMediaContent];
    player = nil;
}

-(BOOL)isPlaying {
    MediaPlayer* player = [MediaPlayer shared];
    return [player isPlaying:self.localMediaContent] && [player isAvplayerPlaying];
}

-(void)layoutSubviews {
    MediaPlayer* player = [MediaPlayer shared];
    [super layoutSubviews];
    if(self.isPlaying)
    {
        [player setAttachedView:self];
    }
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    MediaPlayer* player = [MediaPlayer shared];
    [super setLocalMediaContent:localMediaContent];
    [player stop];
    player = nil;
    self.coverImageView.hidden = NO;
//    [self showVideoCoverImage];
}

-(void)showVideoCoverImage
{
    WeakSelf(weakSelf)
    
    LocalMediaContentShard* shard = [self.localMediaContent getShard:0];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }
    
    shard = [self.localMediaContent getShard:self.localMediaContent.numOfShards-1];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }
    
    UIImage *image = [self.localMediaContent getPlaceholderImageForVideo];
    if(image) {
        self.coverImageView.image = image;
        self.coverImageView.hidden = NO;
        return;
    }

    shard = [self.localMediaContent getShard:self.localMediaContent.numOfShards-2];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }

    int maxShard = self.localMediaContent.numOfShards-1;
    for(int i=1; i<maxShard;i++) {
        shard = [self.localMediaContent getShard:i];
        if(shard.isDownloaded) {
            continue;
        }
        else {
            [SVProgressHUD show];
            [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
                
            } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
                [weakSelf showVideoCoverImage];
            } enableBackgroundMode:YES];
            return;
        }
    }
    [SVProgressHUD dismiss];
}

-(void)showCoverImage
{
    [self showVideoCoverImage];
    [[MediaPlayer shared] setCurrentTime:0];
}
@end
