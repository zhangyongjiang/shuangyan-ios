//
//  GalleryCollectionView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 9/2/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "GalleryCollectionView.h"
#import "GalleryCollectionViewCell.h"

#define GALLERYCOLLECTIONVIEWCELLID @"GALLERYCOLLECTIONVIEWCELLID"

@interface GalleryCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic)UICollectionView* collectionView;
@property(strong, nonatomic)UIPageControl* pageControl;
@property(strong, nonatomic)NSMutableArray* mediaContents;
@property(strong, nonatomic)UICollectionViewFlowLayout *layout;

@end

@implementation GalleryCollectionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.mediaContents = [NSMutableArray new];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.layout setItemSize:CGSizeMake(self.width, self.height)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
    [self.collectionView registerClass:[GalleryCollectionViewCell class] forCellWithReuseIdentifier:GALLERYCOLLECTIONVIEWCELLID];
    [self addSubview:self.collectionView];
    [self.collectionView autoPinEdgesToSuperviewMargins];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    return self;
}

-(void)setCourseDetails:(CourseDetails *)courseDetails
{
    _courseDetails = courseDetails;
    [self addCourseDetails:courseDetails];
    [self.collectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GalleryCollectionViewCell* gallerycell = cell;
}

-(void)addCourseDetails:(CourseDetails*)courseDetails
{
    [self.mediaContents addObject:courseDetails];
    for (CourseDetails* child in courseDetails.items) {
        [self addCourseDetails:child];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.mediaContents.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GALLERYCOLLECTIONVIEWCELLID forIndexPath:indexPath];
    CourseDetails* mc = [self.mediaContents objectAtIndex:indexPath.section];
    cell.courseDetails = mc;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(void)layoutSubviews
{
    CGSize size = self.layout.itemSize;
    if((int)size.width != (int)self.width) {
        self.layout.itemSize = CGSizeMake(self.width, self.height);
    }
}

@end
