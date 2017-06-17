//
//  OnlineCourseResourceView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/16/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

@interface OnlineCourseResourceView : BaseView <UIScrollViewDelegate>

@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)UIPageControl* pageControl;

@property(strong,nonatomic)NSArray* courseResources;

-(id)initWithFrame:(CGRect)frame;

@end
