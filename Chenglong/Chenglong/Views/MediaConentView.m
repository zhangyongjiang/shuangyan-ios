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
#import "TWRDownloadManager.h"

@interface MediaConentView()

@property(strong, nonatomic) FitLabel* metaInfoLabel;
@property(strong, nonatomic) UIButton* btnDownload;
@property(strong, nonatomic) UIButton* btnPlay;

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.metaInfoLabel = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, 60, 0, 0)];
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
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.localMediaContent.mediaContent.url withName:[self.localMediaContent getFileName] inDirectoryNamed:[self.localMediaContent getDirName] progressBlock:^(CGFloat progress) {
        [self.btnDownload setTitle:[NSString stringWithFormat:@"download %f", progress] forState:UIControlStateNormal];
    } completionBlock:^(BOOL completed) {
        [self.btnDownload setEnabled:NO];
    } enableBackgroundMode:NO];

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
    if([MediaConentView isImage:mediaContent]) {
        MediaContentImageView* view = [[MediaContentImageView alloc] init];
        LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
        lmc.mediaContent = mediaContent;
        lmc.filePath = filePath;
        view.localMediaContent = lmc;
        return view;
    }
    if([MediaConentView isAudio:mediaContent]) {
        MediaContentAudioView* view = [[MediaContentAudioView alloc] init];
        LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
        lmc.mediaContent = mediaContent;
        lmc.filePath = filePath;
        view.localMediaContent = lmc;
        return view;
    }
    if([MediaConentView isVideo:mediaContent]) {
        MediaContentVideoView* view = [[MediaContentVideoView alloc] init];
        LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
        lmc.mediaContent = mediaContent;
        lmc.filePath = filePath;
        view.localMediaContent = lmc;
        return view;
    }
    if([MediaConentView isPdf:mediaContent]) {
        MediaContentPdfView* view = [[MediaContentPdfView alloc] init];
        LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
        lmc.mediaContent = mediaContent;
        lmc.filePath = filePath;
        view.localMediaContent = lmc;
        return view;
    }
    return nil;
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
