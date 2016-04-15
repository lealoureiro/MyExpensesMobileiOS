//
//  ApplicationState.h
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 15/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationState : NSObject {
    BOOL logged;
    NSString *apiKey;
}

@property (nonatomic) BOOL logged;
@property (nonatomic, retain) NSString *apiKey;

+(ApplicationState *)getInstance;


@end
