//
//  Angels2011AppDelegate.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "Angels2011AppDelegate.h"
#import "TeamsTableViewController.h"
#import "AllPlayersTableViewController.h"
#import "AllCoachesTableViewController.h"
#import "CalendarTableViewController.h"
//#import "CountdownToOmahaViewController.h"
#import "WebViewController.h"
//#import "LottaRows2ViewController.h"

@implementation Angels2011AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *nav1 = [[UINavigationController alloc] init];
    TeamsTableViewController *ttvc = [[TeamsTableViewController alloc] init];
    [nav1 pushViewController:ttvc animated:YES];

    UINavigationController *nav2 = [[UINavigationController alloc] init];
    AllPlayersTableViewController *aptvc = [[AllPlayersTableViewController alloc] init];
    [nav2 pushViewController:aptvc animated:YES];
    
    UINavigationController *nav3 = [[UINavigationController alloc] init];
    AllCoachesTableViewController *actvc = [[AllCoachesTableViewController alloc] init];
    [nav3 pushViewController:actvc animated:YES];
    
    UINavigationController *nav4 = [[UINavigationController alloc] init];
    CalendarTableViewController *ctvc = [[CalendarTableViewController alloc] init];
    [nav4 pushViewController:ctvc animated:YES];
    
//    UINavigationController *nav5 = [[UINavigationController alloc] init];
//    CountdownToOmahaViewController *ctovc = [[CountdownToOmahaViewController alloc] init];
//    [nav5 pushViewController:ctovc animated:YES];
    
//    UINavigationController *nav6 = [[UINavigationController alloc] init];
//    LottaRows2ViewController *lvc = [[LottaRows2ViewController alloc] init];
//    [nav6 pushViewController:lvc animated:YES];

    [ttvc release]; [aptvc release]; [actvc release]; [ctvc release]; /*[ctovc release]; [lvc release];*/
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, /*nav5, nav6,*/ nil];

    [_window addSubview:tbc.view];
    [nav1 release]; [nav2 release]; [nav3 release]; [nav4 release]; //[nav5 release]; //causes crash [tbc release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
