//
//  UserView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/25/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "UserView.h"

@interface UserSummaryView()

@property(strong, nonatomic) UIImageView* imgView;
@property(strong, nonatomic) UILabel* nameView;

@end

@implementation UserSummaryView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [self addSubview:self.imgView];
    
    self.nameView = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right + 15, self.imgView.top, 100, 32)];
    [self addSubview:self.nameView];
    
    return self;
}

-(void)setUser:(User *)user {
    _user = user;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:user.imgPath]];
    self.nameView.text = user.name;
}

@end
