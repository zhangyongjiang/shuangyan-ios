//
//  DetailViewController.h
//  Chenglong
//
//  Created by Kevin Zhang on 3/11/16.
//  Copyright © 2016 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

