//
//  FullScreenMediaViewController.m
//  Kaishi
//
//  Created by Hyun Cho on 1/20/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import "DVFullScreenMediaViewer.h"
#import "DVFullScreenMediaScrollView.h"
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat kFadeAnimationDuration = 0.3;

@interface DVFullScreenMediaViewer () <UIScrollViewDelegate, DVFullScreenMediaScrollViewDelegate>

@property (nonatomic, weak) UIViewController* ownerController;
@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, assign) UIStatusBarStyle originalStatusBarStyle;
@property (nonatomic, strong) UIToolbar* toolBar;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) DVFullScreenMediaScrollView* currentPageView;
@property (nonatomic, strong) NSMutableArray* pageViewPool;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;

@end

@implementation DVFullScreenMediaViewer

- (id)initWithDataSource:(id<DVFullScreenMediaViewerDataSource>)dataSource withDelegate:(id<DVFullScreenMediaViewerDelegate>)delegate {
    _dataSource = dataSource;
    _delegate = delegate;
    self = [super initWithNibName:nil bundle:nil];
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    
    self.view = [[UIView alloc] initWithFrame:windowBounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.backgroundView = [[UIView alloc] initWithFrame:windowBounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.backgroundView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:windowBounds];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS_SIZE_HEIGHT-50, SCREEN_BOUNDS_SIZE_WIDTH, 30)];
//    _pageControl.pageIndicatorTintColor = [UIColor colorFromString:@"ffffff"];
//    _pageControl.currentPageIndicatorTintColor = [UIColor colorFromString:@"555555"];
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
    
    // Add "Close" toolbar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, windowBounds.size.width, 44)];
    [self.toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault]; // make the toolbar trasparent
    self.toolBar.tintColor = [UIColor whiteColor];
    self.toolBar.hidden = YES;
    [self.view addSubview:self.toolBar];
    
    typeof(self) __weak weakSelf = self;
	UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48.0, 28)];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton setTitle:@"关闭" forState:UIControlStateNormal];
	closeButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	closeButton.layer.cornerRadius = 3.0;
	[closeButton bk_addEventHandler:^(id sender) {
		[SVProgressHUD dismiss];

		[weakSelf dismiss:YES];
	} forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.toolBar setItems:@[closeItem]];

    // add a pool for pages to reuse
    const NSInteger pagePoolCount = 5;
    self.pageViewPool = [NSMutableArray arrayWithCapacity:pagePoolCount];
    for ( NSInteger i = 0; i < pagePoolCount; ++i ) {
        DVFullScreenMediaScrollView* pageView = [[DVFullScreenMediaScrollView alloc] initWithFrame:windowBounds];
        pageView.hidden = YES;
        pageView.fsmDelegate = self;
        [self.pageViewPool addObject:pageView];
        [self.scrollView addSubview:pageView];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMovieStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}


- (void)showMediaViewerOfIndex:(NSInteger)index {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self showFromViewController:rootViewController fromIndex:index];
}


- (void)showFromViewController:(UIViewController*)viewController fromIndex:(NSInteger)index {

    typeof(self) __weak weakSelf = self;

    self.currentPageIndex = index;
    self.ownerController = viewController;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    
    [viewController addChildViewController:self];
    [self didMoveToParentViewController:viewController];

    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    
    self.backgroundView.alpha = 0.0;
    
    NSInteger mediaCount = [self.dataSource numberMediasForViewer:self];

    if ( index < mediaCount ) {
        self.scrollView.contentSize = CGSizeMake(windowBounds.size.width * mediaCount, windowBounds.size.height);
        self.scrollView.contentOffset = CGPointMake(windowBounds.size.width * index, 0);

        UIView* senderView = [self.dataSource referenceViewAtIndex:index imageViewer:self];
        if ( senderView != nil ) {
            
            self.currentPageView = [self dequePageViewWithIndex:index];
            if ( index == 0 ) {
                if ( mediaCount > 1 ) {
                    [self dequePageViewWithIndex:1]; // next
                }
            } else if ( index == mediaCount-1) {
                [self dequePageViewWithIndex:index-1]; // previous
            } else {
                [self dequePageViewWithIndex:index-1]; // previous
                [self dequePageViewWithIndex:index+1]; // next
            }
            
            [self loadSequentialImagesFromIndex:index];

            // Compute Sender Frame Relative To Screen
            CGRect newFrame = [senderView convertRect:windowBounds toView:nil];
            newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
            newFrame.size = senderView.frame.size;
            self.currentPageView.imageView.frame = newFrame;
            
            [UIView animateWithDuration:kFadeAnimationDuration delay:0.0f options:0 animations:^{
                [self.currentPageView centerFrameFromImage:self.currentPageView.imageView.image];
                CGAffineTransform transf = CGAffineTransformIdentity;

                // Root View Controller - move backward
                viewController.view.transform = CGAffineTransformScale(transf, 0.95f, 0.95f);
                weakSelf.backgroundView.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                self.originalStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
                [UIApplication sharedApplication].statusBarHidden = YES;
                
                [self setupVideoAtIndex:index];
            }];

        }
        
    }
}


