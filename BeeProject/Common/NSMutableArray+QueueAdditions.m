//
//  NSMutableArray+QueueAdditions.m
//  huangrg_ios
//
//  Created by hrg on 13-7-1.
//  Copyright (c) 2013年 huangrg. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)

- (id) dequeue
{
    if (self.count<=0)
    {
        return nil;
    }
    id headObject = [self objectAtIndex:0];
    if (headObject != nil)
    {
        @synchronized(self)
        {
           [self removeObjectAtIndex:0];
        }
    }
    return headObject;
}

-(void)enqueue:(id)obj
{
    @synchronized(self)
    {
        [self addObject:obj];
    }
}

-(void)removeQueue
{
    @synchronized(self)
    {
        [self removeAllObjects];
    }
    
}

-(BOOL)isEmpty
{
    return self.count == 0;
}


-(id)peek:(int)index
{
    if ((self.count <= 0)||(index <0))
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

-(id)peekHead
{
    return [self peek:0];
}

@end

