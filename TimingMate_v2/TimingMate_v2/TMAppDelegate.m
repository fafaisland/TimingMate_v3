//
//  TMAppDelegate.m
//  TimingMate_v2
//
//  Created by easonfafa on 6/24/13.
//  Copyright (c) 2013 fafa. All rights reserved.
//

#import "TMAppDelegate.h"
#import "TMGlobal.h"
#import "TMTaskViewController.h"
#import "TMListViewController.h"
#import "DDMenuController.h"
#import "TMListStore.h"
#import "TMTaskStore.h"
#import "TMBadgeStore.h"
#import "TMViewControllerStore.h"

@implementation TMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /*TMTaskViewController *tmtvc = [[TMTaskViewController alloc] init];
    
    DDMenuController *menuController = [[DDMenuController alloc] initWithRootViewController:tmtvc];
    TMListViewController *tmlvc = [[TMListViewController alloc] init];
    menuController.leftViewController = tmlvc;
    */
    DDMenuController *menuController = [[TMViewControllerStore sharedStore] returnMenuController];
    [[self window] setRootViewController:menuController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //notification center
    TMViewControllerStore *controllerStore = [TMViewControllerStore sharedStore];
    TMTaskViewController *tvc = [controllerStore returnTMtvc];
    if ([tvc returnIsTiming]==true && [tvc returnIsPaused]==false){
        int timeInterval = [tvc returnTimeLeftTo30min];
        NSLog(@"Time intervals %d seconds",timeInterval);
        
        NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:timeInterval];
        UIApplication* app = [UIApplication sharedApplication];
        UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
        if (notifyAlarm)
        {
            notifyAlarm.fireDate = alertTime;
            notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
            notifyAlarm.repeatInterval = 0;
            notifyAlarm.soundName = @"notify_sound.aiff";
            notifyAlarm.alertBody = @"30 Minutes Elapsed";
            
            [app scheduleLocalNotification:notifyAlarm];
        }

    }
        
    //store data
       [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    BOOL successList = [[TMListStore sharedStore] saveChanges];
    BOOL successTask = [[TMTaskStore sharedStore] saveChanges];
    BOOL successBadge = [[TMBadgeStore sharedStore] saveChanges];
    if (successList)
    {
        NSLog(@"Saved all of the TMLists");
    }else{
        NSLog(@"Could not save any of the TMLists");
    }
    
    if (successTask)
    {
        NSLog(@"Saved all of the TMTasks");
    }else{
        NSLog(@"Could not save any of the TMTasks");
    }
    
    if (successBadge){
        NSLog(@"Saved the Badges");
    }else{
        NSLog(@"Could not save the badges");
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
