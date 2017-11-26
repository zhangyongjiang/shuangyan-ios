//
//  main.m
//  Chenglong
//
//  Created by Kevin Zhang on 3/11/16.
//  Copyright © 2016 Chenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        int retval;
        @try{
            retval = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception)
        {
            NSLog(@"Gosh!!! %@", [exception callStackSymbols]);
            @throw;
        }
        return retval;
    }
}
