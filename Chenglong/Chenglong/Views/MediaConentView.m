//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"
#import "MediaContentImageView.h"
#import "MediaContentAudioView.h"
#import "MediaContentVideoView.h"
#import "MediaContentPdfView.h"
#import "PureLayout.h"

@interface MediaConentView()


@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.metaInfoLabel = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, Margin, 0, 0)];
    self.metaInfoLabel.numberOfLines = -1;
    [self addSubview:self.metaInfoLabel];
    
    self.btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.btnDownload setTitle:@"download" forState:UIControlStateNormal];
    self.btnDownload.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.btnDownload];
    [self.btnDownload autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.metaInfoLabel];
    [self.btnDownload autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.metaInfoLabel withOffset:Margin];
    [self.btnDownload autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:Margin];
    [self.btnDownload addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    self.btnDownload.userInteractionEnabled = YES;
    
    self.btnPlay = [[UIButton alloc] initWithFrame:self.btnDownload.frame];
    [self addSubview:self.btnPlay];
    [self.btnPlay setTitle:@"play" forState:UIControlStateNormal];
    self.btnPlay.backgroundColor = [UIColor lightGrayColor];
    [self.btnPlay autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.btnDownload withOffset:Margin];

    [self.btnPlay autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.metaInfoLabel];
    [self.btnPlay autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:Margin];
    
    [self.btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateConstraints];
    
    return self;
}

-(void)play {
}

-(void)download {
    [self.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
        [self.btnDownload setTitle:[NSString stringWithFormat:@"download %f%", progress*100] forState:UIControlStateNormal];
    } completionBlock:^(BOOL completed) {
        [self.btnDownload setEnabled:NO];
    }];
}

+(BOOL)isImage:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"image"];
}
+(BOOL)isAudio:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"audio"];
}
+(BOOL)isVideo:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"video"];
}
+(BOOL)isPdf:(MediaContent*)mediaContent {
    return [mediaContent.contentType hasPrefix:@"application/pdf"];
}
+(MediaConentView*) createViewForMediaContent:(MediaContent*)mediaContent andFilePath:(NSString*) filePath {
    MediaConentView* view;
    if([MediaConentView isImage:mediaContent]) {
        view = [[MediaContentImageView alloc] init];
    }
    else if([MediaConentView isAudio:mediaContent]) {
        view = [[MediaContentAudioView alloc] init];
    }
    else if([MediaConentView isVideo:mediaContent]) {
        view = [[MediaContentVideoView alloc] init];
    }
    else if([MediaConentView isPdf:mediaContent]) {
        view = [[MediaContentPdfView alloc] init];
    }
    else
        return nil;
    view.width = [UIView screenWidth] - Margin*2;
    view.height = [UIView screenWidth] - Margin*2;
    LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
    lmc.mediaContent = mediaContent;
    lmc.filePath = filePath;
    view.localMediaContent = lmc;
    view.backgroundColor = [UIColor colorFromHex:0xeeeeee];
    return view;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    _localMediaContent = localMediaContent;
    NSString* meta = [NSString stringWithFormat:@"Name: %@\nType: %@\nLength: %@\nDownloaded: %i", self.localMediaContent.mediaContent.name, self.localMediaContent.mediaContent.contentType, self.localMediaContent.mediaContent.length, [localMediaContent isDownloaded]];
    self.metaInfoLabel.text = meta;
    [self updateConstraints];
    BOOL downloaded = [localMediaContent isDownloaded];
    [self.btnDownload setEnabled:!downloaded];
}

@end
