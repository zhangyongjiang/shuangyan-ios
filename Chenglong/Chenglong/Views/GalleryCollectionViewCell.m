//
//  GalleryCollectionViewCell.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 9/2/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "GalleryCollectionViewCell.h"
#import "MediaContentViewContailer.h"

@interface GalleryCollectionViewCell()

@property(strong, nonatomic) MediaContentViewContailer* mediaContentView;

@end

@implementation GalleryCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.mediaContentView = [[MediaContentViewContailer alloc] initWithFrame:frame];
    [self addSubview:self.mediaContentView];
    [self.mediaContentView autoPinEdgesToSuperviewMargins];
    
    return self;
}

-(void)setLocalMediaContent:(LocalMediaContent *)localMediaContent
{
    _localMediaContent = localMediaContent;
    self.mediaContentView.localMediaContent = localMediaContent;
}
@end
