//
//  BaseViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *navBgView;
@property (nonatomic, strong) UIView *shadowLineView;

//显示错误信息等
- (void)alertShowWithMsg:(NSString *)msg;
-(void)loadCameraOrPhotoLibraryWithDelegate:(id)delegate allowEditing:(BOOL)allowEditing;

-(void)addTopRightMenu:(NSArray*)menuItems;
-(void)topRightMenuItemClicked:(NSString*)cmd;
-(BOOL)hasNextPage:(int)pageSize current:(int)currentPage currentItems:(NSInteger)currentItems;

@end
