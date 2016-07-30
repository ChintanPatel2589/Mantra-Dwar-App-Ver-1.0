//
//  AppDelegate.m
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/18/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    ViewController *viewController =
    [[UIStoryboard storyboardWithName:@"Main"
                               bundle:NULL] instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *rootNavigation = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    self.window.rootViewController = rootNavigation;
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark Local Notification handle Methods
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    //[[UIApplication sharedApplication]cancelAllLocalNotifications];
    app.applicationIconBadgeNumber = 0;
    notif.soundName = UILocalNotificationDefaultSoundName;
    [self openAppWithPlaySong];
    
}
-(void)openAppWithPlaySong
{
    PlayMantraViewController *viewController = [[UIStoryboard storyboardWithName:@"Main"
                                                                          bundle:NULL] instantiateViewControllerWithIdentifier:@"PlayMantraViewController"];
    viewController.selectedMantra = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedMantra"];
    viewController.isFromNotification = true;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
#pragma mark Alert Methods
-(void)alert:(NSString *)title msg :(NSString *)msg alertTag:(int)tag cancelTitile:(NSString *)cancelTitle okTitle:(NSString *)okTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alert.delegate = self;
    alert.tag = tag;
    [alert show];
    alert = nil;
}

@end
