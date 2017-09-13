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

@property(strong,nonatomic)NSMutableArray* mediaContents;
@property(strong, nonatomic)MediaContentViewContailer* containerView;

@end

@implementation GalleryView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.mediaContents = [[NSMutableArray alloc] init];
    
    currentPlay = -1;
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDownloadedNoti:) name:NotificationDownloadCompleted object:nil];
    
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.containerView = [[MediaContentViewContailer alloc]initWithFrame:frame];
    [self addSubview:self.containerView];
    [self.containerView autoPinEdgesToSuperviewMargins];
    
    self.repeat = RepeatAll;
    
    return self;
}

-(LocalMediaContent*)currentMediaContent
{
    if(currentPlay!=-1) {
        return [self.mediaContents objectAtIndex:currentPlay];
    }
    return NULL;
}

-(void)playEnd:(NSNotification*)noti
{
    if(self.repeat == RepeatAll) {
        BOOL hasNext = [self next];
        if(hasNext)
            [self play];
    }
    else if(self.repeat == RepeatOne) {
        [self play];
    }
    else {
        
    }
}

-(void)contentDownloadedNoti:(NSNotification*)noti
{
    LocalMediaContent* mc = noti.object;
    // can we start to download next play item ???
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
}

-(NSInteger)showCourseDetails:(CourseDetails *)courseDetails
{
    [self showText:courseDetails.course.content andMediaContent:courseDetails.course.resources];
    for (CourseDetails* child in courseDetails.items) {
        [self showCourseDetails:child];
    }
    return self.mediaContents.count;
}

-(void)showText:(NSString *)content andMediaContent:(NSArray *)mediaContents
{
    int xOffset = self.mediaContents.count * self.width;
    content = [content trim];
    if(content.length>0) {
        LocalMediaContent* mc = [LocalMediaContent new];
        mc.contentType = @"text";
        mc.content = content;
        [self.mediaContents addObject:mc];
        xOffset += self.width;
    }

    if(mediaContents)
        [self.mediaContents addObjectsFromArray:mediaContents];
    
    if(self.mediaContents.count > 0 ) {
        if(currentPlay == -1) {
            [self showPage:0];
        }
    }
}

-(void)showPage:(int)index {
    currentPlay = index;
    LocalMediaContent* mc = [self.mediaContents objectAtIndex:index];
    self.containerView.localMediaContent = mc;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(void)play
{
    if(self.mediaContents.count == 0)
        return;
    [self showPage:currentPlay];
    
    [self.containerView play];
}

-(void)stop
{
    [self.containerView stop];
}

-(BOOL)next
{
    if(self.mediaContents.count<2)
        return NO;
    currentPlay++;
    if(currentPlay >= self.mediaContents.count) {
        currentPlay = 0;
    }
    [self showPage:currentPlay];
    return YES;
}

-(BOOL)previous
{
    if(self.mediaContents.count<2)
        return NO;
    currentPlay--;
    if(currentPlay <0 ) {
        currentPlay = self.mediaContents.count-1;
    }
    [self showPage:currentPlay];
    return YES;
}
@end
