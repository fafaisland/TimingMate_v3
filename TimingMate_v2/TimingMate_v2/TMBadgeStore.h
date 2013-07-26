//
//  TMBadgeStore.h
//  TimingMate_v2
//
//  Created by easonfafa on 7/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBadge.h"

@interface TMBadgeStore : NSObject
{
    TMBadge *badge;
}

+ (TMBadgeStore *)sharedStore;
- (TMBadge *)returnBadge;
- (void)increaseNumTasksWithinDeadline;
- (void)increaseNumTasksExceedDeadline;
- (BOOL)saveChanges;
@end
