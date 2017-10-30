//
//  MediaConentView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

@interface MediaConentView : BaseView

@property(strong, nonatomic) CourseDetails* courseDetails;

+(MediaConentView*) createViewForCourseDetails:(CourseDetails*)courseDetails;

-(void)stop;
-(void)play;
-(void)showCoverImage;

@end
