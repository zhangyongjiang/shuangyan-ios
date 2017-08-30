//
//  GalleryView.m
//
//
//  Created by Kevin Zhang on 1/1/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

#import "GalleryView.h"
#import "MediaConentView.h"
#import "MediaContentAudioView.h"
#import "MediaContentVideoView.h"
#import "MediaContentTextView.h"

@interface GalleryView()
{
    int currentPlay;
    NSTimer* timer;
}

@property(strong,nonatomic)NSMutableArray* mediaViews;

@end

@implementation GalleryView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    currentPlay = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.contentMode = UIViewContentModeScaleAspectFill;

    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    self.scrollView.pagingEnabled = true;
    self.scrollView.scrollsToTop = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height*0.90, frame.size.width, 50*[UIView scale])];
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorFromString:@"nsred"];

    [self addSubview:self.pageControl];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    return self;
}

-(void)dealloc
{
    for(UIView* view in self.mediaViews) {
        [view removeFromSuperview];
    }
    
    [timer invalidate];
    timer = nil;
}

-(void)showText:(NSString *)content andMediaContent:(NSArray *)mediaContents
{
    for (UIView* view in self.mediaViews) {
        [view removeFromSuperview];
    }
    self.mediaViews = [[NSMutableArray alloc] init];
    
    int xOffset = 0;
    content = [content trim];
    if(content.length>0) {
        xOffset = self.width;
        MediaContentTextView* view = [[MediaContentTextView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        view.text = content;
        [self.mediaViews addObject:view];
        [self.scrollView addSubview:view];
    }
    
    for (int i=0; i<mediaContents.count; i++) {
        CGFloat x = i * self.width + xOffset;
        MediaConentView* view = [MediaConentView createViewForMediaContent:[mediaContents objectAtIndex:i]];
        view.frame = CGRectMake(x, 0, self.width, self.height);
        view.clipsToBounds = YES;
        [self.mediaViews addObject:view];
        [self.scrollView addSubview:view];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.width * self.mediaViews.count, self.height);

    [self showPage:0];
    
    self.pageControl.numberOfPages = self.mediaViews.count;
    [self bringSubviewToFront:self.pageControl];
    if (self.mediaViews.count<2) {
        self.pageControl.hidden = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // prevent to scroll to the first page when changing orientation
    static int previousWidth = 0;
    static BOOL lock = NO;
    if(lock)
        return;
    
    if(currentPlay>0 && previousWidth != (int)scrollView.width) {
        [self showPage:currentPlay];
        lock = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC),dispatch_get_main_queue(), ^{
            lock = NO;
        });
    }
    else {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self showPage:page];
    }
    
    previousWidth = scrollView.width;
}

-(void)showPage:(int)index {
    if (index<0 || index >= self.mediaViews.count || self.pageControl.currentPage == index) {
        return;
    }
    currentPlay = index;
    UIView* view = [self.mediaViews objectAtIndex:index];
    [self.scrollView scrollRectToVisible:CGRectMake(view.x, 0, view.width, view.height) animated:YES];
    self.pageControl.currentPage = index;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(void)layoutSubviews {
    self.scrollView.width = self.width;
    self.scrollView.height = self.height;
    int x = 0;
    for (UIView* view in self.mediaViews) {
        CGRect f = CGRectMake(x, 0, self.width, self.height);
        view.frame = f;
        x += self.width;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.height);
    UIView* view = [self.mediaViews objectAtIndex:currentPlay];
    [self.scrollView scrollRectToVisible:CGRectMake(view.x, 0, view.width, view.height) animated:YES];
}

-(void)play
{
    if(self.mediaViews.count == 0)
        return;
    [self showPage:currentPlay];
    MediaConentView* view = [self.mediaViews objectAtIndex:currentPlay];
    [view play];
    WeakSelf(weakSelf)
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:weakSelf selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];
}

-(void)checkPlayerStatus
{
    MediaContentAudioView* view = [self.mediaViews objectAtIndex:currentPlay];
    if([view isPlaying]) {
        return;
    }
    currentPlay++;
    if(currentPlay >= self.mediaViews.count)
        currentPlay = 0;
    [self showPage:currentPlay];
    view = [self.mediaViews objectAtIndex:currentPlay];
    [view play];
}

-(void)stop
{
    [timer invalidate];
    timer = nil;
    for(int i=0; i<self.mediaViews.count; i++) {
        MediaConentView* view = [self.mediaViews objectAtIndex:i];
        [view stop];
    }
}
@end
