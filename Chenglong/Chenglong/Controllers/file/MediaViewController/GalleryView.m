//
//  GalleryView.m
//
//
//  Created by Kevin Zhang on 1/1/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "GalleryView.h"
#import "MediaContentViewContailer.h"
#import "Progress.h"
#import "LocalMediaContentShard.h"

@interface GalleryView()
{
    int currentPlay;
}

@property(strong,nonatomic)NSMutableArray* mediaContents;
@property(strong, nonatomic)MediaContentViewContailer* containerView;

@end

@implementation GalleryView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.mediaContents = [[NSMutableArray alloc] init];
    currentPlay = -1;
    self.repeat = RepeatNone;
    self.autoplay = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.containerView = [[MediaContentViewContailer alloc]initWithFrame:frame];
    [self addSubview:self.containerView];
    [self.containerView autoPinEdgesToSuperviewMargins];
    
    self.btnRepeat = [self createButton:@" 重复 "];
    self.btnRepeat.frame = CGRectMake(10, 10, 100, 40);
    [self addSubview:self.btnRepeat];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.btnRepeat autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.btnRepeat addTarget:self action:@selector(btnRepeatClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPrev = [self createButton:@"←"];
    self.btnPrev.frame = CGRectMake(10, 10, 60, 40);
    [self addSubview:self.btnPrev];
    [self.btnPrev autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.btnPrev autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    self.btnNext = [self createButton:@"→"];
    self.btnNext.frame = CGRectMake([UIView screenWidth]-70, [UIView screenHeight]-50, 60, 40);
    [self addSubview:self.btnNext];
    [self.btnNext autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.btnNext autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    self.labelProgress = [FitLabel new];
    [self addSubview:self.labelProgress];
    [self.labelProgress autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.labelProgress autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingNotiHandler:) name:NotificationPlaying object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPaused:) name:NotificationPlayPaused object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDownloadedNoti:) name:NotificationDownloadCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDownloadingNoti:) name:NotificationDownloading object:nil];
    
    [self.btnPrev addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNext addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}


-(void)previous:(id)sender
{
    if(self.mediaContents.count<2)
        return;
    if(sender)
        self.autoplay = NO;
    currentPlay--;
    if(currentPlay <0 ) {
        currentPlay = self.mediaContents.count-1;
    }
    [self showPage:currentPlay];
    [self play];
}

-(void)next:(id)sender
{
    if(self.mediaContents.count<2)
        return ;
    if(sender)
        self.autoplay = NO;
    currentPlay++;
    if(currentPlay >= self.mediaContents.count) {
        currentPlay = 0;
    }
    [self showPage:currentPlay];
    [self play];
}


-(void)btnRepeatClicked
{
    int repeat = [self toggleRepeat];
    if (repeat == RepeatNone)
        [self.btnRepeat setTitle:@"不重复" forState:UIControlStateNormal];
    else if (repeat == RepeatOne)
        [self.btnRepeat setTitle:@"重复当前" forState:UIControlStateNormal];
    else if (repeat == RepeatAll)
        [self.btnRepeat setTitle:@"重复所有" forState:UIControlStateNormal];
}

-(UIButton*)createButton:(NSString*)text
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
    btn.backgroundColor = [UIColor colorFromRGB:0xffffff];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btn.height / 4.;
    return btn;
}

-(void)setCourseDetails:(CourseDetails*)courseDetails
{
    _courseDetails = courseDetails;
    [self showCourseDetails:courseDetails];
    if(self.mediaContents.count < 2) {
        self.btnNext.hidden = YES;
        self.btnPrev.hidden = YES;
    }
    [self play];
}

-(LocalMediaContent*)currentMediaContent
{
    if(currentPlay!=-1) {
        return [self.mediaContents objectAtIndex:currentPlay];
    }
    return NULL;
}

-(void)playingNotiHandler:(NSNotification*)noti
{
    self.labelProgress.hidden = UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation);
    self.btnRepeat.hidden = YES;
    self.btnPrev.hidden = YES;
    self.btnNext.hidden = YES;
}


-(void)playPaused:(NSNotification*)noti
{
    if(!self.btnRepeat.hidden)
        return;
    self.btnRepeat.hidden = NO;
    self.labelProgress.hidden = NO;
    self.btnPrev.hidden = !(self.mediaContents.count>1);
    self.btnNext.hidden = !(self.mediaContents.count>1);
}

-(void)playEnd:(NSNotification*)noti
{
    if(self.repeat == RepeatAll) {
        currentPlay++;
        if(currentPlay >= self.mediaContents.count) {
            currentPlay = 0;
        }
        [self showPage:currentPlay];
        [self play];
    }
    else if(self.repeat == RepeatOne) {
        [self play];
    }
    else  {
        if (self.autoplay) {
            if(currentPlay != (self.mediaContents.count-1))
                [self next:NULL];
            else
                [self.containerView showCoverImage];
        }
        else {
            [self.containerView showCoverImage];
        }
    }
}

-(void)contentDownloadedNoti:(NSNotification*)noti
{
    LocalMediaContent* mc = noti.object;
    // can we start to download next play item ???
}

-(void)contentDownloadingNoti:(NSNotification*)noti
{
    __block Progress* mc = noti.object;
    WeakSelf(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* label = [NSString stringWithFormat:@"下载中 %ld of %ld", mc.current, mc.expected];
        if(mc.object.isDownloaded)
            label = @"下载完成";
        weakSelf.labelProgress.text = label;
    });
}

-(int)toggleRepeat
{
    if(self.repeat == RepeatNone)
        self.repeat = RepeatOne;
    else if(self.repeat == RepeatOne)
        self.repeat = RepeatAll;
    else if(self.repeat == RepeatAll)
        self.repeat = RepeatNone;
    return self.repeat;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
}

-(void)showCourseDetails:(CourseDetails *)courseDetails
{
    NSString* content = courseDetails.course.content;
    NSArray * mediaContents = courseDetails.course.resources;
    content = [content trim];
    if(content.length>0) {
        LocalMediaContent* mc = [LocalMediaContent new];
        mc.contentType = @"text";
        mc.content = content;
        mc.parent = courseDetails.course;
        [self.mediaContents addObject:mc];
    }
    
    if(mediaContents) {
        [self.mediaContents addObjectsFromArray:mediaContents];
        for(LocalMediaContent* lmc in mediaContents) {
            lmc.parent = courseDetails.course;
        }
    }
    
    for (CourseDetails* child in courseDetails.items) {
        [self showCourseDetails:child];
    }
    
    if(self.mediaContents.count > 0 ) {
        if(currentPlay == -1) {
            [self showPage:0];
        }
    }
}

-(void)showPage:(int)index {
    currentPlay = index;
    LocalMediaContent* mc = [self.mediaContents objectAtIndex:index];
    self.containerView.localMediaContent = mc;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(void)play
{
    if(self.mediaContents.count == 0)
        return;
    [self showPage:currentPlay];
    
    [self.containerView play];
}

-(void)stop
{
    [self.containerView stop];
}
@end
