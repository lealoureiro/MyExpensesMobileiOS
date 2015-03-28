//
//  ExpensesCoreServerAPI.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpensesCoreServerAPI.h"
#import "GlobalSettings.h"



@implementation ExpensesCoreServerAPI

+ (NSArray *)getUserAccounts:(NSString *)authToken
{
    
    NSString *params = [[NSString alloc] initWithFormat:@"token=%@", authToken];
    NSMutableString *webserviceAddress = [[NSMutableString alloc] init];
    [webserviceAddress appendString:WEBSERVICE_ADDRESS];
    [webserviceAddress appendString:@"expenses/get_accounts"];
    NSURL *serverUrl = [NSURL URLWithString:webserviceAddress];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:serverUrl cachePolicy: NSURLRequestReloadIgnoringCacheData  timeoutInterval:3];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if ([httpResponse statusCode] != 200) {
        NSLog(@"Invalid response from the server %d", [httpResponse statusCode]);
    }
    
    error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&error];
    
    return object;
}

+ (NSString *)loginWithUsername:(NSString *)username withPassword:(NSString *) password andError:(NSError**) error{
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
    NSMutableString *webserviceAddress = [[NSMutableString alloc] init];
    [webserviceAddress appendString:WEBSERVICE_ADDRESS];
    [webserviceAddress appendString:@"auth/login"];
    NSURL *serverUrl = [NSURL URLWithString:webserviceAddress];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:serverUrl cachePolicy: NSURLRequestReloadIgnoringCacheData  timeoutInterval:3];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    
    if (requestError != nil) {
        NSLog(@"%@", requestError);
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if ([httpResponse statusCode] != 200) {
        NSLog(@"Invalid response from the server %d", [httpResponse statusCode]);
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Invalid credentials!" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"serverRequest" code:1 userInfo:details];
        return nil;
    }
    
    requestError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&requestError];
    
    return object[@"token"];
}


@end
