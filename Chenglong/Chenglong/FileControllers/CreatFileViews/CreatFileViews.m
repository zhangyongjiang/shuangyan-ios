//
//  CreatFileViews.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "CreatFileViews.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "FilePhotoViews.h"
#import "UIImage+Kaishi.h"
#import "UIImagePickerController+Kaishi.h"

static NSInteger kPhotoMaxNumber = 7;

@interface CreatFileViews ()<UIImagePickerControllerDelegate,UICollectionViewDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

{
    
}

@property (nonatomic, strong) FilePhotoViews *photoViews;
@end

@implementation CreatFileViews

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
        [self addObserver];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
    
    _mediaAttachmentDataSource = nil;
    _mediaPicker=nil;
    
}

- (void)configSubViews
{
    _tfTitle = [[UITextField alloc] initWithFrame:CGRectMake(12, 5, SCREEN_BOUNDS_SIZE_WIDTH-24, 44)];
    _tfTitle.backgroundColor = [UIColor whiteColor];
    _tfTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _tfTitle.font = [UIFont systemFontOfSize:14.f];
    _tfTitle.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    _tfTitle.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:_tfTitle];
    
    _tvContent = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(12, _tfTitle.bottom + 12, SCREEN_BOUNDS_SIZE_WIDTH-24, 130.f)];
    _tvContent.placeholderColor = [UIColor lightGrayColor];
    _tvContent.textColor = [UIColor blackColor];
    _tvContent.font = [UIFont systemFontOfSize:14.f];
    _tvContent.placeholder = @"内容简介";
    [self addSubview:_tvContent];
    
    //年龄视图
    UIView *ageContainView = [[UIView alloc] initWithFrame:CGRectMake(12, _tvContent.bottom + 12, SCREEN_BOUNDS_SIZE_WIDTH-24, 44.f)];
    ageContainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:ageContainView];
    
    UILabel *lbAgeDes = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44.f)];
    lbAgeDes.font = [UIFont systemFontOfSize:14];
    lbAgeDes.textColor = [UIColor colorFromString:@"1a1a1a"];
    lbAgeDes.text = @"年龄段";
    lbAgeDes.textAlignment = NSTextAlignmentCenter;
    [ageContainView addSubview:lbAgeDes];
    
    _tfStartAge = [[UITextField alloc] initWithFrame:CGRectMake(lbAgeDes.right, 7, 50, 30.f)];
    _tfStartAge.font = [UIFont systemFontOfSize:14.f];
    _tfStartAge.textAlignment = NSTextAlignmentCenter;
    _tfStartAge.keyboardType = UIKeyboardTypeNumberPad;
    _tfStartAge.textColor = [UIColor lightGrayColor];
    _tfStartAge.backgroundColor = [UIColor clearColor];
    _tfStartAge.layer.borderColor = [UIColor colorFromString:@"dedede"].CGColor;
    _tfStartAge.layer.borderWidth = 1.f;
    [ageContainView addSubview:_tfStartAge];
    
    UILabel *lbAgeLine = [[UILabel alloc] initWithFrame:CGRectMake(_tfStartAge.right, 0, 30, 44.f)];
    lbAgeLine.font = [UIFont systemFontOfSize:14];
    lbAgeLine.textColor = [UIColor colorFromString:@"dedede"];
    lbAgeLine.text = @"-";
    lbAgeLine.textAlignment = NSTextAlignmentCenter;
    [ageContainView addSubview:lbAgeLine];
    
    _tfEndAge = [[UITextField alloc] initWithFrame:CGRectMake(lbAgeLine.right, 7, 50, 30.f)];
    _tfEndAge.font = [UIFont systemFontOfSize:14.f];
    _tfEndAge.textAlignment = NSTextAlignmentCenter;
    _tfEndAge.textColor = [UIColor lightGrayColor];
    _tfEndAge.backgroundColor = [UIColor clearColor];
    _tfEndAge.layer.borderColor = [UIColor colorFromString:@"dedede"].CGColor;
    _tfEndAge.layer.borderWidth = 1.f;
    [ageContainView addSubview:_tfEndAge];
    
    self.mediaType = FileMediaTypeNone;
    _mediaAttachmentDataSource = [[MediaAttachmentDataSource alloc] initWithOwner:self];
    _mediaAttachmentDataSource.photoMaxNum = kPhotoMaxNumber;
    
    self.mediaPicker = [[UIImagePickerController alloc] init];
    self.mediaPicker.allowsEditing = NO;
    self.mediaPicker.delegate = self;
    
    self.photoViews.frame = CGRectMake(0, ageContainView.bottom + 12, SCREEN_BOUNDS_SIZE_WIDTH, 150.f);
    self.photoViews.collection.delegate = self;
    self.photoViews.collection.dataSource = _mediaAttachmentDataSource;
    [self addSubview:self.photoViews];
    
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDeleteButtonTapped:) name:@"JournalAttachmentDeleteButtonTapped" object:nil];
}

