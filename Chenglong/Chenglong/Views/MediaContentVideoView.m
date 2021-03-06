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
#import "PlayerControlView.h"

@interface MediaContentVideoView()

@property(assign, nonatomic) BOOL userPlaying;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avplayerContentLoadingNoti:) name:NotificationLoadingRequest object:nil];

//    [self addTarget:self action:@selector(clicked)];
    
    return self;
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    if(self.courseDetails.course.localMediaContent.isVideo)
        self.coverImageView.hidden = YES;
    [SVProgressHUD dismiss];
}

-(void)playEnd:(NSNotification*)noti
{
    NSLog(@"playEnd");
    self.userPlaying = NO;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MediaPlayer* player = [MediaPlayer shared];
    if([player isPlaying:self.courseDetails.course.localMediaContent]) {
        [player stop];
    }
}

-(void)clicked {
    if ([self.courseDetails.course.localMediaContent isAudio] || [self.courseDetails.course.localMediaContent isVideo]) {
        NSMutableArray* array = [NSMutableArray new];
        LocalMediaContentShard* shard = [self.courseDetails.course.localMediaContent getShard:0];
        if(!shard.isDownloaded)
            [array addObject:shard];
        LocalMediaContentShard* shardLast = [self.courseDetails.course.localMediaContent getShard:self.courseDetails.course.localMediaContent.numOfShards-1];
        if(!shardLast.isDownloaded)
            [array addObject:shardLast];
        if(array.count > 0) {
            self.group = [[LocalMediaContentShardGroup alloc] initWithShards:array];
            WeakSelf(weakSelf)
            [self.group downloadWithCompletionBlock:^(BOOL completed) {
                if(completed) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [weakSelf togglePlay];
                        weakSelf.group = nil;
                    });
                }
                else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }];
            return;
        }
    }

    
    [self togglePlay];
}

-(void)togglePlay {
    MediaPlayer* player = [MediaPlayer shared];
    if([player isPlaying:self.courseDetails.course.localMediaContent] && [player isAvplayerPlaying]) {
        [player pause];
        self.userPlaying = NO;
    }
    else if([player isPlaying:self.courseDetails.course.localMediaContent]) {
        [player setAttachedView:self];
        [player resume];
        self.userPlaying = YES;
    }
    else {
        player.attachedView = self;
        PlayTask* task = [[PlayTask alloc] init];
        task.courseDetails = self.courseDetails;
        [player playTask:task];
        self.userPlaying = YES;
    }
}

-(void)avplayerContentLoadingNoti:(NSNotification*)noti
{
    static NSTimeInterval lastTime = 0;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - lastTime < 10)
        return;
    lastTime = now;
    if(!self.userPlaying)
        return;
    
    LocalMediaContent* p = noti.object;
    MediaPlayer* player = [MediaPlayer shared];
    if([player isPlaying:p] && ![player isAvplayerPlaying]) {
        [player resume];
    }
    
}

-(void)play {
    MediaPlayer* player = [MediaPlayer shared];
    if(self.courseDetails.course.localMediaContent.isVideo)
        player.attachedView = self;
    else
        [self showAudioCoverImage];
    PlayTask* task = [[PlayTask alloc] init];
    task.courseDetails = self.courseDetails;
    [player playTask:task];
    self.userPlaying = YES;
    if(!self.courseDetails.course.localMediaContent.isDownloaded) {
        [SVProgressHUD show];
    }
}

-(BOOL)isPlaying {
    MediaPlayer* player = [MediaPlayer shared];
    return [player isPlaying:self.courseDetails.course.localMediaContent] && [player isAvplayerPlaying];
}

-(void)layoutSubviews {
    MediaPlayer* player = [MediaPlayer shared];
    [super layoutSubviews];
    [player setAttachedView:self];
//    if (self.width > 400)
        self.backgroundColor = [UIColor blackColor];
//    else
//        self.backgroundColor = [UIColor whiteColor];
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    MediaPlayer* player = [MediaPlayer shared];
    [super setCourseDetails:courseDetails];
    [player stop];
    player = nil;
    self.coverImageView.hidden = NO;
//    [self showVideoCoverImage];
}

-(void)showVideoCoverImage
{
    WeakSelf(weakSelf)
    
    LocalMediaContentShard* shard = [self.courseDetails.course.localMediaContent getShard:0];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }
    
    shard = [self.courseDetails.course.localMediaContent getShard:self.courseDetails.course.localMediaContent.numOfShards-1];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }
    
    UIImage *image = [self.courseDetails.course.localMediaContent getPlaceholderImageForVideo];
    if(image) {
        self.coverImageView.image = image;
        self.coverImageView.hidden = NO;
        return;
    }

    shard = [self.courseDetails.course.localMediaContent getShard:self.courseDetails.course.localMediaContent.numOfShards-2];
    if(!shard.isDownloaded) {
        [SVProgressHUD show];
        [shard downloadWithProgressBlock:^(LocalMediaContentShard *shard, CGFloat progress) {
            
        } completionBlock:^(LocalMediaContentShard *shard, BOOL completed) {
            [weakSelf showVideoCoverImage];
        } enableBackgroundMode:YES];
        return;
    }

    int maxShard = self.courseDetails.course.localMediaContent.numOfShards-1;
    for(int i=1; i<maxShard;i++) {
        shard = [self.courseDetails.course.localMediaContent getShard:i];
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

-(void)showAudioCoverImage
{
    self.coverImageView.image = [UIImage imageNamed:@"ic_audiotrack_white"];
    self.coverImageView.hidden = NO;
}

-(void)showCoverImage
{
    if(self.courseDetails.course.localMediaContent.isVideo)
        [self showVideoCoverImage];
    else if(self.courseDetails.course.localMediaContent.isAudio)
        [self showAudioCoverImage];
    else
        self.coverImageView.hidden = NO;
    [[MediaPlayer shared] setCurrentTime:0];
}

-(void)stop
{
    [MediaPlayer.shared stop];
}


@end
