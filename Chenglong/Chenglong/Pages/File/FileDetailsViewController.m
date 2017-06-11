//
//  FileDetailsViewController.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 6/6/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "FileDetailsViewController.h"
#import "MediaContentAudioView.h"

@interface FileDetailsViewController ()

@property(strong, nonatomic) MediaContentAudioView* mediaContentAudioView;

@end

@implementation FileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseDetails.course.title;

    self.mediaContentAudioView = [[MediaContentAudioView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mediaContentAudioView];
    
    if(self.courseDetails.course.resources) {
        MediaContent* mc = [self.courseDetails.course.resources objectAtIndex:0];
        NSLog(@"file media content %@", [mc toJson]);
        if([mc.contentType hasPrefix:@"audio"]) {
            LocalMediaContent* lmc = [[LocalMediaContent alloc] init];
            lmc.mediaContent = mc;
            lmc.filePath = [NSString stringWithFormat:@"%@/%@", self.currentDirPath, self.courseDetails.course.id];
            if(![lmc isDownloaded]) {
                [lmc downloadWithProgressBlock:^(CGFloat progress) {
                    
                } completionBlock:^(BOOL completed) {
                    self.mediaContentAudioView.localMediaContent = lmc;
                }];
            }
            else {
                self.mediaContentAudioView.localMediaContent = lmc;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
}


@end
