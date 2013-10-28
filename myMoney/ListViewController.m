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
#import "MMAccountCell.h"
#import "MMNewAccountCell.h"

#define kAccountCellReuseId @"reuseIdAccountCell"
#define kNewAccountCellReuseId @"reuseIdNewAccountCell"

@interface ListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *accounts;

@end


@implementation ListViewController

@synthesize collectionView = _collectionView;
@synthesize accounts = _accounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToUpdateAccountsList) name:kUpdateAccountsList object:nil];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"MMAccountCell" bundle:nil] forCellWithReuseIdentifier:kAccountCellReuseId];
	[self.collectionView registerNib:[UINib nibWithNibName:@"MMNewAccountCell" bundle:nil] forCellWithReuseIdentifier:kNewAccountCellReuseId];
}

-(void)viewDidUnload
{
	[super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)needToUpdateAccountsList
{
	_accounts = nil;
	[self accounts];
}

#pragma mark - Getters

-(NSArray *)accounts
{
	if (!_accounts)
	{
		_accounts = [DatabaseController instance].accounts;
	}
	
	return _accounts;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
		{
			return 1;
		}
			break;
			
		case 1:
		{
			return [self accounts].count;
		}
			break;
			
		default:
			return 0;
			break;
	}
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell;
	
	switch ([indexPath section]) {
		case 0:
		{
			cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewAccountCellReuseId forIndexPath:indexPath];
		}
			break;
			
		case 1:
		{
			cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAccountCellReuseId forIndexPath:indexPath];
			
			Account *account = self.accounts[indexPath.row];
			((MMAccountCell*)cell).titleLabel.text = account.name;
			((MMAccountCell*)cell).amountLabel.text = [@(account.amount) stringValue];
		}
			break;
			
		default:
			break;
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 2;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UITextField *topTextView = [alertView textFieldAtIndex:0];
	UITextField *bottomTextView = [alertView textFieldAtIndex:1];
	
	Account *account = [[Account alloc] initWithName:topTextView.text andAmount:bottomTextView.text.floatValue];
	[[DatabaseController instance] createAccount:account];
	
	[self needToUpdateAccountsList];
	[self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath section]) {
		case 0:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New account"
															message:@"Enter account name and initial balance"
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Create", nil];
			[alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
			
			UITextField *topTextView = [alert textFieldAtIndex:0];
			UITextField *bottomTextView = [alert textFieldAtIndex:1];
			
			[topTextView setPlaceholder:@"Account name"];
			
			[bottomTextView setPlaceholder:@"Initial balance"];
			[bottomTextView setSecureTextEntry:NO];
			
			[alert show];
		}
			break;
			
		default:
			break;
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UIView *view;
	
	switch ([indexPath section]) {
		case 0:
		{
			view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MMNewAccountCell class]) owner:self options:nil]objectAtIndex:0];
		}
			break;
			
		case 1:
		{
			view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MMAccountCell class]) owner:self options:nil]objectAtIndex:0];
		}
			break;
			
		default:
			break;
	}
	
	return view.frame.size;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//	
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//	
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//	
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//	
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//	
//}

@end