//照片
- (void)takePhoto
{
    self.mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    [self showPhotoActionSheetWithPhoto:YES];
//    [UIImagePickerController showImagePickerOptionsFromViewController:[self getCurrentNavController].topViewController cameraSelected:^(UIViewController* controller) {
//        
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            if (granted) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakSelf.mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    [[weakSelf getCurrentNavController] presentViewController:weakSelf.mediaPicker animated:YES completion:nil];
//                });
//            } else  {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相机功能已关闭"
//                                                                        message:@"请打开设置中的相机选项"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"取消"
//                                                              otherButtonTitles:@"设置",nil];
//                    [alertView show];
//                });
//            }
//        }];
//    } withLibrarySelected:^(UIViewController* controller ) {
//        [weakSelf showPhotoActionSheetWithPhoto:YES];
//    }];
}

//视频
- (void)takeMovie
{
    
}

//音乐
- (void)takeMusic
{
    
}
#pragma mark - 图片删除点击事件
- (void)mediaDeleteButtonTapped:(NSNotification *)noti
{
    MediaAttachment *attachment = noti.object;
    
    __block NSInteger index = 0;
    __block BOOL hasValue = NO;
    [self.mediaAttachmentDataSource.attachments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:attachment]) {
            index = idx;
            hasValue = YES;
            *stop = YES;
        }
    }];
    
    [self.mediaAttachmentDataSource.attachments removeObject:attachment];
    if (hasValue) {
        if (self.mediaAttachmentDataSource.attachments.count >= (kPhotoMaxNumber-1)) {
            [self.photoViews.collection reloadData];
        }else{
            
            [self.photoViews.collection performBatchUpdates:^{
                [self.photoViews.collection deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    if (self.mediaAttachmentDataSource.attachments.count <= 1) {
        self.mediaType = FileMediaTypeNone;
    }
}

#pragma mark - Media Methods

- (void)showPhotoActionSheetWithPhoto:(BOOL)isPhoto {
    
    if (isPhoto) {
        self.imagePicker = nil;
        self.imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:kPhotoMaxNumber - self.mediaAttachmentDataSource.attachments.count delegate:self];
        self.imagePicker.allowPickingVideo = NO;
        [[self getCurrentNavController] presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            self.mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[self getCurrentNavController] presentViewController:self.mediaPicker animated:YES completion:nil];
        }
    }
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaAttachment *attachment = [self.mediaAttachmentDataSource.attachments objectAtIndex:indexPath.item];
    
    if (attachment.type == FileMediaTypeAdd) {
        [self takePhoto];
        
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 12*2 - 10.f*2) / 3;
    return CGSizeMake(width, width);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

#pragma mark - TZImagePickerControllerDelegate Methods

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos {
    
    self.mediaType = FileMediaTypePhoto;
    for (UIImage *photo in photos) {
        MediaAttachment *newAttachment = [[MediaAttachment alloc] init];
        newAttachment.type = FileMediaTypePhoto;
        UIImage* tempImage = [photo fixOrientation];
        tempImage = [tempImage resizeImageToMaxHeight];
        newAttachment.media = UIImageJPEGRepresentation(tempImage, [Config shared].defaultImageQuality);
        newAttachment.coverPhoto = photo;
        [self.mediaAttachmentDataSource.attachments insertObject:newAttachment atIndex:self.mediaAttachmentDataSource.attachments.count - 1];
    }
    
    if (photos.count > 0) {
        [self.photoViews.collection reloadData];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - setter getter
- (CreatFileTypeView *)chooseTypeView
{
    if (_chooseTypeView == nil) {
        WeakSelf(weakSelf)
        _chooseTypeView = [CreatFileTypeView loadFromNib];
        _chooseTypeView.chooseTypeBlock = ^(NSInteger index){
            if (index == 0) {
                [weakSelf takePhoto];
            }else if (index == 1){
                [weakSelf takeMovie];
            }else if (index == 2){
                [weakSelf takeMusic];
            }
        };
    }
    return _chooseTypeView;
}

- (FilePhotoViews *)photoViews
{
    if (_photoViews == nil) {
        _photoViews = [FilePhotoViews loadFromNib];
        _photoViews.collection.delegate = self;
        _photoViews.collection.dataSource = self.mediaAttachmentDataSource;
        [_photoViews.collection registerClass:NSClassFromString(@"MediaAttachmentCollectionViewCell") forCellWithReuseIdentifier:@"AttachmentCell"];
    }
    return _photoViews;
}

@end
