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
#import "LocalMediaContentShard.h"

@interface MediaConentView()
{
    DeleteCallback deleteCallback;
}

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    
    self.btnDownload = [UIButton new];
    [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    self.btnDownload.backgroundColor = [UIColor mainColor];
    [self addSubview:self.btnDownload];
    [self.btnDownload autoCenterInSuperview];
    [self.btnDownload autoSetDimensionsToSize:CGSizeMake([UIView screenWidth]/1.5, 40.)];
    [self.btnDownload addTarget:self action:@selector(downloadOrPlay) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRemove = [UIImageView new];
    [self addSubview:self.btnRemove];
    self.btnRemove.layer.zPosition = 1000;
    self.btnRemove.image = [UIImage imageNamed:@"file_love_icon_sel"];
    [self.btnRemove autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [self.btnRemove autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.btnRemove autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.btnRemove.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.btnRemove addTarget:self action:@selector(removeResource)];
    
    return self;
}

-(void)removeResource {
    self.repeat = !self.repeat;
    if(self.repeat)
        self.btnRemove.image = [UIImage imageNamed:@"file_love_icon_sel"];
    else
        self.btnRemove.image = [UIImage imageNamed:@"file_love_icon"];
//    if(deleteCallback)
//        deleteCallback(self.localMediaContent);
}

-(void)play {
}

-(void)destroy{
    
}

-(void)downloadOrPlay {
    BOOL downloaded = [self.localMediaContent isDownloaded];
    if(downloaded)
        [self play];
    else {
        LocalMediaContentShard* shard = [self.localMediaContent getShard:0];
        if(shard.isDownloaded) {
            [self play];
        }
        else {
            WeakSelf(weakSelf)
            [self.localMediaContent downloadShard:0 WithProgressBlock:^(CGFloat progress) {
                NSLog(@"loading...");
            } completionBlock:^(BOOL completed) {
                [weakSelf play];
            }];
        }
    }
}

-(void)download {
    [self.localMediaContent downloadWithProgressBlock:^(CGFloat progress) {
        [self downloadInProgress:progress];
    } completionBlock:^(BOOL completed) {
        [self downloadCompleted];
    }];
}

-(void)downloadInProgress:(CGFloat)progress
{
    int downloaded = (int)(progress*100);
    if(progress < 0) {
        downloaded = -100. * progress / self.localMediaContent.length.floatValue;
    }
    NSString* txt = [NSString stringWithFormat:@"下载 %i%% of %@", downloaded, self.localMediaContent.length];
    [self.btnDownload setTitle:txt forState:UIControlStateNormal];
}

-(void)downloadCompleted
{
    [self.btnDownload setTitle:@"Play" forState:UIControlStateNormal];
    if (![MediaConentView isAudio:self.localMediaContent] &&
        ![MediaConentView isVideo:self.localMediaContent]) {
        [self play];
    }
}

+(BOOL)isImage:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"image"];
}
+(BOOL)isAudio:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"audio"];
}
+(BOOL)isVideo:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"video"];
}
+(BOOL)isPdf:(LocalMediaContent*)localMediaContent {
    return [localMediaContent.contentType hasPrefix:@"application/pdf"];
}
+(MediaConentView*) createViewForMediaContent:(LocalMediaContent*)localMediaContent {
    MediaConentView* view;
    if([MediaConentView isImage:localMediaContent]) {
        view = [[MediaContentImageView alloc] init];
    }
    else if([MediaConentView isAudio:localMediaContent]) {
        view = [[MediaContentAudioView alloc] init];
    }
    else if([MediaConentView isVideo:localMediaContent]) {
        view = [[MediaContentVideoView alloc] init];
    }
    else if([MediaConentView isPdf:localMediaContent]) {
        view = [[MediaContentPdfView alloc] init];
    }
    else
        return nil;
    view.width = [UIView screenWidth];
    view.height = [UIView screenWidth];
    view.localMediaContent = localMediaContent;
    
    view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    view.backgroundColor = [UIColor colorFromRGB:0xeeeeee];
    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    view.layer.borderWidth = 1;
//    view.layer.borderColor = [UIColor colorFromRGB:0xeeeeee].CGColor;
    
    return view;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    _localMediaContent = localMediaContent;
    BOOL downloaded = [localMediaContent isDownloaded];
    
    if(downloaded) {
        [self.btnDownload setTitle:@"Play" forState:UIControlStateNormal];
    }
    else {
        NSString* txt = [NSString stringWithFormat:@"下载 0%% of %@", localMediaContent.length];
        [self.btnDownload setTitle:txt forState:UIControlStateNormal];
        [self.localMediaContent isDownloadingProgressBlock:^(CGFloat progress) {
            [self downloadInProgress:progress];
        } completionBlock:^(BOOL completed) {
            [self downloadCompleted];
        }];
    }
    
    if (![MediaConentView isAudio:self.localMediaContent] &&
        ![MediaConentView isVideo:self.localMediaContent]) {
        [self play];
    }
}

-(void)addRemoveHandler:(DeleteCallback)callback {
    deleteCallback = callback;
}

-(void)stop{}
@end
