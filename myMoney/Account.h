//
//  Account.h
//  myMoney
//
//  Created by Администратор on 6/29/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic) CGFloat amount;


-(id)initWithName:(NSString *)name andAmount:(CGFloat)amount;

-(BOOL)createRecord:(Record*)record;
-(void)removeRecord:(Record*)record;

-(NSArray*)allRecords;
-(NSArray*)recordsWithTags:(NSArray*)tags;

-(NSString*)serviceName;


@end
