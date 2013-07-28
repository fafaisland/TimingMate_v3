//
//  TMTaskStore.h
//  TimingMate_v2
//
//  Created by easonfafa on 6/28/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMTask;
@class TMListItem;

@interface TMTaskStore:NSObject
{
    NSMutableArray *allTasks;
}

+ (TMTaskStore *)sharedStore;
- (NSArray *)returnAllTasks;
- (TMTask *)createTaskWithTitle:(NSString *)taskTitle list:(TMListItem *)list allowedTime:(double)allowedTime;
- (TMTask *)updateTask:(TMTask *)task withTitle:(NSString *)taskTitle withList:(TMListItem *)list allowedTime:(double)allowedTime;
- (BOOL)updateTaskToggleFinished:(TMTask *)task;
- (TMTask *)updateTask:(TMTask *)task withTotalTimeSpent:(double)totalSpentTime;
- (void)removeTask:(TMTask *)task;
- (NSString *)taskArchivePath;
- (BOOL)saveChanges;
@end