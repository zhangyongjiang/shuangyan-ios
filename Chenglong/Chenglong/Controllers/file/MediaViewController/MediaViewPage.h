//
//  MediaViewPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 9/2/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Page.h"
#import "GalleryView.h"

@interface MediaViewPage : Page

@property(strong, nonatomic)CourseDetails* courseDetails;
@property(strong, nonatomic)GalleryView* galleryView;
@property(strong, nonatomic)UIButton* btnClose;
@property(strong, nonatomic)UIButton* btnPrev;
@property(strong, nonatomic)UIButton* btnNext;
@property(strong, nonatomic)UIButton* btnRepeat;


@end
