//
//  PlayerControlView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "PlayerControlView.h"

@interface PlayerControlView()


@end

@implementation PlayerControlView

-(id)initWithFrame:(CGRect)frame
{
    CGFloat size = 40;
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    self.btnPlayPause = [UIImageView new];
    self.btnPlayPause.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.btnPlayPause];
    [self.btnPlayPause autoCenterInSuperview];
    [self.btnPlayPause autoSetDimensionsToSize:CGSizeMake(size, size)];
    [self.btnPlayPause addTarget:self action:@selector(playPauseBtnClicked:)];

    self.btnPrev = [UIImageView new];
    self.btnPrev.contentMode = UIViewContentModeScaleAspectFit;
    self.btnPrev.image = [UIImage imageNamed:@"ic_skip_previous"];
    [self addSubview:self.btnPrev];
    [self.btnPrev autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.btnPrev autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnPlayPause];
    [self.btnPrev autoSetDimensionsToSize:CGSizeMake(size, size)];
    
    self.btnNext = [UIImageView new];
    self.btnNext.contentMode = UIViewContentModeScaleAspectFit;
    self.btnNext.image = [UIImage imageNamed:@"ic_skip_next"];
    [self addSubview:self.btnNext];
    [self.btnNext autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.btnNext autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnPlayPause];
    [self.btnNext autoSetDimensionsToSize:CGSizeMake(size, size)];
    
    self.btnFullScreen = [UIImageView new];
    self.btnFullScreen.contentMode = UIViewContentModeScaleAspectFit;
    self.btnFullScreen.image = [UIImage imageNamed:@"ic_fullscreen"];
    [self addSubview:self.btnFullScreen];
    [self.btnFullScreen autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.btnFullScreen autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.btnFullScreen autoSetDimensionsToSize:CGSizeMake(size, size)];
    
    self.btnRepeat = [UIImageView new];
    self.btnRepeat.contentMode = UIViewContentModeScaleAspectFit;
    self.btnRepeat.image = [UIImage imageNamed:@"ic_repeat"];
    [self addSubview:self.btnRepeat];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.btnRepeat autoSetDimensionsToSize:CGSizeMake(size, size)];
    
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

    [self showPlayButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStartNotiHandler:) name:NotificationPlayStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlaying object:nil];

    return self;
}

-(void)playStartNotiHandler:(NSNotification*)noti {
    CGFloat duration = MediaPlayer.shared.currentTaskDuration;
    self.slider.maximumValue = duration;
    self.labelTotalTime.text = [self secondToDuration:duration];
}

-(void)playingNotiHandler:(NSNotification*)noti {
    CGFloat currentTime = MediaPlayer.shared.currentTime;
    self.slider.value = currentTime;
    self.labelCurrentTime.text = [self secondToDuration:currentTime];
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
    self.btnPlayPause.image = [UIImage imageNamed:@"ic_play_arrow"];
}

-(void)showPauseButton
{
    self.btnPlayPause.image = [UIImage imageNamed:@"ic_pause"];
}

-(void)sliderValueChanged:(UISlider *)sender {
    [MediaPlayer.shared setCurrentTime:sender.value ];
}

@end
