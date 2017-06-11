//
//  FileDetailsViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@interface FileDetailsViewController : BaseViewController

@property(strong, nonatomic) CourseDetails* courseDetails;
@property(strong, nonatomic) NSString* currentDirPath;


@end
