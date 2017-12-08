//
//  PlayerControlView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerControlView.h"
#import "ButtonPrev.h"
#import "ButtonNext.h"
#import "ButtonFullscreen.h"
#import "ButtonLockScreen.h"

@interface PlayerControlView()

@property(assign, nonatomic) int repeat;

@property(strong, nonatomic) UIImageView* btnPlayPause;
@property(strong, nonatomic) UIImageView* btnPrev;
@property(strong, nonatomic) UIImageView* btnLock;
@property(strong, nonatomic) UIImageView* btnNext;
@property(strong, nonatomic) UIImageView* btnRepeat;
@property(strong, nonatomic) UIImageView* btnFullScreen;
@property(strong, nonatomic) FitLabel* labelCurrentTime;
@property(strong, nonatomic) FitLabel* labelTotalTime;
@property(strong, nonatomic) FitLabel* labelProgress;
@property (strong, nonatomic) UISlider* slider;

@end

@implementation PlayerControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.repeat = RepeatAll;
    
    CGFloat size = 60;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    self.btnPlayPause = [UIImageView new];
    self.btnPlayPause.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.btnPlayPause];
    [self.btnPlayPause autoCenterInSuperview];
    [self.btnPlayPause autoSetDimensionsToSize:CGSizeMake(size, size)];
    [self.btnPlayPause addTarget:self action:@selector(playPauseBtnClicked:)];
    [self showPlayButton];

    self.btnPrev = [ButtonPrev createBtnInSuperView:self withIcon:@"ic_skip_previous_white"];
    self.btnNext = [ButtonNext createBtnInSuperView:self withIcon:@"ic_skip_next_white"];
    self.btnFullScreen = [ButtonFullscreen createBtnInSuperView:self withIcon:@"ic_fullscreen_white"];
    self.btnLock = [ButtonLockScreen createBtnInSuperView:self withIcon:@"ic_lock_white"];
    
    self.btnRepeat = [UIImageView new];
    self.btnRepeat.contentMode = UIViewContentModeScaleAspectFit;
    self.btnRepeat.image = [UIImage imageNamed:@"ic_repeat_white"];
    [self addSubview:self.btnRepeat];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.btnRepeat autoSetDimensionsToSize:CGSizeMake(size, size)];
    [self.btnRepeat addTarget:self action:@selector(toggleRepeat)];

    self.slider = [UISlider new];
//    [self.slider setThumbImage:[self imageFromColor:[UIColor blackColor]] forState:UIControlStateNormal];
//    [self.slider setMinimumValueImage:[UIImage new]];
//    [self.slider setMaximumValueImage:[UIImage new]];
    [self addSubview:self.slider];
    [self.slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [self.slider autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.btnFullScreen withOffset:5];
    self.slider.userInteractionEnabled = YES;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.labelTotalTime = [FitLabel new];
    self.labelTotalTime.text = @"1:15";
    [self addSubview:self.labelTotalTime];
    [self.labelTotalTime autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.slider withOffset:1];
    [self.labelTotalTime autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.slider withOffset:0];
    
    self.labelCurrentTime = [FitLabel new];
    self.labelCurrentTime.text = @"0:15";
    [self addSubview:self.labelCurrentTime];
    [self.labelCurrentTime autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.slider withOffset:1];
    [self.labelCurrentTime autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.slider withOffset:0];
    
    self.labelProgress = [FitLabel new];
    self.labelProgress.text = @"下载完成";
    [self addSubview:self.labelProgress];
    [self.labelProgress autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [self.labelProgress autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];

//    self.labelCurrentTime = [FitLabel new];
//    [self addSubview:self.labelCurrentTime];
//    [self.labelCurrentTime autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
//    [self.labelCurrentTime autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStartNotiHandler:) name:NotificationPlayStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlaying object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMultiNotiHandler:) name:NotificationPlayMulti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockScreenNotiHandler:) name:NotificationLockScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFullscreenNotiHandler:) name:NotificationFullscreen object:nil];

    return self;
}

-(void)lockScreenNotiHandler:(NSNotification*)noti
{
    self.hidden = YES;
}

-(void)toggleFullscreenNotiHandler:(NSNotification*)noti
{
    self.hidden = YES;
}

-(void)playMultiNotiHandler:(NSNotification*)noti {
    NSNumber* num = noti.object;
    [self showPrevNext:num.boolValue];
}

-(void)playStartNotiHandler:(NSNotification*)noti {
    CourseDetails* cd = noti.object;
    if(!cd.course.isAudioOrVideo) {
        [self showMediaControl:NO];
        return;
    }
    
    [self showMediaControl:YES];
    CGFloat duration = MediaPlayer.shared.currentTaskDuration;
    self.slider.maximumValue = duration;
    self.labelTotalTime.text = [self secondToDuration:duration];
    [self showPauseButton];
}

-(void)playingNotiHandler:(NSNotification*)noti {
    CGFloat currentTime = MediaPlayer.shared.currentTime;
    self.slider.value = currentTime;
    self.labelCurrentTime.text = [self secondToDuration:currentTime];

    NSNumber* time = [NSNumber numberWithFloat:currentTime];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:CurrentPlayCourseTime];

    static BOOL hiding = NO;
    if (self.hidden || hiding)
        return;
    hiding = YES;
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([MediaPlayer shared].isAvplayerPlaying)
            weakSelf.hidden = YES;
        hiding = NO;
    });
}

-(NSString*)secondToDuration:(CGFloat)seconds {
    int hour = seconds / 3600;
    int minute = (seconds - hour * 3600) / 60;
    int second = seconds - hour * 3600 - minute * 60;
    if (hour == 0)
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    else
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

-(void)playPauseBtnClicked:(id)sender
{
    if(MediaPlayer.shared.isAvplayerPlaying) {
        [MediaPlayer.shared pause];
        [self showPlayButton];
    } else {
        [MediaPlayer.shared resume];
        [self showPauseButton];
        self.hidden = YES;
    }
}


- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 2, 8);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)showPlayButton
{
    self.btnPlayPause.image = [UIImage imageNamed:@"ic_play_arrow_white"];
}

-(void)showPauseButton
{
    self.btnPlayPause.image = [UIImage imageNamed:@"ic_pause_white"];
}

-(void)sliderValueChanged:(UISlider *)sender {
    [MediaPlayer.shared setCurrentTime:sender.value ];
}

-(void)toggleRepeat
{
    if(self.repeat == RepeatNone) {
        self.repeat = RepeatOne;
        self.btnRepeat.image = [UIImage imageNamed:@"ic_repeat_one_white"];
    }
    else if (self.repeat == RepeatAll) {
        self.repeat = RepeatNone;
        self.btnRepeat.image = [UIImage imageNamed:@"ic_no_repeat_white"];
    }
    else if (self.repeat == RepeatOne) {
        self.repeat = RepeatAll;
        self.btnRepeat.image = [UIImage imageNamed:@"ic_repeat_white"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRepeat object:[NSNumber numberWithInt:self.repeat]];
}

-(void)showMediaControl:(BOOL)show {
    self.btnPlayPause.hidden = !show;
    self.labelProgress.hidden = !show;
    self.labelTotalTime.hidden = !show;
    self.labelCurrentTime.hidden = !show;
    self.slider.hidden = !show;
    self.btnRepeat.hidden = !show;
}

-(void)showPrevNext:(BOOL)show {
    self.btnNext.hidden = !show;
    self.btnPrev.hidden = !show;
}
@end

