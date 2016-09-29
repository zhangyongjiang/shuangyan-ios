//
//  MenuPage.m
//
//
//  Created by Kevin Zhang on 11/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import "MenuPage.h"
#import "UIImage+ImageEffects.h"

@implementation MenuPage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.tableData = [[SimpleTableViewData alloc] initWithSections:
                      [[SimpleTableViewSection alloc] initWithHeader:@"account" andRows:@"Update Profile", @"Change Password", @"Shipping", @"JOURNAL", nil],
                      [[SimpleTableViewSection alloc] initWithHeader:@"Favorites" andRows:@"Favorites", @"Followed Stores", nil],
                      nil] ;
    return self;
}


@end

