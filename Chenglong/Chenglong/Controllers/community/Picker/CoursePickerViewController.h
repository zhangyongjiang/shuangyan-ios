//
//  CoursePickerViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/30/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@protocol CousePickerDelegate <NSObject>

@optional
-(void)selectCourse:(NSString*)courseId;

@end

@interface CoursePickerViewController : BaseViewController

@property(strong, nonatomic) NSString* courseId;
@property(weak, nonatomic) id<CousePickerDelegate> delegate;

@end
