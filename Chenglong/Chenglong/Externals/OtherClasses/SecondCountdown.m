//
//  Countdown.m
//  HeartBeat
//
//  Created by jijunyuan on 16/7/11.
//  Copyright © 2016年 xinkaishi－jjy. All rights reserved.
//

#import "SecondCountdown.h"

@interface SecondCountdown()
@property (nonatomic,assign) NSInteger maxSecond;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation SecondCountdown
/**
 *  实例化 倒计时
 *
 *  @param second 倒计时最大数
 *
 *  @return 返回倒计时实例
 */
+ (SecondCountdown *)CountdownWithMaxSecond:(NSInteger)second
{
    SecondCountdown * countDown = [[SecondCountdown alloc] init];
    countDown.maxSecond = second;
    
    return countDown;
}

- (SecondCountdown *)init
{
    self = [super init];
    if (self)
    {
       self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countSeconds) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)countSeconds
{
    self.isOn = YES;
    
    self.maxSecond --;
    if (self.secondDidchanged)
    {
        self.secondDidchanged(self.maxSecond);
    }
    if (self.maxSecond <= 0)
    {
        self.isOn = NO;
        [self.timer invalidate];
        self.timer = nil;
        
        if (self.secondDidFinished)
        {
            self.secondDidFinished(self.maxSecond);
        }
        return;
    }
}

- (void)stop
{
    if (self.timer)
    {
        self.isOn = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