- (void)playVideoWithURL:(NSString *)filePath {
    CGRect windowBounds = [[UIScreen mainScreen] bounds];

    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    [self.moviePlayer prepareToPlay];

    [self.view addSubview:self.moviePlayer.view];
    self.moviePlayer.view.frame = windowBounds;
    self.moviePlayer.view.hidden = YES;
    [self.view bringSubviewToFront:self.toolBar];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayer.shouldAutoplay = YES;
    //  [self.moviePlayer setFullscreen:YES animated:NO];
}


- (void)dismiss:(BOOL)animated {
    
    if ( [self.delegate respondsToSelector:@selector(willDismiss:)] ) {
        [self.delegate willDismiss:self];
    }
    
    self.toolBar.hidden = YES;
    self.pageControl.hidden = YES;
    if ( self.moviePlayer != nil ) {
        [self.moviePlayer pause];
        self.moviePlayer.view.hidden = YES;
    }
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = self.originalStatusBarStyle;
    
    [UIView animateWithDuration:kFadeAnimationDuration delay:0.0f options:0 animations:^{
        CGAffineTransform transf = CGAffineTransformIdentity;
        self.ownerController.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
        self.backgroundView.alpha = 0.0;
        
        CGRect windowBounds = [[UIScreen mainScreen] bounds];
        UIView* senderView = [self.dataSource referenceViewAtIndex:self.currentPageIndex imageViewer:self];
        if ( senderView != nil ) {
            CGRect newFrame = [senderView convertRect:windowBounds toView:nil];
            newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y+MAX(0, self.currentPageView.contentOffset.y));
            newFrame.size = senderView.frame.size;
            self.currentPageView.imageView.frame = newFrame;
        }
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        self.ownerController = nil;
        
        if ( [self.delegate respondsToSelector:@selector(didDismiss:)] ) {
            [self.delegate didDismiss:self];
        }

    }];
    
}


- (void)onSingleTap:(UIGestureRecognizer*)gesture {
    if ( self.disableTouchTemporarily ) {
        return;
    }
    
    [SVProgressHUD dismiss];
    if( self.currentPageView.zoomScale == self.currentPageView.minimumZoomScale){
        //关闭大图浏览
        [self dismiss:YES];
        
    }else if( self.currentPageView.zoomScale > self.currentPageView.minimumZoomScale) {
        CGPoint pointInView = [gesture locationInView:self.currentPageView];
        [self.currentPageView zoomInZoomOut:pointInView];
        WeakSelf(weakSelf)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            //关闭大图浏览
            [weakSelf dismiss:YES];
        });
    }
    
}


- (void)onDoubleTap:(UIGestureRecognizer*)gesture {
    if ( self.disableTouchTemporarily ) {
        return;
    }

    CGPoint pointInView = [gesture locationInView:self.currentPageView];
    [self.currentPageView zoomInZoomOut:pointInView];
}


- (void)setDisableTouchTemporarily:(BOOL)disableTouchTemporarily {
    _disableTouchTemporarily = disableTouchTemporarily;
    self.currentPageView.userInteractionEnabled = !disableTouchTemporarily;
}


- (void)loadSequentialImagesFromIndex:(NSInteger)index {
    NSInteger mediaCount = [self.dataSource numberMediasForViewer:self];

    typeof (self) __weak weakSelf = self;
    void (^setImageBlock)(NSInteger index) = ^void(NSInteger index) {
        UIImage* image = [self.dataSource defaultImageAtIndex:index imageViewer:self];
        if ( image != nil ) {
            DVFullScreenMediaScrollView* pageView = [weakSelf pageViewWithIndex:index];
            pageView.imageView.image = image;
            [pageView centerFrameFromImage:image];
        }
    };

    
    if ( [self.dataSource respondsToSelector:@selector(defaultImageAtIndex:imageViewer:)] ) {
        if ( index == 0 ) {
            setImageBlock(0);
            if ( mediaCount > 1 ) {
                setImageBlock(1);
            }
        } else if ( index == mediaCount - 1 ) {
            setImageBlock(index);
            setImageBlock(index-1);
        } else {
            setImageBlock(index);
            setImageBlock(index-1);
            setImageBlock(index+1);
        }
    }
    
    void (^setImageRequestBlock)(NSInteger index) = ^void(NSInteger index) {
        NSURL* imageUrl = [weakSelf.dataSource imageURLAtIndex:index imageViewer:self];
        if ( imageUrl != nil ) {
            DVFullScreenMediaScrollView* pageView = [weakSelf pageViewWithIndex:index];
            if ( pageView != nil ) {
                [weakSelf.delegate requestImageFromURLForImageView:pageView.imageView placeHolder:pageView.imageView.image imageURL:imageUrl index:index imageViewer:weakSelf];
            }
        }
    };

    if ( [self.dataSource respondsToSelector:@selector(imageURLAtIndex:imageViewer:)] &&
        [self.dataSource respondsToSelector:@selector(requestImageFromURLForImageView:placeHolder:imageURL:index:imageViewer:)] ) {
        
        if ( index == 0 ) {
            setImageRequestBlock(0);
            if ( mediaCount > 1 ) {
                setImageRequestBlock(1);
            }
        } else if ( index == mediaCount - 1 ) {
            setImageRequestBlock(index);
            setImageRequestBlock(index-1);
        } else {
            setImageRequestBlock(index);
            setImageRequestBlock(index-1);
            setImageRequestBlock(index+1);
        }
    }
}

