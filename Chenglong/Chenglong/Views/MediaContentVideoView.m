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

@interface MediaContentVideoView()
{
    MediaPlayer* player;
    AVPlayerLayer *layer;
}

@property(strong,nonatomic)UIImageView* thumbnailImgView;
@end

@implementation MediaContentVideoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.thumbnailImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.thumbnailImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.thumbnailImgView];
    [self.thumbnailImgView autoPinEdgesToSuperviewMargins];
    
    [self addTarget:self action:@selector(clicked)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(background:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foreground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    return self;
}

-(void)background:(NSNotification*)noti {
    [layer removeFromSuperlayer];
    layer = nil;
    [player play];
}

-(void)foreground:(NSNotification*)noti {
    if(layer) return;
    layer = [AVPlayerLayer playerLayerWithPlayer:player.avplayer];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player pause];
    player = nil;
}

-(void)clicked {
    NSLog(@"clicked");
    if(!player)
        [self play];
    else if([player isPlaying])
        [player pause];
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
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
        self.thumbnailImgView.hidden = YES;
        return;
    }
    if([player isPlaying]) {
        [self.btnDownload setTitle:@"播放" forState: UIControlStateNormal];
        [player pause];
    }
    else {
        [self.btnDownload setTitle:@"暂停" forState: UIControlStateNormal];
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
    return [player isPlaying];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.isPlaying) {
        [player setAttachedView:self];
    }
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    [super setLocalMediaContent:localMediaContent];
    [SVProgressHUD show];
    [localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
    } completionBlock:^(BOOL completed) {
        [localMediaContent getPlaceholderImageForVideo:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnailImgView.image = image;
                [SVProgressHUD dismiss];
            });
        }];
    } forShards:0,1,localMediaContent.numOfShards-1,-1];
}
@end
