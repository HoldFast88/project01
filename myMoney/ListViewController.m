//
//  ListViewController.m
//  myMoney
//
//  Created by Администратор on 7/10/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *accounts;

@end


@implementation ListViewController

@synthesize accountsTableView;
@synthesize accounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createObjects];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self){
        [self createObjects];
    }
    return self;
}

- (void)createObjects
{
    accounts = [[NSMutableArray alloc] init];
    [self reloadDatasource];
}

- (void)reloadDatasource
{
    [accounts removeAllObjects];
    [accounts addObjectsFromArray:[DatabaseController instance].accounts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"reuseID";
    static NSString *createAccountReuseID = @"createAccountReuseID";
    
    BOOL isAccountCell = [indexPath row] < [accounts count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:isAccountCell ? reuseID : createAccountReuseID];
    if (cell == nil){
        if (isAccountCell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:createAccountReuseID];
        }
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (isAccountCell){
        Account *account = accounts[indexPath.row];
        cell.textLabel.text = account.name;
        cell.detailTextLabel.text = [@(account.amount) stringValue]; // amount
    }else{
        cell.textLabel.text = @"Create new account";
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accounts count] + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath row] == [accounts count]){ // create new account
        /////
        static int counter = 0;
        Account *account = [[Account alloc] initWithName:[NSString stringWithFormat:@"sdfsdf%d", counter]];
        [[DatabaseController instance] createAccount:account];
        counter++;
        /////
        
        [self reloadDatasource];
        [accountsTableView reloadData];
    }
}

@end
