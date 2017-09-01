//
//  MediaContentViewContailer.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/31/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaContentViewContailer.h"
#import "MediaContentAudioView.h"
#import "MediaContentVideoView.h"
#import "MediaContentTextView.h"
#import "MediaContentPdfView.h"
#import "MediaContentImageView.h"

@interface MediaContentViewContailer()

@property(strong, nonatomic) MediaContentTextView* textView;
@property(strong, nonatomic) MediaContentImageView* imageView;
@property(strong, nonatomic) MediaContentPdfView* pdfView;
@property(strong, nonatomic) MediaContentAudioView* audioView;
@property(strong, nonatomic) MediaContentVideoView* videoView;

@property(strong, nonatomic) MediaConentView* contentView;

@end

@implementation MediaContentViewContailer

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textView = [[MediaContentTextView alloc]initWithFrame:frame];
    self.imageView = [[MediaContentImageView alloc]initWithFrame:frame];
    self.audioView = [[MediaContentAudioView alloc]initWithFrame:frame];
    self.videoView = [[MediaContentVideoView alloc]initWithFrame:frame];
    self.pdfView = [[MediaContentPdfView alloc]initWithFrame:frame];
    [self addSubview:self.textView];
    [self addSubview:self.imageView];
    [self addSubview:self.pdfView];
    [self addSubview:self.audioView];
    [self addSubview:self.videoView];
    [self.textView autoPinEdgesToSuperviewMargins];
    [self.imageView autoPinEdgesToSuperviewMargins];
    [self.pdfView autoPinEdgesToSuperviewMargins];
    [self.audioView autoPinEdgesToSuperviewMargins];
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
        self.contentView = self.audioView;
    }
    else if(localMediaContent.isVideo) {
        self.contentView = self.videoView;
    }
    self.contentView.localMediaContent = localMediaContent;
    [self bringSubviewToFront:self.contentView];
}

-(void)play
{
    [self.contentView play];
}

-(void)stop
{
    [self.contentView stop];
}
@end
