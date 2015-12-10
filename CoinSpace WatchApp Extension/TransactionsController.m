//
//  TransactionsController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 27.11.15.
//
//

#import "TransactionsController.h"
#import "CommonData.h"

@interface TransactionsController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *transactionsTable;
@property (weak, nonatomic) NSDictionary *selectedTransaction;

@end

@implementation TransactionsController

static NSString *segueDetail = @"transactionDetailSegue";

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setTitle:@"Transactions"];
    [[CommonData shaderData] sendMessage:@"transactionHistory" queue:@"requestCommandQueue"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionNotification:) name:@"transactionNotification" object:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loadData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)transactionNotification:(NSNotification *)noti {
    [self loadData];
}

- (void)loadData {
    NSArray *tmpTransactions = [[CommonData shaderData] getTransactionsInfo];
    
    [_transactionsTable setNumberOfRows:tmpTransactions.count withRowType:@"TransactionRow"];
    
    int index = 0;
    for (NSDictionary *transactionDictionary in tmpTransactions) {
        TransactionTableRowController *row = [_transactionsTable rowControllerAtIndex:index];
        [row setTransactionInfo:transactionDictionary];
        index++;
    }
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    if ([segueIdentifier isEqualToString:segueDetail]) {
        _selectedTransaction = [[[CommonData shaderData] getTransactionsInfo] objectAtIndex:rowIndex];
        return _selectedTransaction;
    } else {
        return nil;
    }
}

@end