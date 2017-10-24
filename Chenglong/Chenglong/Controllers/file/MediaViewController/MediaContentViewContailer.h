//
//  MediaContentViewContailer.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/31/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseView.h"
#import "PlayerControlView.h"

@interface MediaContentViewContailer : BaseView

@property(strong, nonatomic)LocalMediaContent* localMediaContent;
@property(strong, nonatomic)PlayerControlView* playerControlView;

-(void)play;
-(void)stop;
-(void)showCoverImage;

@end
