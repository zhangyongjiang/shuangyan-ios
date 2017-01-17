//
//  MediaPreviewViewController.h
//  Kaishi
//
//  Created by Hyun Cho on 7/27/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MediaPreviewViewController;

typedef void (^MediaPreviewRemoveMedia)(MediaPreviewViewController*);

@interface MediaPreviewViewController : UIViewController

@property (nonatomic, strong) MediaPreviewRemoveMedia removeMedia;

- (id)initWithImage:(UIImage*)image videoAssetUrl:(NSURL*)videoAssetUrl withReferenceView:(UIView*)referenceView;
- (void)showFromViewController:(UIViewController*)viewController;
- (void)dismiss;

@end
