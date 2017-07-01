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

@interface OnlineFileListViewController () <CousePickerDelegate>

@property(strong, nonatomic) OnlineFileListPage* page;
@property(strong, nonatomic) CoursePickerViewController* coursePickerViewController;

@end

@implementation OnlineFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPage];
    [self addTopRightMenu];
}

-(void)addTopRightMenu {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:[[MenuItem alloc] initWithText:@"拷贝" andImgName:@"file_item_newFile_icon"]] ;
    
    [arr addObject:[[MenuItem alloc] initWithText:@"新文件夹" andImgName:@"file_item_newfolder_icon"] ];
    
    if(self.courseId)
        [arr addObject:[[MenuItem alloc] initWithText:@"删除" andImgName:@"file_item_remove_icon"]];
    
    [arr addObject:[[MenuItem alloc] initWithText:@"播放" andImgName:@"file_item_play_icon"] ];
    
    if(self.courseId != NULL)
        [arr addObject:[[MenuItem alloc] initWithText:@"改名" andImgName:@"file_item_edit_icon"]];
    
    [super addTopRightMenu:arr];
}

-(void)topRightMenuItemClicked:(NSString *)cmd {
    [super topRightMenuItemClicked:cmd];
    if ([cmd isEqualToString:@"拷贝"]) {
        self.coursePickerViewController = [[CoursePickerViewController alloc] init];
        [self.navigationController pushViewController:self.coursePickerViewController animated:YES];
        self.coursePickerViewController.delegate = self;
    }
    else if([cmd isEqualToString:@"新文件夹"]){
    }
    else if ([cmd isEqualToString:@"改名"]){
    }
    else if ([cmd isEqualToString:@"删除"]) {
    }
    
}

-(void)createPage {
    self.page = [[OnlineFileListPage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.page];
    
    [self refreshPage];
}

-(void)refreshPage {
    [CourseApi CourseAPI_GetCourseDetails:self.courseId onSuccess:^(CourseDetailsWithParent *resp) {
        [self.page setCourseDetailsWithParent:resp];
        self.title = resp.courseDetails.course.title;
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

-(void)cancel {
    [self.navigationController popToViewController:self animated:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelected:) name:NotificationUserSelected object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseSelected:) name:NotificationCourseSelected object:NULL];
}

-(void)userSelected:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        NSString* userId = [noti.userInfo objectForKey:@"userId"];
        NSLog(@"user selected %@", userId);
    }
}

-(void)courseSelected:(NSNotification*)noti {
    UIView* subview = noti.object;
    if([subview isSameViewOrChildOf:self.view]) {
        NSString* courseId = [noti.userInfo objectForKey:@"courseId"];
        NSLog(@"course selected %@", courseId);
    }
}


@end
