//
//  TMBadge.m
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMBadge.h"

@implementation TMBadge
@synthesize numTasksFinishedWithinDeadline;
@synthesize numTasksFinishedExceedDeadline;

- (id)init
{
    self = [super init];
    if(self){
        numTasksFinishedWithinDeadline = 0;
        numTasksFinishedExceedDeadline = 0;
    }
    return self;
}
#pragma helper
-(void)increaseWithin{
    numTasksFinishedWithinDeadline += 1;
}
-(void)increaseExceed{
    numTasksFinishedExceedDeadline += 1;
}
#pragma archiving NSCode functions
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:numTasksFinishedWithinDeadline forKey:@"numTasksFinishedWithinDeadline"];
    [aCoder encodeInteger:numTasksFinishedExceedDeadline forKey:@"numTasksFinishedExceedDeadlin"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        [self setNumTasksFinishedWithinDeadline:[aDecoder decodeObjectForKey:@"numTasksFinishedWithinDeadline"]];
        [self setNumTasksFinishedExceedDeadline:[aDecoder decodeObjectForKey:@"numTasksFinishedExceedDeadline"]];
    }
    return self;
}
@end
