//
//  OrderItemView.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "FileListItemView.h"

@interface FileListItemView()

@property(strong, nonatomic) UIImageView* iconView;
@property(strong, nonatomic) UIImageView* iconLike;
@property(strong, nonatomic) FitLabel* label;

@end


@implementation FileListItemView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(36, 0, 32, 32)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    self.iconLike = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    self.iconLike.contentMode = UIViewContentModeScaleAspectFit;
    self.iconLike.userInteractionEnabled = YES;
    [self.iconLike addTarget:self action:@selector(likeUnlike)];
    [self addSubview:self.iconLike];
    
    self.label = [[FitLabel alloc] init];
    self.label.x = 100;
    [self addSubview:self.label];

    return self;
}

-(void)likeUnlike {
    NSLog(@"likeUnlike");
    if(self.courseDetails.liked.intValue == 0) {
        [CourseApi CourseAPI_Like:self.courseDetails.course.id onSuccess:^(CourseInfo *resp) {
            self.courseDetails.liked = [NSNumber numberWithInt:1];
            self.iconLike.image = [UIImage imageNamed:@"like-color-full"];
        } onError:^(APIError *err) {
            
        }];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label vcenterInParent];
    [self.iconView vcenterInParent];
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    _courseDetails = courseDetails;
    self.label.text = courseDetails.course.title;
    if(courseDetails.course.isDir.intValue)
        self.iconView.image = [UIImage imageNamed:@"folder-128"];
    else
        self.iconView.image = [UIImage imageNamed:@"file-128"];
    
    [self.iconLike vcenterInParent];
    if(courseDetails.liked.intValue) {
        self.iconLike.image = [UIImage imageNamed:@"like-color-full"];
    }
    else {
        self.iconLike.image = [UIImage imageNamed:@"like-color"];
    }
}
@end
