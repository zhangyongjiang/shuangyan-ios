//
//  MediaPreviewViewController.m
//  Kaishi
//
//  Created by Hyun Cho on 7/27/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "MediaPreviewViewController.h"
#import "MediaPreviewView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPreviewViewController ()

@property (nonatomic, strong) MediaPreviewView* previewView;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSURL* videoAssetUrl;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;

@end


@implementation MediaPreviewViewController

- (id)initWithImage:(UIImage*)image videoAssetUrl:(NSURL*)videoAssetUrl withReferenceView:(UIView*)referenceView {
    self = [super initWithNibName:nil bundle:nil];
    
    _image = image;
    _videoAssetUrl = videoAssetUrl;
    
    return self;
}


//- (void)dealloc {
//    NSLog(@"MediaPreviewViewController: dealloc");
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previewView = [MediaPreviewView newAutoLayoutView];
    if ( self.videoAssetUrl != nil ) {
        
        // Initialize the movie player and add it to the playerview
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoAssetUrl];
        [self.previewView setMoviePlayerView:self.moviePlayer.view];
        
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne; // loop
        self.moviePlayer.shouldAutoplay = YES;
        self.moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.moviePlayer play];
        
    } else if ( self.image != nil ) {
        self.previewView.imageView.image = self.image;
    }
    
    [self.view addSubview:self.previewView];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view setNeedsUpdateConstraints];
    
    MediaPreviewViewController* __weak weakSelf = self;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakSelf dismiss];
    }];
    [self.previewView addGestureRecognizer:tap];
    
    [self.previewView.deleteButton bk_addEventHandler:^(id sender) {
        NSString* promptMessage = (self.videoAssetUrl != nil) ? @"确定要删除此照片吗" : @"确定要删除此照片吗";
        
        if ( [UIAlertController class] ) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:promptMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *remove = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ( weakSelf.removeMedia != nil ) {
                    weakSelf.removeMedia(weakSelf);
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:remove];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            UIAlertView* alertView = [UIAlertView bk_alertViewWithTitle:@"温馨提示" message:promptMessage];
            [alertView bk_addButtonWithTitle:@"删除" handler:^{
                if ( weakSelf.removeMedia != nil ) {
                    weakSelf.removeMedia(weakSelf);
                }
            }];
            [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [alertView show];
        }
    } forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.previewView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}


- (BOOL)prefersStatusBarHidden {
    return YES; //FIXME: not calling for some reason
}


- (void)showFromViewController:(UIViewController*)viewController {
    
    //    self.providesPresentationContextTransitionStyle = YES;
    //    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalPresentationCapturesStatusBarAppearance = YES; // not working
    [self setNeedsStatusBarAppearanceUpdate];
    
    //    self.modalPresentationStyle = UIModalPresentationCurrentContext; // iOS7
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [viewController presentViewController:self animated:YES completion:nil];
}


- (void)dismiss {
    if ( self.moviePlayer != nil ) {
        [self.moviePlayer pause];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
