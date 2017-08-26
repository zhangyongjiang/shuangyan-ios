//
//  PlayerControlView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/23/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"

@interface PlayerControlView : BaseView

@property(strong, nonatomic) UIImageView* btn;

-(void)showPlayButton;
-(void)showPauseButton;

@end
