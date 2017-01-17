//
//  MediaAttachmentDataSource.m
//  Chenglong
//
//  Created by wangyaochang on 2017/1/16.
//  Copyright © 2017年 Chenglong. All rights reserved.
//

#import "MediaAttachmentDataSource.h"

#import "MediaAttachment.h"

#import "MediaAttachmentCollectionViewCell.h"


@implementation MediaAttachmentDataSource

#pragma mark - init

- (id)initWithOwner:(id)owner {
    self = [super init];
    
    _parentViewController = owner;
    
    MediaAttachment *addAttachment = [[MediaAttachment alloc] initWithDefaultType:FileMediaTypeAdd];
    _attachments = [[NSMutableArray alloc] initWithObjects:addAttachment, nil];
    
    _photoMaxNum = 9;//默认为9
    
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(_photoMaxNum-1, self.attachments.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaAttachment *attachment = [self.attachments objectAtIndex:indexPath.row];
    
    MediaAttachmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MediaAttachmentCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    if (cell != nil) {
        [cell setAttachment:attachment];
        
        if (attachment.type == FileMediaTypeAdd) {
            cell.isDefaultAttachmentOption = YES;
        } else {
            cell.isDefaultAttachmentOption = NO;
        }
        [cell.deleteButton bk_addEventHandler:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JournalAttachmentDeleteButtonTapped" object:attachment];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - Attachment Methods




@end
