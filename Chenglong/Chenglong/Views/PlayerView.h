//
//  PlayerView.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/24/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"
#import "MediaContentViewContailer.h"
#import "PlayerControlView.h"

@interface PlayerView : BaseView

@property(strong, nonatomic) MediaContentViewContailer* containerView;
@property(strong, nonatomic) PlayerControlView* controlView;

@end





