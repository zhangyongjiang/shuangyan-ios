//
//  FullScreenMediaViewController.h
//  Kaishi
//
//  Created by Hyun Cho on 1/20/16.
//  Copyright © 2016 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVFullScreenMediaViewer;

@protocol DVFullScreenMediaViewerDataSource <NSObject>

@required

- (NSInteger)numberMediasForViewer:(DVFullScreenMediaViewer*)controller;
- (UIImage*)defaultImageAtIndex:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;
- (UIView*)referenceViewAtIndex:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;

@optional
- (NSURL*)imageURLAtIndex:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;
- (NSURL*)videoURLAtIndex:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;
- (NSString*)localVideoUrlPathAtIndex:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;

@end


@protocol DVFullScreenMediaViewerDelegate <NSObject>

@optional
- (void)requestImageFromURLForImageView:(UIImageView*)imageView placeHolder:(UIImage*)placeHolder imageURL:(NSURL*)imageURL index:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;
- (void)downloadVideoLocally:(NSInteger)index imageViewer:(DVFullScreenMediaViewer*)controller;
- (void)willDismiss:(DVFullScreenMediaViewer*)controller;
- (void)didDismiss:(DVFullScreenMediaViewer*)controller;

@end

typedef void (^FullScreenMediaDidDismissWithImage)(DVFullScreenMediaViewer* controller, UIImage* image);

@interface DVFullScreenMediaViewer : UIViewController

@property (nonatomic, copy) NSString* mediaTitle;
@property (nonatomic, copy) NSString* mediaDescription;

@property (nonatomic, weak) id<DVFullScreenMediaViewerDataSource> dataSource;
@property (nonatomic, weak) id<DVFullScreenMediaViewerDelegate> delegate;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSDictionary* userInfo;
@property (nonatomic, assign) BOOL disableTouchTemporarily;

- (id)initWithDataSource:(id<DVFullScreenMediaViewerDataSource>)dataSource withDelegate:(id<DVFullScreenMediaViewerDelegate>)delegate;
- (void)showMediaViewerOfIndex:(NSInteger)index;
- (void)showFromViewController:(UIViewController*)viewController fromIndex:(NSInteger)index;
- (void)playVideoWithURL:(NSString *)filePath;

@end