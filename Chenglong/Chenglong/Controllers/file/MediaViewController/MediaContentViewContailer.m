//
//  MediaContentViewContailer.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/31/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentViewContailer.h"
#import "MediaContentVideoView.h"
#import "MediaContentTextView.h"
#import "MediaContentPdfView.h"
#import "MediaContentImageView.h"

@interface MediaContentViewContailer()

@property(strong, nonatomic) MediaContentTextView* textView;
@property(strong, nonatomic) MediaContentImageView* imageView;
@property(strong, nonatomic) MediaContentPdfView* pdfView;
@property(strong, nonatomic) MediaContentVideoView* videoView;

@property(weak, nonatomic) MediaConentView* contentView;

@property(strong, nonatomic) PlayerControlView* controlView;
@property(strong, nonatomic) UIView* coverView;

@end

@implementation MediaContentViewContailer

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textView = [[MediaContentTextView alloc]initWithFrame:frame];
    self.imageView = [[MediaContentImageView alloc]initWithFrame:frame];
    self.videoView = [[MediaContentVideoView alloc]initWithFrame:frame];
    self.pdfView = [[MediaContentPdfView alloc]initWithFrame:frame];
    [self addSubview:self.textView];
    [self addSubview:self.imageView];
    [self addSubview:self.pdfView];
    [self addSubview:self.videoView];
    [self.textView autoPinEdgesToSuperviewMargins];
    [self.imageView autoPinEdgesToSuperviewMargins];
    [self.pdfView autoPinEdgesToSuperviewMargins];
    [self.videoView autoPinEdgesToSuperviewMargins];
    
    self.coverView = [UIView new];
    [self addSubview:self.coverView];
    [self.coverView autoPinEdgesToSuperviewMargins];
    [self.coverView addTarget:self action:@selector(coverViewClicked)];

    self.controlView = [PlayerControlView new];
    [self addSubview:self.controlView];
    [self.controlView autoPinEdgesToSuperviewMargins];
    self.controlView.hidden = YES;

    return self;
}

-(void)coverViewClicked {
    self.controlView.hidden = NO;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    [self.contentView stop];
    
    LocalMediaContent* localMediaContent = courseDetails.course.localMediaContent;
    if(localMediaContent == NULL) {
        self.contentView = self.textView;
        self.coverView.hidden = YES;
    }
    else if(localMediaContent.isText) {
        self.contentView = self.textView;
        self.coverView.hidden = YES;
    }
    else if(localMediaContent.isPdf) {
        self.contentView = self.pdfView;
        self.coverView.hidden = YES;
    }
    else if(localMediaContent.isImage) {
        self.contentView = self.imageView;
        self.coverView.hidden = NO;
    }
    else if(localMediaContent.isAudio) {
        self.contentView = self.videoView;
        self.coverView.hidden = NO;
    }
    else if(localMediaContent.isVideo) {
        self.contentView = self.videoView;
        self.coverView.hidden = NO;
    }
    self.contentView.courseDetails = courseDetails;
    [self showView:self.contentView];
}

-(void)showView:(UIView*)view
{
    self.textView.hidden = !(view == self.textView);
    self.imageView.hidden = !(view == self.imageView);
    self.pdfView.hidden = !(view == self.pdfView);
    self.videoView.hidden = !(view == self.videoView);
}

-(void)play
{
    [self.contentView play];
}

-(void)stop
{
    [self.contentView stop];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textView removeFromSuperview];
    [self.imageView removeFromSuperview];
    [self.pdfView removeFromSuperview];
    [self.videoView removeFromSuperview];
    self.textView = NULL;
    self.imageView = NULL;
    self.pdfView = NULL;
    self.videoView = NULL;
    self.contentView = NULL;
}

-(void)showCoverImage
{
    [self.contentView showCoverImage];
}
@end
