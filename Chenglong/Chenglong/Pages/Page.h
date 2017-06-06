//
//  Page.h
//
//
//  Created by Kevin Zhang on 11/16/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import "BaseView.h"

@interface Page : BaseView

-(void)setEmptyPageText:(NSString*)text;
-(void)setEmptyPageView:(UIView*)view;
-(void)reload;
-(void)beginRefresh;
-(void)endRefresh;

@end




