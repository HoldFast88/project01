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
    
    BOOL isAccountCell = [indexPath row] < [accounts count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:isAccountCell ? reuseID : createAccountReuseID];
    if (cell == nil){
        if (isAccountCell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:createAccountReuseID];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.698 green:0.525 blue:0.0 alpha:0.3]; // 0.698,0.525,0.529
    }
    
    if (isAccountCell){
        Account *account = accounts[indexPath.row];
        cell.textLabel.text = account.name;
        cell.detailTextLabel.text = [@(account.amount) stringValue]; // amount
    }else{
		[cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
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
    }else{
        // selected account
        Account *account = accounts[indexPath.row];
        
        UINavigationController *navigationController = (UINavigationController *)((MMAppDelegate*)[UIApplication sharedApplication].delegate).viewController.frontViewController;
        AddRecordViewController *centerViewController = navigationController.viewControllers[0];
        
        [centerViewController showAccount:account];
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
