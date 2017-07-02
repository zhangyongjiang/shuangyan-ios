//
//  OrderItemTableViewCell.m
//
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "OnlineFileListTableViewCell.h"

@interface OnlineFileListTableViewCell()

@property(strong,nonatomic)OnlineFileListItemView* view;

@end

@implementation OnlineFileListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.view = [[OnlineFileListItemView alloc] initWithFrame:CGRectMake(0, 0, [UIView screenWidth], OnlineFileListViewHeight)];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.view];
    self.clipsToBounds = YES;
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails {
    [self.view setCourseDetails:courseDetails];
}
@end
