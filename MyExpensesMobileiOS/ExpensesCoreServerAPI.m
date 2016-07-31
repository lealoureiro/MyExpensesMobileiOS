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

+ (NSArray *)getUserAccounts:(NSString *)apiKey {
    
    if (apiKey == nil) {
        NSLog(@"Trying to call API with invalid key!");
        return [[NSArray alloc] init];
    }
    
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

+ (NSDictionary *)getAccountInformation:(NSString *)account withApiKey:(NSString *)key {
    
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

+ (NSString *)checkApiKey:(NSString *)apiKey andError:(NSError **) error {
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

+ (NSString *)addTransactionToAccount:(NSString *)account withDescription:(NSString *)description withAmount:(NSInteger)amountInCents withCategory:(NSString *)category withSubCategory:(NSString *)subCategory andAPIKey:(NSString *)key andError:(NSError **)error {
    
    double timetamp = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSDictionary *headers = @{@"accept": @"application/json", @"Content-type": @"application/json", @"authkey": key};
    NSDictionary *parameters = @{@"description": description,
                                 @"category": category,
                                 @"subCategory": subCategory,
                                 @"timestamp": [NSNumber numberWithDouble:timetamp],
                                 @"amount": [NSNumber numberWithInteger:amountInCents],
                                 @"externalReference": @"",
                                 @"tags": @""
                                 };
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"accounts/"];
    [resource appendString:account];
    [resource appendString:@"/transactions/"];
    
    UNIHTTPJsonResponse *response = [[UNIRest postEntity:^(UNIBodyRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
        [request setBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 200) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
    
    return response.body.object[@"id"];
}

+ (void)deleteTransaction:(NSString *)transactionId inAccount:(NSString *)accountId withTimestamp:(NSNumber *)timestamp andAPIKey:(NSString *)apikey andError:(NSError **)error {
   
    NSLog(@"Deleting transaction %@ in account %@", transactionId, accountId);
    
    NSDictionary *headers = @{@"authkey": apikey, @"Content-type": @"application/json"};
    NSDictionary *parameters = @{@"timestamp": timestamp};
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"accounts/"];
    [resource appendString:accountId];
    [resource appendString:@"/transactions/"];
    [resource appendString:transactionId];
    
    UNIHTTPResponse *response = [[UNIRest deleteEntity:^(UNIBodyRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
        [request setBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    }] asString];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 204) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
}


+ (NSArray *)getUserCategories:(NSString *)apiKey {
    
    NSLog(@"Getting user categories");
    
    if (apiKey == nil) {
        NSLog(@"Trying to call API with invalid key!");
        return [[NSArray alloc] init];
    }
    
    NSDictionary *headers = @{@"accept": @"application/json", @"authkey": apiKey};
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"categories/"];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    
    return response.body.array;
}

+ (void)addNewCategory:(NSString *)newCategory andAPIKey:(NSString *)key andError:(NSError **)error {
        
    NSDictionary *headers = @{@"accept": @"application/json", @"Content-type": @"application/json", @"authkey": key};
    NSDictionary *parameters = @{@"name": newCategory};
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"categories/"];
    
    UNIHTTPJsonResponse *response = [[UNIRest postEntity:^(UNIBodyRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
        [request setBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 204) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
    
}

+ (void)addNewSubCategory:(NSString *)newSubCategory forCategory:(NSString *)category andAPIKey:(NSString *)key andError:(NSError **)error {
    NSDictionary *headers = @{@"Content-type": @"application/json", @"authkey": key};
    NSDictionary *parameters = @{@"name": newSubCategory};
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"categories/"];
    [resource appendString:[category stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    [resource appendString:@"/subcategories/"];
    
    UNIHTTPJsonResponse *response = [[UNIRest postEntity:^(UNIBodyRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
        [request setBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 204) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
}


+ (void)deleteCategory:(NSString *)category andAPIKey:(NSString *)key andError:(NSError **)error {
    
    NSLog(@"Deleting category %@", category);
    
    NSDictionary *headers = @{@"authkey": key};
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"categories/"];
    [resource appendString:[category stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    UNIHTTPResponse *response = [[UNIRest delete:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 204) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }    
}

+ (void)deleteSubCategory:(NSString *)subCategory inCategory:(NSString*) category andAPIKey:(NSString *)key andError:(NSError **)error {
    NSLog(@"Deleting sub category %@ in category %@", subCategory, category);
    
    NSDictionary *headers = @{@"authkey": key};
    
    NSMutableString *resource = [[NSMutableString alloc] init];
    [resource appendString:WEBSERVICE_ADDRESS];
    [resource appendString:@"categories/"];
    [resource appendString:[category stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    [resource appendString:@"/subcategories/"];
    [resource appendString:[subCategory stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    UNIHTTPResponse *response = [[UNIRest delete:^(UNISimpleRequest *request) {
        [request setUrl:resource];
        [request setHeaders:headers];
    }] asJson];
    
    NSLog(@"Server HTTP response code %ld", (long)response.code);
    if (response.code != 204) {
        *error = [[NSError alloc] initWithDomain:@"network" code:response.code userInfo:nil];
    }
}



@end
