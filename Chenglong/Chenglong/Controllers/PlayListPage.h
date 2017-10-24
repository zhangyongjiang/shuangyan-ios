//
//  PlayListPage.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 10/21/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "Page.h"
#import "MediaContentViewContailer.h"
#import "PlayerControlView.h"

@interface PlayListPage : Page

@property(strong, nonatomic) MediaContentViewContailer* containerView;
@property(strong, nonatomic)PlayerControlView* playerControlView;

@end
