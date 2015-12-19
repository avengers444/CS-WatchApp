//
//  CommandMessage.h
//  CoinSpace
//
//  Created by Evgeniy Orlov on 12.12.15.
//
//

#import <Foundation/Foundation.h>

typedef enum CommandName: NSInteger {
    kBalance,
    kCurrency,
    kDefaultCurrency,
    kTransaction,
    kQr,
    kMectoError,
    kMectoResult,
    kMectoStatus
} CommandName;

#define Commands @"balanceMessage", @"currencyMessage", @"defaultCurrencyMessage", @"transactionMessage", @"qrMessage", @"mectoError", @"mectoResult", @"mectoStatus", nil

@interface CommandMessage : NSObject

@property CommandName command;
@property (strong, nonatomic) NSDictionary *messageValues;

- (id)initWithDictionary:(NSDictionary *)commandDictionary;

@end
