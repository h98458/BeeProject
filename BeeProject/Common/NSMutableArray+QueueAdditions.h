//
//  NSMutableArray+QueueAdditions.h
//  huangrg_ios
//
//  Created by hrg on 13-7-1.
//  Copyright (c) 2013年 huangrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
-(id)dequeue;
-(void)enqueue:(id)obj;
-(void)removeQueue;

-(BOOL)isEmpty;

-(id)peek:(int)index;
-(id)peekHead;

@end
