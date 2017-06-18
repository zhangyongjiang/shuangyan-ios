//
//  MediaWebView.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/17/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "MediaWebView.h"
#import <AVFoundation/AVFoundation.h>

@implementation MediaWebView


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!ok) {
        NSLog(@"Error setting AVAudioSessionCategoryPlayback: %@", setCategoryError);
    };
    return YES;
}


@end
