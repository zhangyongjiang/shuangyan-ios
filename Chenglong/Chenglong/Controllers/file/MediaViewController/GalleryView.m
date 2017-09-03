//
//  GalleryView.m
//
//
//  Created by Kevin Zhang on 1/1/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "GalleryView.h"
#import "MediaContentViewContailer.h"

@interface GalleryView()
{
    int currentPlay;
}

@property(strong,nonatomic)NSMutableArray* mediaViews;
@property(strong, nonatomic)MediaContentViewContailer* contentView;

@end

@implementation GalleryView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.mediaViews = [[NSMutableArray alloc] init];
    
    currentPlay = -1;
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView = [[MediaContentViewContailer alloc]initWithFrame:frame];
    [self addSubview:self.contentView];
    [self.contentView autoPinEdgesToSuperviewMargins];
    
    return self;
}

-(void)playEnd:(NSNotification*)noti
{
    currentPlay++;
    if(currentPlay >= self.mediaViews.count)
        currentPlay = 0;

    LocalMediaContent* mc = [self.mediaViews objectAtIndex:currentPlay];
    self.contentView.localMediaContent = mc;
    [self.contentView play];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.contentView removeFromSuperview];
}

-(void)showCourseDetails:(CourseDetails *)courseDetails
{
    [self showText:courseDetails.course.content andMediaContent:courseDetails.course.resources];
    for (CourseDetails* child in courseDetails.items) {
        [self showCourseDetails:child];
    }
}

-(void)showText:(NSString *)content andMediaContent:(NSArray *)mediaContents
{
    int xOffset = self.mediaViews.count * self.width;
    content = [content trim];
    if(content.length>0) {
        LocalMediaContent* mc = [LocalMediaContent new];
        mc.contentType = @"text";
        mc.content = content;
        [self.mediaViews addObject:mc];
        xOffset += self.width;
    }

    if(mediaContents)
        [self.mediaViews addObjectsFromArray:mediaContents];
    
    if(self.mediaViews.count > 0 ) {
        if(currentPlay == -1) {
            [self showPage:0];
        }
    }
}

-(void)showPage:(int)index {
    currentPlay = index;
    LocalMediaContent* mc = [self.mediaViews objectAtIndex:index];
    self.contentView.localMediaContent = mc;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(void)play
{
    if(self.mediaViews.count == 0)
        return;
    [self showPage:currentPlay];
    
    [self.contentView play];
}

-(void)stop
{
    [self.contentView stop];
}

-(BOOL)next
{
    if(currentPlay >= self.mediaViews.count-1) {
        return NO;
    }
    currentPlay++;
    [self showPage:currentPlay];
    return YES;
}

-(BOOL)previous
{
    if(currentPlay <=0 ) {
        return NO;
    }
    currentPlay--;
    [self showPage:currentPlay];
    return YES;
}
@end
