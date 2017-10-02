//
//  CourseTreeViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseTreePage.h"

@interface CourseTreeViewController : BaseViewController

@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* selectedCourseId;
@property (strong, nonatomic) CourseTreePage* page;

-(id)initWithUserId:(NSString*)userId andCourseId:(NSString*)courseId;

@end
