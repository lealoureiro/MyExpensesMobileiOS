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
#import <UNIRest.h>

@implementation ExpensesCoreServerAPI

+ (NSArray *)getUserAccounts:(NSString *)apiKey
{
    
    NSDictionary *headers = @{@"accept": @"application/json", @"authkey": apiKey};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"accounts/"];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    
    
    return response.body.array;
}

+ (NSDictionary *)getAccountInformation:(NSString *)account withApiKey:(NSString *)key
{
    
    NSLog(@"Getting information for account %@", account);
    NSDictionary *headers = @{@"accept": @"application/json", @"authkey": key};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"accounts/"];
    [resource appendString:account];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    
    
    return response.body.object;
}

+ (NSArray *)getAccountTransactions:(NSString *)account withApiKey:(NSString *)key {
    
    NSLog(@"Getting transactions for acount %@", account);
    
    NSDictionary *headers = @{@"accept": @"application/json", @"authkey": key};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"accounts/"];
    [resource appendString:account];
    [resource appendString:@"/transactions/"];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    
    
    return response.body.array;
}


+ (NSString *)loginWithUsername:(NSString *)username andPassword:(NSString *) password andError:(NSError**) error{
    
    NSDictionary *headers = @{@"accept": @"application/json", @"Content-type": @"application/json"};
    NSDictionary *parameters = @{@"username": username, @"password": password};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"keys/"];
    
    
    UNIHTTPJsonResponse *response = [[UNIRest postEntity:^(UNIBodyRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
        [request setBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    }] asJson];
    
    if (response.code != 200) {
        NSLog(@"Invalid response from the server %ld", (long)response.code);
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
        return nil;
    }
    
    return response.body.object[@"key"];
}

+ (NSString *)checkApiKey:(NSString *)apiKey andError:(NSError **) error
{
    *error = nil;
    NSDictionary *headers = @{@"Accept": @"application/json", @"authkey": apiKey};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"keys/"];
    
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 200) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
    
    return response.body.object[@"clientId"];
}



@end
