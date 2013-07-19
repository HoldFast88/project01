//
//  Account.m
//  myMoney
//
//  Created by Администратор on 6/29/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "Account.h"

@interface Account ()

@property (nonatomic) CGFloat initialAmount;

@end


@implementation Account


@synthesize name = _name;
@synthesize amount = _amount;
@synthesize initialAmount;

-(id)initWithName:(NSString *)name andAmount:(CGFloat)amount
{
    self = [super init];
    if (self){
        _name = [[NSString alloc] initWithString:name];
		_amount = amount;
		initialAmount = amount;
    }
    return self;
}

-(NSString*)serviceName
{
    // !!! cannot start with number
    return [NSString stringWithFormat:@"Account%@", [_name stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

-(BOOL)createRecord:(Record*)record
{
	BOOL isSuccess = [[DatabaseController instance] createRecord:record forAccount:self];
	[self updateAmount];
	[[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAccountsList object:nil];
	
	return isSuccess;
}

-(void)removeRecord:(Record*)record
{
    [[DatabaseController instance] removeRecord:record forAccount:self];
	[self updateAmount];
	[[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAccountsList object:nil];
}

-(NSArray*)allRecords
{
	return [[DatabaseController instance] allRecordsForAccount:self];
}

-(NSArray*)recordsWithTags:(NSArray*)tags
{
    return [[DatabaseController instance] recordsWithTags:tags forAccount:self];
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        self.initialAmount = [aDecoder decodeFloatForKey:@"initAmount"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
		
		[self updateAmount];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.initialAmount forKey:@"initAmount"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

#pragma mark - Private methods

-(void)updateAmount
{
	self.amount = 0.0;
	NSArray *records = [self allRecords];
	for (Record *record in records){
		self.amount += record.amount;
	}
}

@end
