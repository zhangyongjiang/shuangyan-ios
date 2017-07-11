//
//  MediaViewController.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 7/4/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "BaseViewController.h"

@interface MediaViewController : BaseViewController

@property(strong,nonatomic)NSArray* mediaContents;

-(void)play;

@end
