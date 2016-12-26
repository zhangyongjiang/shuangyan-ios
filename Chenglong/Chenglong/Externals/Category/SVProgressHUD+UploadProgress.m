//
//  SVProgressHUD+UploadProgress.m
//  Kaishi
//
//  Created by Hyun Cho on 12/6/15.
//  Copyright © 2015 BCGDV. All rights reserved.
//

#import "SVProgressHUD+UploadProgress.h"

@implementation SVProgressHUD (UploadProgress)

+ (void)showUploadProgressWithStatus:(NSString*)status
							progress:(NSProgress*)progress {
	
	NSString* text = [NSString stringWithFormat:@"%@\n%.1f/%.1f KB", status, (CGFloat)progress.completedUnitCount/1000.0, (CGFloat)progress.totalUnitCount/1000.0];
	[SVProgressHUD showProgress:progress.fractionCompleted status:text];
}
@end
