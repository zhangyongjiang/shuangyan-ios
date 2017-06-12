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

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.metaInfoLabel = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, 60, 0, 0)];
    self.metaInfoLabel.numberOfLines = -1;
    [self addSubview:self.metaInfoLabel];
    
    self.btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(Margin, 200, 200, 50)];
    [self.btnDownload setTitle:@"download" forState:UIControlStateNormal];
    self.btnDownload.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.btnDownload];
//    self.btnDownload.userInteractionEnabled = YES;
    [self.btnDownload addTarget:self action:@selector(downloadNow) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

-(void)downloadNow {
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.localMediaContent.mediaContent.url withName:[self.localMediaContent getFileName] inDirectoryNamed:[self.localMediaContent getDirName] progressBlock:^(CGFloat progress) {
        [self.btnDownload setTitle:[NSString stringWithFormat:@"download %f", progress] forState:UIControlStateNormal];
    } completionBlock:^(BOOL completed) {
//        [self.btnDownload setEnabled:NO];
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
    LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
    lmc.mediaContent = mediaContent;
    lmc.filePath = filePath;
    view.localMediaContent = lmc;
    view.backgroundColor = [UIColor colorFromHex:0xdddddd];
    return view;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    _localMediaContent = localMediaContent;
    NSString* meta = [NSString stringWithFormat:@"Name: %@\nType: %@\nLength: %@\nDownloaded: %i", self.localMediaContent.mediaContent.name, self.localMediaContent.mediaContent.contentType, self.localMediaContent.mediaContent.length, [localMediaContent isDownloaded]];
    self.metaInfoLabel.text = meta;
//    BOOL downloaded = [localMediaContent isDownloaded];
//    [self.btnDownload setEnabled:!downloaded];
}

@end
