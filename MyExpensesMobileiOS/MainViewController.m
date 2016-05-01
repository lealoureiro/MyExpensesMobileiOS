//
//  MainViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 13/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "ApplicationState.h"
#import "ExpensesCoreServerAPI.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"apiKey"];
    NSLog(@"Loaded API Key from user defaults: %@", key);
    
    if (key == nil) {
        [self showLoginMenu];
    } else {
        NSError *error;
        [ExpensesCoreServerAPI checkApiKey:key andError:&error];
        if (error == nil) {
            ApplicationState *application = [ApplicationState getInstance];
            application.logged = YES;
            application.apiKey = key;
        } else {
            [self showLoginMenu];
        }
        
    }
}

- (void)showLoginMenu
{
    NSLog(@"Showing Login Screen...");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    loginViewController.view.frame = self.view.frame;
    [self presentViewController:loginViewController animated:YES completion:nil];
}


@end
