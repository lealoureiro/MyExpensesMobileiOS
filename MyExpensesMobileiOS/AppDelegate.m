//
//  AppDelegate.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "AppDelegate.h"
#import "NewTransactionViewController.h"
#import "NewTransactionFormViewController.h"
#import "AccountsViewController.h"
#import "ApplicationState.h"
#import "ExpensesCoreServerAPI.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.mainViewController = [[MainViewController alloc] init];
    
    NewTransactionFormViewController *vc = [[NewTransactionFormViewController alloc] init];
    NewTransactionViewController *vc1 = [[NewTransactionViewController alloc] initWithRootViewController:vc];
    
    AccountsViewController *accountsView = [[AccountsViewController alloc] init];
    accountsView.title = @"Accounts";
    UINavigationController *vc2 = [[UINavigationController alloc] initWithRootViewController:accountsView];
    UITabBarItem *barItem = [vc2 tabBarItem];
    barItem.image = [UIImage imageNamed:@"accounts"];
    
    NSArray *controllers = [NSArray arrayWithObjects:vc1, vc2, nil];
    self.mainViewController.viewControllers = controllers;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessfull)
                                                 name:@"loginSuccessful"
                                               object:nil];
    
    if (![self checkForAuthentication]) {
        [self showLoginMenu];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (BOOL)checkForAuthentication {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"apiKey"];
    NSLog(@"Loaded API Key from user defaults: %@", key);
    
    ApplicationState *application = [ApplicationState getInstance];
    if (key == nil) {
        application.logged = NO;
        return NO;
    } else {
        NSError *error;
        [ExpensesCoreServerAPI checkApiKey:key andError:&error];
        if (error == nil) {
            application.logged = YES;
            application.apiKey = key;
            return YES;
        } else {
            application.logged = NO;
            return NO;
        }
    }
}

- (void)showLoginMenu {
    NSLog(@"Showing Login Screen...");
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = loginViewController;
                    }
                    completion:nil];
}


- (void)loginSuccessfull {
    NSLog(@"Application logged successfully!");
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = mainViewController;
                    }
                    completion:nil];
}

@end
