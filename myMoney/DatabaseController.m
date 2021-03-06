//
//  DatabaseController.m
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "DatabaseController.h"
#import "NSArray+convert.h"

#define kAccounts @"accounts"
#define dbFileName @"database.db"

@interface DatabaseController ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end


@implementation DatabaseController

@synthesize defaults;

+(DatabaseController *)instance
{
    static DatabaseController *instance_;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance_ = [[DatabaseController alloc] init];
    });
    
    return instance_;
}

-(id)init
{
    self = [super init];
    if (self){
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(NSArray *)accounts
{
    NSData *rawData = [defaults objectForKey:kAccounts];
    if (rawData != nil){
        return [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    }else{
        return @[];
    }
}

-(void)saveAccounts:(NSArray *)accounts
{
    NSData *rawData = [NSKeyedArchiver archivedDataWithRootObject:accounts];
    [defaults setObject:rawData forKey:kAccounts];
    [defaults synchronize];
}

-(void)saveAccount:(Account *)account
{
    NSData *rawData = [defaults objectForKey:kAccounts];
    NSArray *accountsList;
    if (rawData){
        accountsList = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    }else{
        accountsList = @[];
    }
    
    NSMutableArray *mutableAccountsList = [NSMutableArray arrayWithArray:accountsList];
    [mutableAccountsList addObject:account];
    
    [self saveAccounts:mutableAccountsList];
}

-(BOOL)createAccount:(Account*)account
{
    const char *dbpath = GetDatabasePath();
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        char *errMsg;
        NSString *nameString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, AMOUNT TEXT, DESCRIPTION TEXT, DATE INTEGER, TAGS TEXT)", [account serviceName]];
        
        const char *sql_stmt = [nameString UTF8String];
        
        int executionState = sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg);
        
        if (executionState != SQLITE_OK){
            NSLog(@"Failed to create table");
            return NO;
        }
        sqlite3_close(contactDB);
    } else {
        NSLog(@"Failed to open/create database");
        return NO;
    }
    
    [self saveAccount:account];
    
    return YES;
}

-(BOOL)createRecord:(Record *)record forAccount:(Account*)account
{
    BOOL success = NO;
    
    const char *dbpath = GetDatabasePath();
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *tagsString = [[record tags] commaSeparatedValuesString];
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO %@ (amount, description, date, tags) VALUES (\"%@\", \"%@\", \"%f\", \"%@\")", [account serviceName], [@(record.amount) stringValue], record.description, [record.date timeIntervalSinceReferenceDate], tagsString];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = YES;
        } else {
            success = NO;
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    return success;
}

-(void)removeRecord:(Record *)record forAccount:(Account*)account
{
//    DELETE FROM table_name WHERE some_column=some_value;
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id=%d", [account serviceName], record.ID];
    
    sqlite3_stmt *statement;
    
    const char *dbpath = GetDatabasePath();
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE){
            NSLog(@"Failed to delete record");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

-(NSArray *)allRecordsForAccount:(Account*)account
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", [account serviceName]];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    
    const char *query_stmt = [query UTF8String];
    const char *dbpath = GetDatabasePath();
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int recordId = sqlite3_column_int(statement, 0);
            
            double amountField = sqlite3_column_double(statement, 1);
            
            NSString *descriptionField = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
            
            NSTimeInterval dateField = sqlite3_column_int(statement, 3);
            
            NSString *tagsField = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 4)];
            
            Record *record = [[Record alloc] initWithAmount:amountField
                                                description:descriptionField
                                                    andTags:[NSArray arrayFromStringCommaSeparatedValues:tagsField]];
            record.date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateField];
            record.ID = recordId;
            
            [records addObject:record];
        }
        
        sqlite3_finalize(statement);
    }
    
    return records;
}

-(NSArray *)recordsWithTags:(NSArray *)tags forAccount:(Account*)account
{
//    SELECT * FROM users WHERE (instr(tags, 'tag2') > 0) AND (instr(tags, 'tag1') > 0) 
	
    if (tags.count == 0){
        return @[];
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE", [account serviceName]];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    for (NSString *tag in tags){
        int index = [tags indexOfObject:tags];
        if (index == 0){
            query = [query stringByAppendingFormat:@" (instr(tags, %@%@%@) > 0)", @"'%", tag, @"%'"];
        } else {
            query = [query stringByAppendingFormat:@" AND (instr(tags, %@%@%@) > 0)", @"'%", tag, @"%'"];
        }
    }
    
    sqlite3_stmt *statement = nil;
    
    const char *query_stmt = [query UTF8String];
    
    const char *dbpath = GetDatabasePath();
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            double amountField = sqlite3_column_double(statement, 0);
            
            NSString *descriptionField = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
            
            NSTimeInterval dateField = sqlite3_column_int(statement, 2);
            
            NSString *tagsField = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
            
            Record *record = [[Record alloc] initWithAmount:amountField
                                                description:descriptionField
                                                    andTags:[NSArray arrayFromStringCommaSeparatedValues:tagsField]];
            record.date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateField];
            
            [records addObject:record];
        }
    }
    
    sqlite3_finalize(statement);
    
    return records;
}

#pragma mark Helpers

const char *GetDatabasePath()
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databaseFileName = dbFileName;
    NSString *databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:databaseFileName]];
    const char *dbpath = [databasePath UTF8String];
    
    return dbpath;
}

@end
