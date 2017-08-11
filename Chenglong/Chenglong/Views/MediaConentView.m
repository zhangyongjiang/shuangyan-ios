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

-(void)downloadOrPlay {
    BOOL downloaded = [self.mediaContent isDownloaded];
    if(downloaded)
        [self play];
    else
        [self download];
}

-(void)download {
    [self.mediaContent downloadWithProgressBlock:^(CGFloat progress) {
        int downloaded = (int)(progress*100);
        if(progress < 0) {
            downloaded = -100. * progress / self.mediaContent.length.floatValue;
        }
        NSString* txt = [NSString stringWithFormat:@"下载 %i%% of %@", downloaded, self.mediaContent.length];
        [self.btnDownload setTitle:txt forState:UIControlStateNormal];
    } completionBlock:^(BOOL completed) {
        [self.btnDownload setTitle:@"Play" forState:UIControlStateNormal];
        if (![MediaConentView isAudio:self.mediaContent] &&
            ![MediaConentView isVideo:self.mediaContent]) {
            [self play];
        }
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
+(MediaConentView*) createViewForMediaContent:(MediaContent*)mediaContent {
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
    view.width = [UIView screenWidth];
    view.height = [UIView screenWidth];
    view.mediaContent = mediaContent;
    
    view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    view.backgroundColor = [UIColor colorFromRGB:0xeeeeee];
    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    view.layer.borderWidth = 1;
//    view.layer.borderColor = [UIColor colorFromRGB:0xeeeeee].CGColor;
    
    return view;
}

-(void)setMediaContent:(MediaContent *)localMediaContent {
    _mediaContent = localMediaContent;
    BOOL downloaded = [localMediaContent isDownloaded];
    
    if(downloaded) {
        [self.btnDownload setTitle:@"Play" forState:UIControlStateNormal];
    }
    else {
        NSString* txt = [NSString stringWithFormat:@"下载 0%% of %@", localMediaContent.length];
        [self.btnDownload setTitle:txt forState:UIControlStateNormal];
    }
    
    if (![MediaConentView isAudio:self.mediaContent] &&
        ![MediaConentView isVideo:self.mediaContent]) {
        [self play];
    }
}

-(void)addRemoveHandler:(DeleteCallback)callback {
    deleteCallback = callback;
}

-(void)stop{}
@end
