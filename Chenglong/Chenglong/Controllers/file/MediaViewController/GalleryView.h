//
//  GalleryView.h
//
//
//  Created by Kevin Zhang on 1/1/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryView : UIView <UIScrollViewDelegate>

@property(strong,nonatomic)UIColor* tintColor;
@property(assign,nonatomic)UIViewContentMode contentMode;
@property(assign, nonatomic)int repeat;
@property(assign, nonatomic)int autoplay;
@property(strong, nonatomic)UIButton* btnPrev;
@property(strong, nonatomic)UIButton* btnNext;
@property(strong, nonatomic)UIButton* btnRepeat;
@property(strong, nonatomic)FitLabel* labelProgress;
@property(strong, nonatomic)CourseDetails* courseDetails;

-(id)initWithFrame:(CGRect)frame;
-(void)showPage:(int)pageNumber;
-(void)play;
-(void)stop;
-(int)toggleRepeat;

@end
