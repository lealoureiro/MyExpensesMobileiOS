//
//  LoginViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 13/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "LoginViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [self.errorLabel setText:@""];
    [self.usernameBox setCenter:CGPointMake(self.view.center.x, self.usernameBox.center.y)];
    [self.passwordBox setCenter:CGPointMake(self.view.center.x, self.passwordBox.center.y)];
    [self.errorLabel setCenter:CGPointMake(self.view.center.x, self.errorLabel.center.y)];
}

- (IBAction)login:(id)sender {
    NSError *error;
    [self.errorLabel setText:@""];
    NSLog(@"Login %@ %@", self.usernameBox.text, self.passwordBox.text);
    NSString *authToken = [ExpensesCoreServerAPI loginWithUsername:self.usernameBox.text andPassword:self.passwordBox.text andError:&error];
    
    if (error != nil) {
        [self.errorLabel  setNumberOfLines:0];
        [self.errorLabel setText:@"Login Error!"];
    
    } else {
        ApplicationState *application = [ApplicationState getInstance];
        application.logged = YES;
        application.authToken = authToken;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:authToken forKey:@"authToken"];
        [defaults synchronize];
        NSLog(@"Saved token %@ in user defaults", authToken);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
