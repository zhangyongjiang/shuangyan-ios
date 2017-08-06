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
@property (strong, nonatomic) NSMutableArray* menuItems;

//显示错误信息等
- (void)alertShowWithMsg:(NSString *)msg;
-(void)loadCameraOrPhotoLibraryWithDelegate:(id)delegate allowEditing:(BOOL)allowEditing;

-(void)addTopRightMenu:(NSArray*)menuItems;
-(void)topRightMenuItemClicked:(NSString*)cmd;
-(void)popMenu;
-(void)enableMenuItem:(NSString*)name enable:(BOOL)enable;

-(BOOL)hasNextPage:(int)pageSize current:(int)currentPage currentItems:(NSInteger)currentItems;

-(UIBarButtonItem*)addNavRightButton:(NSString*)text target:(id)target action:(SEL)action;
-(UIBarButtonItem*)addNavRightImgButton:(UIImage*)img target:(id)target action:(SEL)action;
-(UIBarButtonItem*)addNavRightIconButton:(UIBarButtonSystemItem)sysItem target:(id)target action:(SEL)action;
-(void)removeNavRightButton;

-(BOOL)isSameViewController:(UIViewController*)c;

@end
