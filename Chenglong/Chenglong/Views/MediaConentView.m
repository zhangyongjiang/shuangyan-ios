//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"

@interface MediaConentView()

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.metaInfoLabel = [[FitLabel alloc] initWithFrame:CGRectMake(Margin, 60, 0, 0)];
    self.metaInfoLabel.numberOfLines = -1;
    [self addSubview:self.metaInfoLabel];
    
    return self;
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

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent {
    _localMediaContent = localMediaContent;
    NSString* meta = [NSString stringWithFormat:@"Name: %@\nType: %@\nLength: %@\nDownloaded: %i", self.localMediaContent.mediaContent.name, self.localMediaContent.mediaContent.contentType, self.localMediaContent.mediaContent.length, [localMediaContent isDownloaded]];
    self.metaInfoLabel.text = meta;
}

@end
