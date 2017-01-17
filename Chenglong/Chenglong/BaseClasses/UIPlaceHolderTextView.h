//
//  UIPlaceHolderTextView.h
//  Kaishi
//
//  Created by Hyun Cho on 7/17/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//  From: http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
//

#import <UIKit/UIKit.h>

typedef void(^TextChangeBlock)(void);

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, copy) TextChangeBlock textChangeBlock;

@end
