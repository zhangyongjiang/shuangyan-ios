//
//  CourseTreeViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/26/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseTreeViewController.h"

@interface CourseTreeViewController ()


@end

@implementation CourseTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height - 108;
    self.page = [[CourseTreePage alloc] initWithFrame:rect];
    if(self.userId == nil || [Global isLoginUser:self.userId]){
        self.title = @"我的文件";
    }
    else {
        self.title = @"用户文件";
    }
    
    [self.page.refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.page];
    self.view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.page autoPinEdgesToSuperviewMargins];
    
    [self showPage];
    [super addTopRightMenu];
}

-(NSMutableArray*)getTopRightMenuItems {
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    CourseDetails* selected = [self.page.treeView itemForSelectedRow];
    if(!selected.course.isDir.boolValue) {
        [menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
    }
    else {
        [menuItems addObject:[[MenuItem alloc] initWithText:@"新文件" andImgName:@"file_item_newFile_icon"]] ;
        [menuItems addObject:[[MenuItem alloc] initWithText:@"新文件夹" andImgName:@"file_item_newfolder_icon"] ];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"移动" andImgName:@"file_item_exchange_icon"]];
        [menuItems addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"]];
    }
    return menuItems;
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    NSLog(@"cmd %@ clicked", cmd);
}

-(void)refreshPage {
    [MyHTTPSessionManager disableCacheForSeconds:3];
    [self showPage];
}

-(void)showPage {
    [CourseApi CourseAPI_ListUserCourseTree:self.userId onSuccess:^(CourseDetails *resp) {
        resp.course = [Course new];
        resp.course.isDir = [NSNumber numberWithInteger:1];
        
        if(self.userId == NULL || [Global isLoginUser:self.userId])
            resp.course.title = [NSString stringWithFormat:@"我的文件"];
        else
            resp.course.title = [NSString stringWithFormat:@"%@的文件", resp.user.name];
        
        CourseDetails* container = [CourseDetails new];
        container.items = [NSMutableArray arrayWithObject:resp];
        self.page.courseDetails = container;
        [self.page.refreshControl endRefreshing];
            [self.page selectCourse:self.selectedCourseId];
    } onError:^(APIError *err) {
        ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        [self.page.refreshControl endRefreshing];
    }];
}

-(BOOL)isSameViewController:(UIViewController*)c
{
    if(![c isKindOfClass:[CourseTreeViewController class]]) {
        return NO;
    }
    CourseTreeViewController* ctc = c;
    if(self.userId == NULL && ctc.userId == NULL)
        return YES;
    if(self.userId != NULL && ctc.userId == NULL) {
        if([Global isLoginUser:self.userId])
            return YES;
        else
            return NO;
    }
    if(self.userId == NULL && ctc.userId != NULL) {
        if([Global isLoginUser:ctc.userId])
            return YES;
        else
            return NO;
    }
    return [self.userId isEqualToString:ctc.userId];
}

@end
