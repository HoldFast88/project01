//
//  DatabaseController.h
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "Record.h"
#import "Account.h"

@interface DatabaseController : NSObject
{
    @private
    sqlite3 *contactDB;
}

+(DatabaseController*)instance;


-(NSArray*)accounts;
-(void)saveAccounts:(NSArray*)accounts;

-(BOOL)createAccount:(Account*)account;

-(BOOL)createRecord:(Record*)record forAccount:(Account*)account;
-(void)removeRecord:(Record*)record forAccount:(Account*)account;

-(NSArray*)allRecordsForAccount:(Account*)account;
-(NSArray*)recordsWithTags:(NSArray*)tags forAccount:(Account*)account;

@end