- (DVFullScreenMediaScrollView*)dequePageViewWithIndex:(NSInteger)index {
    for ( DVFullScreenMediaScrollView* pageView in self.pageViewPool ) {
        if ( pageView.hidden ) {
            CGRect windowBounds = [[UIScreen mainScreen] bounds];

            pageView.hidden = NO;
            pageView.tag = index;
            pageView.frame = CGRectMake(windowBounds.size.width * index, 0, windowBounds.size.width, windowBounds.size.height);
            return pageView;
        }
    }
    
    return nil;
}


- (void)enquePageView:(DVFullScreenMediaScrollView*)pageView {
    pageView.hidden = YES;
    pageView.tag = -1;
    pageView.imageView.image = nil;
}


- (DVFullScreenMediaScrollView*)pageViewWithIndex:(NSInteger)index {
    for ( DVFullScreenMediaScrollView* scrollView in self.pageViewPool ) {
        if ( scrollView.hidden == NO && scrollView.tag == index ) {
            return scrollView;
        }
    }
    
    return nil;
}

- (void)onMovieStateDidChange:(id)sender {
    if ( self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying ) {
        self.moviePlayer.view.hidden = NO;
        
        [SVProgressHUD dismiss];
    }
}


- (void)setupVideoAtIndex:(NSInteger)index {
    BOOL hasVedio = NO;
    if ( [self.dataSource respondsToSelector:@selector(localVideoUrlPathAtIndex:imageViewer:)] ) {
        if ( [self.dataSource respondsToSelector:@selector(videoURLAtIndex:imageViewer:)] ) {
            // load local if exists; otherwise load remote
            NSURL* videoUrl = [self.dataSource videoURLAtIndex:index imageViewer:self];
            if ( videoUrl != nil && videoUrl.absoluteString.length > 0 ) {
                hasVedio = YES;
                NSString* localFilePath = [self.dataSource localVideoUrlPathAtIndex:index imageViewer:self];
                
                if ( [[NSFileManager defaultManager] fileExistsAtPath:localFilePath] ) {
                    [self playVideoWithURL:localFilePath];
                } else {
                    
                    if ( [self.delegate respondsToSelector:@selector(downloadVideoLocally:imageViewer:)] ) {
                        [self.delegate downloadVideoLocally:index imageViewer:self];
                    }
                }
            }
        } else {
            // local video only
            NSString* localFilePath = [self.dataSource localVideoUrlPathAtIndex:index imageViewer:self];
            if ( [[NSFileManager defaultManager] fileExistsAtPath:localFilePath] ) {
                hasVedio = YES;
                [self playVideoWithURL:localFilePath];
            }
        }
    }
    self.toolBar.hidden = !hasVedio;
    _pageControl.hidden = hasVedio;
    if (!hasVedio) {
        //图片情况下才加点击 双击事件
        // add tap gestures
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        [self.scrollView addGestureRecognizer:tap];
        
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.scrollView addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
        _pageControl.numberOfPages = [self.dataSource numberMediasForViewer:self];
        _pageControl.currentPage = index;
    }
}


# pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger currentPage = floor((scrollView.contentOffset.x-pageWidth/2) / pageWidth)+1;
    _pageControl.currentPage = currentPage;
    if ( currentPage != self.currentPageIndex ) {
        NSInteger indexToEnque;
        NSInteger indexToDequeue;
        if ( currentPage > self.currentPageIndex ) {
            indexToEnque = currentPage-2;
            indexToDequeue = currentPage+1;
        } else {
            indexToEnque = currentPage+2;
            indexToDequeue = currentPage-1;
        }
        DVFullScreenMediaScrollView* pageView = [self pageViewWithIndex:indexToEnque];
        if ( pageView != nil ) {
            [self enquePageView:pageView];
        }
        [self dequePageViewWithIndex:indexToDequeue];
        
        self.currentPageIndex = currentPage;
        self.currentPageView = [self pageViewWithIndex:self.currentPageIndex];
        [self loadSequentialImagesFromIndex:self.currentPageIndex];
    }
}

#pragma mark DVFullScreenMediaScrollViewDelegate
- (void)scrollViewChangedZoom:(DVFullScreenMediaScrollView *)scrollView {
    if ( scrollView.zoomScale == 1.0 ) {
//        self.toolBar.hidden = NO;
        self.scrollView.scrollEnabled = YES;
    } else {
//        self.toolBar.hidden = YES;
        self.scrollView.scrollEnabled = NO;
    }
}


@end
