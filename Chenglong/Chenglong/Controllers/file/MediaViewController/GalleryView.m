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
    self.backgroundColor = [UIColor blackColor];
    self.contentMode = UIViewContentModeScaleAspectFill;

    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.scrollView];
    self.scrollView.pagingEnabled = true;
    self.scrollView.scrollsToTop = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height*0.90, frame.size.width, 50*[UIView scale])];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorFromString:@"nsred"];

    [self addSubview:self.pageControl];
    
    return self;
}

-(void)dealloc
{
    for(MediaConentView* view in self.mediaViews) {
        [view removeFromSuperview];
    }
    
    [timer invalidate];
    timer = nil;
}

-(void)setMediaContents:(NSArray *)mediaContents {
    _mediaContents = mediaContents;
    self.scrollView.contentSize = CGSizeMake(self.width * mediaContents.count, self.height);
    for (UIView* imgView in self.mediaViews) {
        [imgView removeFromSuperview];
    }
    self.mediaViews = [[NSMutableArray alloc] init];
    for (int i=0; i<mediaContents.count; i++) {
        CGFloat x = i * self.width;
        MediaConentView* view = [MediaConentView createViewForMediaContent:[mediaContents objectAtIndex:i]];
        view.frame = CGRectMake(x, 0, self.width, self.height);
        view.clipsToBounds = YES;
        [self.mediaViews addObject:view];
        [self.scrollView addSubview:view];
    }
    [self showPage:0];
    
    self.pageControl.numberOfPages = mediaContents.count;
    [self bringSubviewToFront:self.pageControl];
    if (mediaContents.count<2) {
        self.pageControl.hidden = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // disable vertical scroll
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self showPage:page];
}

-(void)showPage:(int)index {
    if (index<0 || index >= self.mediaContents.count || self.pageControl.currentPage == index) {
        return;
    }
    UIView* view = [self.mediaViews objectAtIndex:index];
    [self.scrollView scrollRectToVisible:CGRectMake(view.x, 0, view.width, view.height) animated:YES];
    self.pageControl.currentPage = index;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(void)layoutSubviews {
    self.scrollView.width = self.width;
    self.scrollView.height = self.height;
    int x = 0;
    for (MediaConentView* view in self.mediaViews) {
        CGRect f = CGRectMake(x, 0, self.width, self.height);
        view.frame = f;
        x += self.width;
    }
}

-(void)play
{
    if(self.mediaContents.count == 0)
        return;
    [self showPage:currentPlay];
    MediaContentAudioView* view = [self.mediaViews objectAtIndex:currentPlay];
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
    if(currentPlay >= self.mediaContents.count)
        currentPlay = 0;
    [self showPage:currentPlay];
    view = [self.mediaViews objectAtIndex:currentPlay];
    [view play];
}

-(void)stop
{
    [timer invalidate];
    timer = nil;
    for(int i=0; i<self.mediaContents.count; i++) {
        MediaContent* mc = [self.mediaContents objectAtIndex:i];
        if([mc.contentType hasPrefix:@"audio"]) {
            MediaContentAudioView* view = [self.mediaViews objectAtIndex:i];
            [view stop];
        }
        else if([mc.contentType hasPrefix:@"video"]) {
            MediaContentVideoView* view = [self.mediaViews objectAtIndex:i];
            [view stop];
        }
    }
}
@end
