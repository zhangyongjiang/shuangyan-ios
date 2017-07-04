//
//  OnlineFileListViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "OnlineFileListViewController.h"
#import "ObjectMapper.h"
#import "CreateFileViewController.h"
#import "CoursePickerViewController.h"
#import "OnlineFileDetailsViewController.h"
#import "UserFileListViewController.h"

@interface OnlineFileListViewController () <CousePickerDelegate>

@property(strong, nonatomic) OnlineFileListPage* page;
@property(strong, nonatomic) CoursePickerViewController* coursePickerViewController;

@end

@implementation OnlineFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];
    [self addTopRightMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelected:) name:NotificationUserSelected object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseSelected:) name:NotificationCourseSelected object:NULL];
}

-(void)addTopRightMenu {
    self.menuItems = [[NSMutableArray alloc] init];
    NSMutableArray* arr = self.menuItems;
    [arr addObject:[[MenuItem alloc] initWithText:@"上传者" andImgName:@"file_search_age_icon"] ];
    [arr addObject:[[MenuItem alloc] initWithText:@"拷贝到..." andImgName:@"file_item_newFile_icon"]] ;
    
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd hasPrefix:@"拷贝"]) {
        self.coursePickerViewController = [[CoursePickerViewController alloc] init];
        [self.navigationController pushViewController:self.coursePickerViewController animated:YES];
        self.coursePickerViewController.delegate = self;
    }
    else if([cmd isEqualToString:@"上传者"]){
        NSString* userId = self.page.courseDetailsWithParent.courseDetails.user.id;
        UserFileListViewController* c = [UserFileListViewController new];
        c.userId = userId;
        c.user = self.page.courseDetailsWithParent.courseDetails.user;
        [self.navigationController pushViewController:c animated:YES];
    }
}

-(void)createPage {
    self.page = [[OnlineFileListPage alloc] initWithFrame:self.view.bounds];
    self.page.height -= 64;
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_GetCourseDetails:self.courseId onSuccess:^(CourseDetailsWithParent *resp) {
        [self.page setCourseDetailsWithParent:resp];
        self.title = resp.courseDetails.course.title;
        User* user = [Global loggedInUser];
        if(resp.courseDetails.items.count == 0 || [resp.courseDetails.user.id isEqualToString:user.id])
            [self enableMenuItem:@"拷贝" enable:NO];
        else {
            
        }
    } onError:^(APIError *err) {
    }];
}

-(void)selectCourse:(NSString*)selected {
    if(selected == NULL)
        selected = @"~";
    [self.navigationController popToViewController:self animated:YES];
    [CourseApi CourseAPI_Copy:self.courseId dstId:selected onSuccess:^(Course *resp) {
        [self alertShowWithMsg:@"Done"];
    } onError:^(APIError *err) {
        [self alertShowWithMsg:@"Error"];
    }];
}

-(void)userSelected:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        NSString* userId = [noti.userInfo objectForKey:@"userId"];
        UserFileListViewController* c = [UserFileListViewController new];
        c.userId = userId;
        [self.navigationController pushViewController:c animated:YES];
    }
}

-(void)courseSelected:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        Course* course = [noti.userInfo objectForKey:@"course"];
        if([course.id isEqualToString:self.courseId])
            return;
        
        if(course.isDir.intValue == 1) {
            OnlineFileListViewController* c = [[OnlineFileListViewController alloc] init];
            c.courseId = course.id;
            [self.navigationController pushViewController:c animated:YES];
        }
        else {
            OnlineFileDetailsViewController* c = [[OnlineFileDetailsViewController alloc] init];
        }
    }
}


@end
