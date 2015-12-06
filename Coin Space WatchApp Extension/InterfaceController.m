//
//  InterfaceController.m
//  Coin Space WatchApp Extension
//
//  Created by Evgeniy Orlov on 21.11.15.
//
//

#import "InterfaceController.h"
#import "CommonData.h"

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *balanceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *sendButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *receiveButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *historyButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *tokensButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *updateBalanceButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *updatePriceButton;

@end


@implementation InterfaceController

static NSString *sendSegue = @"sendSegue";
static NSString *receiveSegue = @"receiveSegue";
static NSString *historyControllerId = @"historySegue";
static NSString *tokensSegue = @"tokensSegue";
static NSString *priceSelectionSegue = @"priceSelectionSegue";

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [[CommonData shaderData] initModule];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self configureView];
    
    NSString *selectedCurrency = [[CommonData shaderData] getSelectedCurrency];
    NSString *currencyPriceString = [[CommonData shaderData] getCurrencyPriceBySymbol:selectedCurrency];
    
    if (currencyPriceString != nil && ![currencyPriceString isEqualToString:@""]) {
        [_priceLabel setText:[NSString stringWithFormat:@"%@ %@", currencyPriceString, selectedCurrency]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrencyNotification:) name:@"currencyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBalanceNotification:) name:@"balanceNotification" object:nil];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currencyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"balanceNotification" object:nil];
}

- (void)onCurrencyNotification:(NSNotification *)notification {
    [_priceLabel setText:[[CommonData shaderData] getCurrencyString]];
}

- (void)onBalanceNotification:(NSNotification *)notification {
    [_balanceLabel setText:[[CommonData shaderData] getBalaneString]];
}

- (void)configureView {
    if ([[CommonData shaderData] getBalaneString] != nil) {
        [_balanceLabel setText:[NSString stringWithFormat:@"%@", [[CommonData shaderData] getBalaneString]]];
    } else {
        [_balanceLabel setText:@"Updating..."];
    }
    if ([[CommonData shaderData] getCurrencyString] != nil) {
        [_priceLabel setText:[NSString stringWithFormat:@"%@", [[CommonData shaderData] getCurrencyString]]];
    } else {
        [_priceLabel setText:@"Updating..."];
    }
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:sendSegue]) {
        
    } else if ([segueIdentifier isEqualToString:receiveSegue]) {
        
    } else if ([segueIdentifier isEqualToString:tokensSegue]) {
        
    } else {
        NSLog(@"unknown segue");
    }
    return nil;
}

- (IBAction)openPriceCurrency {
    [self requestPrice];
    if ([[CommonData shaderData] getCurrencyList].count > 0) {
        [self presentControllerWithName:@"PriceSelectionController" context:nil];
    } else {
        WKAlertAction *alertAction = [WKAlertAction actionWithTitle:@"Ok" style:WKAlertActionStyleDefault handler:^{
            
        }];
        [self presentAlertControllerWithTitle:@"Coin Space" message:@"Currency list is empty. Please update it from iPhone app" preferredStyle:WKAlertControllerStyleAlert actions:@[alertAction]];
    }
}

- (IBAction)openTransactionsController {
    if ([[CommonData shaderData] getTransactionsInfo].count > 0) {
        [self pushControllerWithName:historyControllerId context:nil];
    } else {
        WKAlertAction *alertAction = [WKAlertAction actionWithTitle:@"Ok" style:WKAlertActionStyleDefault handler:^{
            
        }];
        [self presentAlertControllerWithTitle:@"Coin Space" message:@"Transaction history is empty" preferredStyle:WKAlertControllerStyleAlert actions:@[alertAction]];
    }
}

- (IBAction)updateBalanceAction {
    [self requestBalance];
}

- (void)requestBalance {
    [[CommonData shaderData] sendMessage:@"updateBalance" queue:@"requestCommandQueue"];
}

- (void)requestPrice {
    [[CommonData shaderData] sendMessage:@"updatePrice" queue:@"requestCommandQueue"];
}

@end



