//
//  MediaViewPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 9/2/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaViewPage.h"

@implementation MediaViewPage

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.galleryView = [[GalleryView alloc] initWithFrame:frame];
    [self addSubview:self.galleryView];
    [self.galleryView autoPinEdgesToSuperviewMargins];
    
    self.btnClose = [self createButton:@"关闭"];
    self.btnClose.frame = CGRectMake(10, 10, 60, 40);
    //    [self addSubview:self.btnClose];
    
    self.btnRepeat = [self createButton:@" 重复 "];
    self.btnRepeat.frame = CGRectMake(10, 10, 100, 40);
    [self addSubview:self.btnRepeat];
    [self.btnRepeat autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.btnRepeat autoPinEdgeToSuperviewMargin:ALEdgeRight];
    [self.btnRepeat addTarget:self action:@selector(btnRepeatClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPrev = [self createButton:@"←"];
    self.btnPrev.frame = CGRectMake(10, 10, 60, 40);
    [self addSubview:self.btnPrev];
    [self.btnPrev autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.btnPrev autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    self.btnNext = [self createButton:@"→"];
    self.btnNext.frame = CGRectMake(10, 10, 60, 40);
    [self addSubview:self.btnNext];
    [self.btnNext autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.btnNext autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    return self;
}

-(void)btnRepeatClicked
{
    int repeat = [self.galleryView toggleRepeat];
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
    NSInteger cnt = [self.galleryView showCourseDetails:courseDetails];
    if(cnt < 2) {
        self.btnNext.hidden = YES;
        self.btnPrev.hidden = YES;
    }
    [self.galleryView play];
}

@end
