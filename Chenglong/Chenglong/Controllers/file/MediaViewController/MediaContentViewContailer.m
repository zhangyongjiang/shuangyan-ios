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

@interface MediaContentViewContailer()<UIGestureRecognizerDelegate>

@property(strong, nonatomic) MediaContentTextView* textView;
@property(strong, nonatomic) MediaContentImageView* imageView;
@property(strong, nonatomic) MediaContentPdfView* pdfView;
@property(strong, nonatomic) MediaContentVideoView* videoView;

@property(weak, nonatomic) MediaConentView* contentView;

@property(strong, nonatomic) PlayerControlView* controlView;

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
    
    self.controlView = [PlayerControlView new];
    [self addSubview:self.controlView];
    [self.controlView autoPinEdgesToSuperviewMargins];
    self.controlView.hidden = YES;

    UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    webViewTapped.numberOfTapsRequired = 1;
    webViewTapped.delegate = self;
    [self addGestureRecognizer:webViewTapped];

    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    if([self isPoint:point inX0:0 y:0 x1:btnsize y1:btnsize] ||
       [self isPoint:point inX0:(self.width-btnsize) y:0 x1:self.width y1:btnsize] ||
       [self isPoint:point inX0:(0) y:(self.height-btnsize) x1:btnsize y1:self.height] ||
       [self isPoint:point inX0:(self.width-btnsize) y:(self.height-btnsize) x1:self.width y1:self.height] ||
       [self isPoint:point inX0:0 y:(self.height/2-btnsize/2) x1:btnsize y1:(self.height/2+btnsize/2)] ||
       [self isPoint:point inX0:(self.width-btnsize) y:(self.height/2-btnsize/2) x1:self.width y1:(self.height/2+btnsize/2)] ||
       [self isPoint:point inX0:(self.width/2-btnsize/2) y:(self.height/2-btnsize/2) x1:(self.width/2+btnsize/2) y1:(self.height/2+btnsize/2)]

       ) {
        return;
    }
    self.controlView.hidden = !self.controlView.hidden;
}

-(BOOL)isPoint:(CGPoint)p inX0:(CGFloat)x0 y:(CGFloat)y0 x1:(CGFloat)x1 y1:(CGFloat)y1 {
    return p.x>x0 && p.x < x1 && p.y>y0 && p.y<y1;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    [self.contentView stop];
    
    LocalMediaContent* localMediaContent = courseDetails.course.localMediaContent;
    if(localMediaContent == NULL) {
        self.contentView = self.textView;
    }
    else if(localMediaContent.isText) {
        self.contentView = self.textView;
    }
    else if(localMediaContent.isPdf) {
        self.contentView = self.pdfView;
    }
    else if(localMediaContent.isImage) {
        self.contentView = self.imageView;
    }
    else if(localMediaContent.isAudio) {
        self.contentView = self.videoView;
    }
    else if(localMediaContent.isVideo) {
        self.contentView = self.videoView;
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
    [MediaPlayer.shared setCurrentTime:0.];
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
