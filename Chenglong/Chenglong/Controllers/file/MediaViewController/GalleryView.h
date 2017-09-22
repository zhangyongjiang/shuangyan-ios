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

-(id)initWithFrame:(CGRect)frame;
-(void)showPage:(int)pageNumber;
-(void)play;
-(void)stop;
-(NSInteger)showCourseDetails:(CourseDetails*)courseDetails;
-(BOOL)previous;
-(BOOL)next;
-(int)toggleRepeat;

@end
