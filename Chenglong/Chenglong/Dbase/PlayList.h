//
//  PlayList.h
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 12/3/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "TableBase.h"

@interface PlayList : TableBase

-(BOOL)savePlayList:(NSArray*)list;
-(BOOL)deleteAllPlayList;
-(NSMutableArray*)getPlayList;

@end
