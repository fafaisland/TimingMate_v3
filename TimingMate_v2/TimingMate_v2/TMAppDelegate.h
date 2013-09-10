//
//  TMAppDelegate.h
//  TimingMate_v2
//
//  Created by easonfafa on 6/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
