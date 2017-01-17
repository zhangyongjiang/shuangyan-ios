//
//  CreatFileTypeView.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "CreatFileTypeView.h"
#import "CreatFileTypeCell.h"

@interface CreatFileTypeView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@end

@implementation CreatFileTypeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collection registerNib:[UINib nibWithNibName:@"CreatFileTypeCell" bundle:nil] forCellWithReuseIdentifier:@"CreatFileTypeCell"];
    _titleArr = @[@"图片",@"视频",@"音乐"];
    _imgArr = @[@"file_creat_photo",@"file_creat_takephoto",@"file_creat_music"];
}


#pragma mark - UICollectionView datasource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreatFileTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreatFileTypeCell" forIndexPath:indexPath];
    cell.lbTitle.text = _titleArr[indexPath.item];
    cell.imgType.image = [UIImage imageNamed:_imgArr[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chooseTypeBlock) {
        self.chooseTypeBlock(indexPath.item);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgWidth = SCREEN_BOUNDS_SIZE_WIDTH / 3;
    return CGSizeMake(imgWidth, self.height);
}

@end
