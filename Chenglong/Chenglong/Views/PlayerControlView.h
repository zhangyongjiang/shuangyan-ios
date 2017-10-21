//
//  PlayerControlView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

@interface PlayerControlView : BaseView

@property(strong, nonatomic) UIImageView* btnPlayPause;
@property(strong, nonatomic) UIImageView* btnPrev;
@property(strong, nonatomic) UIImageView* btnNext;
@property(strong, nonatomic) UIImageView* btnFullScreen;
@property(strong, nonatomic) FitLabel* labelCurrentTime;
@property(strong, nonatomic) FitLabel* labelTotalTime;
@property (strong, nonatomic) UISlider* slider;

-(void)showPlayButton;
-(void)showPauseButton;

@end
