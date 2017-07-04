//
//  OrderItemTableViewCell.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "UserFileListTableViewCell.h"

@interface UserFileListTableViewCell()

@property(strong,nonatomic)UserFileListItemView* view;

@end

@implementation UserFileListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.view = [[UserFileListItemView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], UserFileListViewHeight)];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.view];
    self.clipsToBounds = YES;
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    [self.view setCourseDetails:courseDetails];
}
@end
