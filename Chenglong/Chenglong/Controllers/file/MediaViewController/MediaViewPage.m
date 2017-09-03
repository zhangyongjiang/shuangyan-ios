//
//  MediaViewPage.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 9/2/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaViewPage.h"

@implementation MediaViewPage

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.galleryView = [[GalleryView alloc] initWithFrame:frame];
    [self addSubview:self.galleryView];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
    btn.backgroundColor = [UIColor colorFromRGB:0xffffff];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btn.height / 4.;
    [self addSubview:btn];
    self.btnClose = btn;

    return self;
}

-(void)setCourseDetails:(CourseDetails*)courseDetails
{
    [self.galleryView showCourseDetails:courseDetails];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.galleryView.frame = self.bounds;
}
@end
