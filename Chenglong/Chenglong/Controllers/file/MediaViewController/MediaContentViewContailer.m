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
    return self;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent
{
    _localMediaContent = localMediaContent;
    [self.contentView stop];
    
    if(localMediaContent.isText) {
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
    self.contentView.localMediaContent = localMediaContent;
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
@end
