//
//  CommonData.h
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import <Foundation/Foundation.h>
#import "MMWormhole.h"
#import "MMWormholeSession.h"

@interface CommonData : NSObject {
    MMWormhole *wormhole;
    MMWormholeSession *watchConnectivityListeningWormhole;
    
    /// Currency container with prices
    NSDictionary *lastCurrencyDictionary;
    /// Balance string
    NSString *lastBalanceString;
    /// Currency string
    NSString *lastCurrencyString;
    /// Default currency value , USD, RUB and etc
    NSString *defaultCurrency;
    /// Selected currency for current session
    NSString *selectedCurrency;
    /// Transaction history
    NSArray *lastTransactionDictionary;
    
    BOOL isMectoOn;
}

+ (CommonData *)shaderData;

- (void)initModule;

/**
 Convert value to BTC and return NSString
 */
- (NSString *)getBTCString:(NSNumber *)amount;

/**
 Send message to iPhone with specified queue name
 */
- (void)sendMessage:(id)message queue:(NSString *)queueName;

- (void)saveData;

/**
 Return last balance string receiving from iPhone app
 */
- (NSString *)getBalaneString;

/**
 Return last currency price string
 */
- (NSString *)getCurrencyString;

/**
 Return selected currency for curreny session
 */
- (NSString *)getSelectedCurrency;

/**
 Set selected currency for current session
 */
- (void)setSelectedCurrency:(NSString *)currency;

/**
 Return current price for selected currency
 */
- (NSString *)getCurrencyPriceBySymbol:(NSString *)symbol;

/**
 Return all currency list
 */
- (NSArray *)getCurrencyList;

/**
 Return transactions info
 */
- (NSArray *)getTransactionsInfo;

- (void)setMecto:(BOOL)isOn;

- (BOOL)isMectoOn;

@end
