//
//  OnlineCourseResourceView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/16/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineCourseResourceView.h"

@interface OnlineCourseResourceView()

@property(strong,nonatomic)NSMutableArray* imgViews;

@end

@implementation OnlineCourseResourceView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 1;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor blueColor] CGColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollView];
    self.scrollView.pagingEnabled = true;
    self.scrollView.scrollsToTop = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height*0.8, frame.size.width, 50*[UIView scale])];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorFromString:@"nsred"];
    
    [self addSubview:self.pageControl];
    
    return self;
}

-(void)setCourseResources:(NSArray *)courseResources {
    _courseResources = courseResources;
    self.scrollView.contentSize = CGSizeMake(self.width * courseResources.count, self.height);
    for (UIView* imgView in self.imgViews) {
        [imgView removeFromSuperview];
    }
    self.imgViews = [[NSMutableArray alloc] init];
    for (int i=0; i<courseResources.count; i++) {
        CGFloat x = i * self.width;
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.width, self.height)];
        imgView.clipsToBounds = YES;
        [self.imgViews addObject:imgView];
        [self.scrollView addSubview:imgView];
        [imgView addTarget:self action:@selector(imgClicked:)];
        MediaContent* mc = [courseResources objectAtIndex:i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:mc.url]];
    }
    [self showPage:0];
    
    self.pageControl.numberOfPages = courseResources.count;
    [self bringSubviewToFront:self.pageControl];
    if (courseResources.count<2) {
        self.pageControl.hidden = YES;
    }
}

-(void)imgClicked:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView* view = gestureRecognizer.view;
//    ImageViewController* controller = [[ImageViewController alloc] init];
//    controller.image = view.image;
//    [[NSNotificationCenter defaultCenter] presentControllerNotification:controller fromView:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // disable vertical scroll
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self showPage:page];
}

-(void)showPage:(int)index {
    if (index<0 || index >= self.courseResources.count) {
        return;
    }
    self.pageControl.currentPage = index;
}
@end
