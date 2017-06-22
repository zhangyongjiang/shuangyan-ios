//
//  ProfileViewController.m
//  Chenglong
//
//  Created by wangyaochang on 2016/12/26.
//  Copyright © 2016年 Chenglong. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileUnitCell.h"
#import "ProfileHeaderCell.h"
#import "WebViewController.h"
#import "ResetPwdViewController.h"
#import <Photos/Photos.h>

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *profileTableView;
@property (nonatomic, strong) NSDictionary *titlesArr;
@property (nonatomic, strong) NSDictionary *imgsArr;
@property (nonatomic, strong) ProfileHeaderCell* headerCell;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[[UIImage imageNamed:@"tab_btn_me_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_btn_me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor kaishiColor:UIColorTypeBackgroundColor];
    
    self.titlesArr = @{@"0":@[@"我的头像"],@"1":@[@"修改密码",@"邀请朋友"],@"2":@[@"消息",@"消费和充值"],@"3":@[@"联系爸爸早教",@"关于爸爸早教"]};
    self.imgsArr = @{@"0":@[@""],@"1":@[@"profile_fixpwd_icon",@"profile_friend_icon"],@"2":@[@"profile_msg_icon",@"profile_pay_icon"],@"3":@[@"profile_phone_icon",@"profile_info_icon"]};
    
    [self configSubViews];
    
    [self addobser];
}

- (void)updateViewConstraints
{
    [_profileTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSubViews
{
    _profileTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_profileTableView setBackgroundColor:[UIColor clearColor]];
    [_profileTableView setSeparatorColor:[UIColor kaishiColor:UIColorTypeTableSeparateColor]];
    _profileTableView.delegate = self;
    _profileTableView.dataSource = self;
    [self.view addSubview:_profileTableView];
    
    [_profileTableView registerNib:[UINib nibWithNibName:@"ProfileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProfileHeaderCell"];
    [_profileTableView registerNib:[UINib nibWithNibName:@"ProfileUnitCell" bundle:nil] forCellReuseIdentifier:@"ProfileUnitCell"];
    
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor kaishiColor:UIColorTypeThemeSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_BOUNDS_SIZE_WIDTH/2-100, 30, 200, 45);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE_WIDTH, 105)];
    footView.backgroundColor = [UIColor clearColor];
    [footView addSubview:btn];
    
    _profileTableView.tableFooterView = footView;
    
}

- (void)loginOut:(UIButton *)btn
{
    AppDelegate *app = kAppDelegate;
    [app logout];
}

- (void)addobser
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMeInfoSuccess:) name:kGetMeInfoSuccessNotificationKey object:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titlesArr.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [_titlesArr objectForKey:@(section).stringValue];
    return arr.count;
}

-(void)changeAvatar {
    [self loadCameraOrPhotoLibraryWithDelegate:self allowEditing:NO];
}

-(void)changeName {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"";
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionCancel];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        if ([NSString isEmpty:tf.text]) {
            [self presentFailureTips:@"名字不能为空"];
            return;
        }
        User *request = [User new];
        request.name = tf.text;
        [SVProgressHUD showWithStatus:@"修改中"];
        [UserApi UserAPI_Update:request onSuccess:^(User *resp) {
            [SVProgressHUD dismiss];
            weakSelf.headerCell.lbName.text = resp.name;
        } onError:^(APIError *err) {
            [SVProgressHUD dismiss];
            ALERT_VIEW_WITH_TITLE(err.errorCode, err.errorMsg);
        }];
    }];
    [alert addAction:actionSure];
    [[self getCurrentNavController] presentViewController:alert animated:YES completion:^{
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProfileUnitCell";
    if (indexPath.section == 0) {
        cellIdentifier = @"ProfileHeaderCell";
        ProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.data = [Global loggedInUser];
        if(self.headerCell == nil) {
            self.headerCell = cell;
            [self.headerCell.imgHeader addTarget:self action:@selector(changeAvatar)];
            [self.headerCell.lbName addTarget:self action:@selector(changeName)];
        }
        return cell;
    }else{
        
        cellIdentifier = @"ProfileUnitCell";
        ProfileUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *titleArr = [_titlesArr objectForKey:@(indexPath.section).stringValue];
        NSArray *imgArr = [_imgsArr objectForKey:@(indexPath.section).stringValue];
        NSString *title = [titleArr objectAtIndex:indexPath.row];
        NSString *image = [imgArr objectAtIndex:indexPath.row];
        
        if ([cell respondsToSelector:@selector(layoutMargins)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        cell.lbTitle.text = title;
        cell.imgIcon.image = [UIImage imageNamed:image];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}
#pragma mark - UITableView Methods
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.f;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
       
        
    }else if (indexPath.section == 1){
        
        if ((long)indexPath.row == 0) {
            ResetPwdViewController *resetCon = [ResetPwdViewController loadFromNib];
            [self.navigationController pushViewController:resetCon animated:YES];
        } else if ((long)indexPath.row == 1) {
            
            
        }else if ((long)indexPath.row == 2) {
            
        }
        
    }else if (indexPath.section == 2){
        
       
        if ((long)indexPath.row == 0) {
            
            
            
        } else if ((long)indexPath.row == 1) {
            
            
        }else if ((long)indexPath.row == 2) {
            
        }
        
    }
    else if (indexPath.section == 3){
        if ((long)indexPath.row == 0) {
            NSString* url = @"http://www.babazaojiao.com/?page_id=48";
            WebViewController* c = [[WebViewController alloc] initWithUrl:url andTitle:@"联系我们"];
            [self.navigationController pushViewController:c animated:YES];
        } else if ((long)indexPath.row == 1) {
            NSString* url = @"http://www.babazaojiao.com/?page_id=49";
            WebViewController* c = [[WebViewController alloc] initWithUrl:url andTitle:@"关于我们"];
            [self.navigationController pushViewController:c animated:YES];
        }else if ((long)indexPath.row == 2) {
        }
    }
}

#pragma mark - 通知

- (void)getMeInfoSuccess:(NSNotification *)noti
{
    [self.profileTableView reloadIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil];
    NSString *filename = [[result firstObject] filename];
    NSLog(@"filename %@", filename);
    if(!selectedImage)
        selectedImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageData, @"file", nil];
    [dict setObject:filename forKey:@"filename"];
    [UserApi UserAPI_UploadUserImage:dict onSuccess:^(MediaContent *resp) {
        NSLog(@"avatar changed");
    } onError:^(APIError *err) {
        NSLog(@"avatar not changed %@", err);
    } progress:^(NSProgress *progress) {
        NSLog(@"progress %@", progress);
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
