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

@interface MediaContentVideoView()
{
    MediaPlayer* player;
    AVPlayerLayer *layer;
}

@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self addTarget:self action:@selector(clicked)];
    
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player stop];
    player = nil;
}

-(void)clicked {
    NSLog(@"clicked");
    if(!player)
        [self play];
    else if([player isPlaying:self.localMediaContent])
        [player stop];
    else
        [player play];
}

-(void)play {
//    if(![self.mediaContent isDownloaded]) {
//        NSLog(@"no downloaded yet");
//        return;
//    }
    if(!player) {
        player = [MediaPlayer shared];
        player.attachedView = self;
        PlayTask* task = [[PlayTask alloc] init];
        task.localMediaContent = self.localMediaContent;
        [player playTask:task];
//        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        return;
    }
    if([player isPlaying:self.localMediaContent]) {
//        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player stop];
    }
    else {
//        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        [player setAttachedView:self];
        [player play];
    }
}

-(void)destroy
{
    [player stop];
    [player removeTask:self.localMediaContent];
    player = nil;
}

-(BOOL)isPlaying {
    return [player isPlaying:self.localMediaContent];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.isPlaying)
    {
        [player setAttachedView:self];
    }
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
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
    if(image && false) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf play];
            [SVProgressHUD dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                [player stop];
            });
        });
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
@end
