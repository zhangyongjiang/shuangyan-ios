//
//  Countdown.h
//  HeartBeat
//
//  Created by jijunyuan on 16/7/11.
//  Copyright © 2016年 xinkaishi－jjy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SecondChanged)(NSInteger changeSecond);

@interface SecondCountdown : NSObject

@property (nonatomic,copy) SecondChanged secondDidchanged;
@property (nonatomic,copy) SecondChanged secondDidFinished;
@property (nonatomic,assign) BOOL isOn;  //YES：计时器正在执行

/**
 *  实例化 倒计时
 *
 *  @param second 倒计时最大数
 *
 *  @return 返回倒计时实例
 */
+ (SecondCountdown *)CountdownWithMaxSecond:(NSInteger)second;

- (void)stop;
@end
