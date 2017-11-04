//
//  SearchBox.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 11/4/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "SearchBox.h"

@interface SearchBox() <UITextFieldDelegate>
@end

@implementation SearchBox

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.btnSearch = [UIButton new];
    [self.btnSearch setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [self addSubview:self.btnSearch];
    [self.btnSearch autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.btnSearch autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.btnSearch autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.btnSearch autoSetDimension:ALDimensionWidth toSize:40];
    [self.btnSearch addTarget:self action:@selector(btnSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.txtField = [UITextField new];
    [self addSubview:self.txtField];
    [self.txtField autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.txtField autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.txtField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.txtField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.btnSearch];
    
    self.txtField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.txtField.leftViewMode = UITextFieldViewModeAlways;
    self.txtField.placeholder = @"搜索关键词";
    self.txtField.delegate = self;
    self.txtField.returnKeyType = UIReturnKeySearch;

    return self;
}

-(void)btnSearchClicked:(id)sender {
    [self.txtField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSearch object:self.txtField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSearch object:self.txtField.text];
    return YES;
}

@end
