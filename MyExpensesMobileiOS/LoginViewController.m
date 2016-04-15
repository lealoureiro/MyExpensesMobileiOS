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
    NSString *key = [ExpensesCoreServerAPI loginWithUsername:self.usernameBox.text andPassword:self.passwordBox.text andError:&error];
    
    if (error != nil) {
        [self.errorLabel  setNumberOfLines:0];
        if (error.code == 0 || error.code == 400) {
           [self.errorLabel setText:@"Invalid credentials!"];
        } else {
            [self.errorLabel setText:@"Login error!"];
        }
    
    } else {
        ApplicationState *application = [ApplicationState getInstance];
        application.logged = YES;
        application.apiKey = key;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:key forKey:@"apiKey"];
        [defaults synchronize];
        NSLog(@"Saved token %@ in user defaults", key);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
