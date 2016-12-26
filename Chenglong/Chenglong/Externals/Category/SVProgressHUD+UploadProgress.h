//
//  SVProgressHUD+UploadProgress.h
//  Kaishi
//
//  Created by Hyun Cho on 12/6/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (UploadProgress)

+ (void)showUploadProgressWithStatus:(NSString*)status
							progress:(NSProgress*)progress;

@end
