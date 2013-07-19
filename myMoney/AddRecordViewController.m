//
//  AddRecordViewController.m
//  myMoney
//
//  Created by Администратор on 7/10/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "AddRecordViewController.h"

@interface AddRecordViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    Account *showingAccount; // for records list state
	Account *selectedAccount; // for add record state
}
@property (nonatomic, weak) IBOutlet UITextField *amountField;
@property (nonatomic, weak) IBOutlet UITextField *descriptionField;
@property (nonatomic, weak) IBOutlet UITextField *tagsField;
@property (nonatomic, weak) IBOutlet UIButton *activeAccountButton;

@end


@implementation AddRecordViewController

@synthesize addRecordView;
@synthesize accountHistoryView;
@synthesize amountField;
@synthesize descriptionField;
@synthesize tagsField;
@synthesize historyTableView;
@synthesize activeAccountButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *imageList = [UIImage imageNamed:@"reveal_menu_icon_portrait.png"];
    UIImage *imageSettings = [UIImage imageNamed:@"settings.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageList
																   landscapeImagePhone:nil
																				 style:UIBarButtonItemStylePlain
																				target:self
																				action:@selector(showLeftView:)];
    }
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageSettings
																	landscapeImagePhone:nil
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(showRightView:)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSArray *allAccounts = [[DatabaseController instance] accounts];
	if (allAccounts.count != 0){
		selectedAccount = allAccounts[0];
	}else{
		selectedAccount = nil;
	}
	[self updateAddRecordInterface];
}

-(void)updateAddRecordInterface
{
	if (selectedAccount != nil){
		[activeAccountButton setTitle:selectedAccount.name forState:UIControlStateNormal];
	}else{
		[activeAccountButton setTitle:@"Create account at first" forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)showRightView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.rightViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.rightViewController];
    }
}

-(void)showAccount:(Account *)account
{
    accountHistoryView.hidden = NO;
    addRecordView.hidden = YES;
    
    showingAccount = account;
    
    [historyTableView reloadData];
    
    [self showLeftView:nil];
}

-(void)showAddRecord
{
    accountHistoryView.hidden = YES;
    addRecordView.hidden = NO;
    
    [self showLeftView:nil];
}

-(void)createRecord:(id)sender
{
    CGFloat amount = [amountField.text floatValue];
    NSString *description = descriptionField.text;
    NSArray *tags = [[tagsField.text stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
    
    Record *record = [[Record alloc] initWithAmount:amount
                                        description:description
                                            andTags:tags];
    [selectedAccount createRecord:record];
	
	[amountField setText:@""];
	[descriptionField setText:@""];
	[tagsField setText:@""];
	
	[amountField resignFirstResponder];
	[descriptionField resignFirstResponder];
	[tagsField resignFirstResponder];
}

-(void)selectAccount:(id)sender
{
	UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 280, [UIScreen mainScreen].bounds.size.width, 280)];
	picker.dataSource = self;
	picker.delegate = self;
	[addRecordView addSubview:picker];
	[picker reloadAllComponents];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"reuseIDRecordsList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
		
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    Record *record = [showingAccount allRecords][indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f", record.amount];
    cell.detailTextLabel.text = record.description;
    
    if (record.isProfit){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else{
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[showingAccount allRecords] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return YES;
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[DatabaseController instance].accounts count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedAccount = [DatabaseController instance].accounts[row];
	[self updateAddRecordInterface];
	[pickerView removeFromSuperview];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	Account *account = [DatabaseController instance].accounts[row];
	return account.name;
}

@end
