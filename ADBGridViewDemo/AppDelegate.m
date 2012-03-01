//
//  ADBGridViewDemoAppDelegate.m
//  ADBGridViewDemo
//
//  Created by Alberto De Bortoli on 21/01/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowseViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // faces controller
    UIViewController *controller = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
    self.window.rootViewController = controller;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
