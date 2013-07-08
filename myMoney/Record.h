//
//  Record.h
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *tags;

-(id)initWithAmount:(double)amount description:(NSString*)description andTags:(NSArray*)tags;

-(BOOL)isProfit;

@end
