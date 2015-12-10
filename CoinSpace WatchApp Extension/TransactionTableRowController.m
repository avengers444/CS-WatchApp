//
//  TransactionTableRowController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 27.11.15.
//
//

#import "TransactionTableRowController.h"
#import "CommonData.h"

@interface TransactionTableRowController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *transactionDateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *balanceInfoLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleTransactionLabel;

@end

@implementation TransactionTableRowController

- (void)setTransactionInfo:(NSDictionary *)transactionInfo {
    NSNumber *tmpTimestamp = [transactionInfo objectForKey:@"timestamp"];
    NSTimeInterval tmpSeconds = [tmpTimestamp doubleValue] / 1000;
    NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:tmpSeconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd h:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:tmpDate];
    [_transactionDateLabel setText:dateString];
    
    NSNumber *amount = [transactionInfo objectForKey:@"amount"];
    if (amount.doubleValue < 0) {
        NSString *resultString = [NSString stringWithFormat:@"%@", [[CommonData shaderData] getBTCString:amount]];
        [_balanceInfoLabel setText:resultString];
        [_balanceInfoLabel setTextColor:[UIColor redColor]];
        
        NSArray *outsArray = [transactionInfo objectForKey:@"outs"];
        NSDictionary *outsDictionary = [outsArray objectAtIndex:0];
        
        [_titleTransactionLabel setText:[outsDictionary objectForKey:@"address"]];
    } else {
        [_balanceInfoLabel setText:[NSString stringWithFormat:@"+%@", [[CommonData shaderData] getBTCString:amount]]];
        [_balanceInfoLabel setTextColor:[UIColor greenColor]];
        
        [_titleTransactionLabel setText:@"Received"];
    }
}

@end
