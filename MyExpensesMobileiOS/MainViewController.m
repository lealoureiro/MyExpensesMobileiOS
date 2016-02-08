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

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authToken = [defaults objectForKey:@"authToken"];
    NSLog(@"Loaded token from user defaults: %@", authToken);
    
    if (authToken == nil) {
        [self showLoginMenu];
    } else {
        // token should validated first...
        ApplicationState *application = [ApplicationState getInstance];
        application.logged = YES;
        application.authToken = authToken;
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
