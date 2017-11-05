//
//  MediaConentView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/10/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaConentView.h"
#import "MediaContentImageView.h"
#import "MediaContentVideoView.h"
#import "MediaContentPdfView.h"
#import "MediaContentTextView.h"
#import "PureLayout.h"
#import "LocalMediaContentShard.h"
#import "LocalMediaContentShardGroup.h"
#import "PlayerControlView.h"
#import "MediaPlayer.h"

@interface MediaConentView()

@end


@implementation MediaConentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];

    return self;
}

-(void)play {
}

+(MediaConentView*) createViewForCourseDetails:(CourseDetails *)courseDetails {
    MediaConentView* view;
    if([courseDetails.course isImage]) {
        view = [[MediaContentImageView alloc] init];
    }
    else if([courseDetails.course isAudio]) {
//        view = [[MediaContentAudioView alloc] init];
        view = [[MediaContentVideoView alloc] init];
    }
    else if([courseDetails.course isVideo]) {
        view = [[MediaContentVideoView alloc] init];
    }
    else if([courseDetails.course isPdf]) {
        view = [[MediaContentPdfView alloc] init];
    }
    else if([courseDetails.course isText]) {
        view = [[MediaContentTextView alloc] init];
    }
    else
        return nil;
    view.width = [UIView screenWidth];
    view.height = [UIView screenWidth];
    view.courseDetails = courseDetails;
    
    view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    view.layer.borderWidth = 1;
//    view.layer.borderColor = [UIColor colorFromRGB:0xeeeeee].CGColor;
    
    return view;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
}

-(void)stop{}

-(void)showCoverImage
{
}
@end
