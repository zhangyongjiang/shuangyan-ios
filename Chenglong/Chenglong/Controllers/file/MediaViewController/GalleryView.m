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
#import "MediaContentPdfView.h"
#import "MediaContentImageView.h"

@interface GalleryView()
{
    int currentPlay;
}

@property(strong, nonatomic) MediaContentTextView* textView;
@property(strong, nonatomic) MediaContentImageView* imageView;
@property(strong, nonatomic) MediaContentPdfView* pdfView;
@property(strong, nonatomic) MediaContentAudioView* audioView;
@property(strong, nonatomic) MediaContentVideoView* videoView;

@property(strong,nonatomic)NSMutableArray* mediaViews;

@end

@implementation GalleryView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.mediaViews = [[NSMutableArray alloc] init];
    
    currentPlay = 0;
    self.backgroundColor = [UIColor whiteColor];

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:NotificationPlayEnd object:nil];
    
    self.textView = [[MediaContentTextView alloc]initWithFrame:frame];
    self.imageView = [[MediaContentImageView alloc]initWithFrame:frame];
    self.audioView = [[MediaContentAudioView alloc]initWithFrame:frame];
    self.videoView = [[MediaContentVideoView alloc]initWithFrame:frame];
    self.pdfView = [[MediaContentPdfView alloc]initWithFrame:frame];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.pdfView];
    [self.scrollView addSubview:self.audioView];
    [self.scrollView addSubview:self.videoView];
    
    return self;
}

-(void)playEnd:(NSNotification*)noti
{
    currentPlay++;
    if(currentPlay >= self.mediaViews.count)
        currentPlay = 0;

    self.scrollView.contentOffset = CGPointMake(currentPlay*self.scrollView.width, 0);
    self.pageControl.currentPage = currentPlay;

    LocalMediaContent* mc = [self.mediaViews objectAtIndex:currentPlay];
    MediaConentView* view = [self getViewForMediaContent:mc];
    [view play];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textView removeFromSuperview];
    [self.imageView removeFromSuperview];
    [self.pdfView removeFromSuperview];
    [self.audioView removeFromSuperview];
    [self.videoView removeFromSuperview];
}

-(void)showCourseDetailsArray:(NSMutableArray *)courseDetailsArray
{
    for (CourseDetails* cd in courseDetailsArray) {
        [self showCourseDetails:cd];
    }
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

    self.scrollView.contentSize = CGSizeMake(self.width * self.mediaViews.count, self.height);

    [self showPage:0];
    
    self.pageControl.numberOfPages = self.mediaViews.count;
    [self bringSubviewToFront:self.pageControl];
    self.pageControl.hidden = (self.mediaViews.count<2);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // prevent to scroll to the first page when changing orientation
    static int previousWidth = 0;
    static BOOL lock = NO;
    if(lock)
        return;
    
    if(currentPlay>0 && previousWidth != (int)scrollView.width) {
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
    if (currentPlay >= 0 && (index<0 || index >= self.mediaViews.count || self.pageControl.currentPage == index)) {
        return;
    }
    currentPlay = index;
    LocalMediaContent* mc = [self.mediaViews objectAtIndex:index];
    MediaConentView* view = [self getViewForMediaContent:mc];
    [self.scrollView bringSubviewToFront:view];
    view.x = self.scrollView.width * index;
    
    [self.scrollView scrollRectToVisible:CGRectMake(index*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:YES];
    self.pageControl.currentPage = index;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRadioValueChanged object:self];
}

-(MediaConentView*)getViewForMediaContent:(LocalMediaContent*)mc
{
    [[MediaPlayer shared] removeTask:mc];
    if(mc.isText) {
        self.textView.text = mc.content;
        return self.textView;
    }
    if(mc.isImage) {
        self.imageView.localMediaContent = mc;
        return self.imageView;
    }
    if(mc.isPdf) {
        self.pdfView.localMediaContent = mc;
        return self.pdfView;
    }
    if(mc.isAudio) {
        self.audioView.localMediaContent = mc;
        return self.audioView;
    }
    if(mc.isVideo) {
        self.videoView.localMediaContent = mc;
        return self.videoView;
    }
    return NULL;
}

-(void)layoutSubviews {
    self.scrollView.width = self.width;
    self.scrollView.height = self.height;
    self.scrollView.contentSize = CGSizeMake(self.mediaViews.count*self.width, self.height);
    
    LocalMediaContent* mc = [self.mediaViews objectAtIndex:currentPlay];
    MediaConentView* view = [self getViewForMediaContent:mc];
    view.x = self.width * currentPlay;
    [self.scrollView bringSubviewToFront:view];

    [self.scrollView scrollRectToVisible:CGRectMake(view.x, 0, self.width, self.height) animated:YES];
}

-(void)play
{
    if(self.mediaViews.count == 0)
        return;
    [self showPage:currentPlay];
    
    LocalMediaContent* mc = [self.mediaViews objectAtIndex:currentPlay];
    MediaConentView* view = [self getViewForMediaContent:mc];
    [view play];
}

-(void)stop
{
    [self.textView stop];
    [self.imageView stop];
    [self.pdfView stop];
    [self.audioView stop];
    [self.videoView stop];
}
@end
