//
//  OrderItemTableViewCell.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "CourseListTableViewCell.h"

@interface CourseListTableViewCell()

@property(strong,nonatomic)CourseListItemView* view;

@end

@implementation CourseListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.view = [[CourseListItemView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], CourseListViewHeight)];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.view];
    [self.view autoPinEdgesToSuperviewMargins];
    self.clipsToBounds = YES;

    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    self.textLabel.text = courseDetails.course.title;
    //[self.view setCourseDetails:courseDetails];
}
@end
