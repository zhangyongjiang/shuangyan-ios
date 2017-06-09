//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileDetailsViewController.h"
#import "MP3FilePage.h"

@interface FileDetailsViewController ()

@property(strong, nonatomic) MP3FilePage* mp3Page;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mp3Page = [[MP3FilePage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mp3Page];
    
    if(self.courseDetails.course.resources) {
        MediaContent* mc = [self.courseDetails.course.resources objectAtIndex:0];
        NSLog(@"file media content %@", [mc toJson]);
        if([mc.contentType hasPrefix:@"audio"]) {
            self.mp3Page.online = mc;
            NSString* currdir = [[NSFileManager defaultManager] currentDirectoryPath];
            self.mp3Page.offline = [NSString stringWithFormat:@"%@/%@", currdir, self.courseDetails.course.id];
            if(![self.mp3Page downloaded]) {
                [self.mp3Page downloadWithProgressBlock:^(CGFloat progress) {
                    
                } completionBlock:^(BOOL completed) {
                    [self.mp3Page play];
                }];
            }
            else {
                [self.mp3Page play];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
}


@end
