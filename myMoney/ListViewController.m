//
//  ListViewController.m
//  myMoney
//
//  Created by Администратор on 7/10/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "ListViewController.h"
#import "MMAppDelegate.h"
#import "AddRecordViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	UITextField *accountNameField;
	UITextField *accountAmountField;
}

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
    static NSString *addRecordReuseID = @"addRecordReuseID";
    
    UITableViewCell *cell;
    
    switch ([indexPath section]) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:addRecordReuseID];
            
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addRecordReuseID];
            }
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
            cell.textLabel.text = @"Add record";
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            
            if (cell == nil){
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
            }
            
            Account *account = accounts[indexPath.row];
            cell.textLabel.text = account.name;
            cell.detailTextLabel.text = [@(account.amount) stringValue]; // amount
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:createAccountReuseID];
            
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:createAccountReuseID];
            }
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
            cell.textLabel.text = @"Create new account";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        case 1:
        {
            return [accounts count];
        }
            break;
            
        case 2:
        {
            return 1;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *navigationController = (UINavigationController *)((MMAppDelegate*)[UIApplication sharedApplication].delegate).viewController.frontViewController;
    AddRecordViewController *centerViewController = navigationController.viewControllers[0];
    
    switch ([indexPath section]) {
        case 0: // add record
        {
            [centerViewController showAddRecord];
        }
            break;
            
        case 1:
        {
            Account *account = accounts[indexPath.row];
            [centerViewController showAccount:account];
        }
            break;
            
        case 2: // create new account
        {
            if (accountNameField == nil || accountAmountField == nil){
                accountNameField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 35.0)];
                accountNameField.backgroundColor = [UIColor clearColor];
                accountNameField.textColor = [UIColor whiteColor];
                accountNameField.placeholder = @"Account name";
                
                accountAmountField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 35.0)];
                accountAmountField.backgroundColor = [UIColor clearColor];
                accountAmountField.textColor = [UIColor whiteColor];
                accountAmountField.placeholder = @"Account initial balance";
            }else{
                accountNameField.text = @"";
                accountAmountField.text = @"";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New account"
                                                            message:@" \n \n "
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Create", nil];
            
            [alert addSubview:accountNameField];
            [alert addSubview:accountAmountField];
            
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1){ // create account
		NSString *accountName = accountNameField.text;
		NSString *accountAmount = accountAmountField.text;
		
		Account *account = [[Account alloc] initWithName:accountName
											   andAmount:[accountAmount floatValue]];
        [[DatabaseController instance] createAccount:account];
		
		[self reloadDatasource];
        [accountsTableView reloadData];
	}
}

@end
