//
//  CommonData.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "CommonData.h"

@implementation CommonData

static CommonData *sharedData = nil;

+ (CommonData *)shaderData {
    @synchronized (self) {
        if (sharedData == nil) {
            sharedData = [[CommonData alloc] init];
        }
        return sharedData;
    }
}

- (void)initModule {
    watchConnectivityListeningWormhole = [MMWormholeSession sharedListeningSession];
    [watchConnectivityListeningWormhole activateSessionListening];
    
    defaultCurrency = @"USD";
    selectedCurrency = defaultCurrency;
    
    wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.coinspace.wallet-dev" optionalDirectory:nil transitingType:MMWormholeTransitingTypeSessionContext];

    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"balanceQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            NSString *balanceJson = (NSString *)[messageObject valueForKey:@"selectionString"];
            NSData *jsonData = [balanceJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *balanceDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            NSNumber *balance = [balanceDictionary valueForKey:@"balance"];
            NSString *denomination = [balanceDictionary valueForKey:@"denomination"];
            lastBalanceString = [NSString stringWithFormat:@"%@ %@", [self getBTCString:balance], denomination];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"balanceNotification" object:nil];
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"ratesQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            NSString *stringMessage = [messageObject valueForKey:@"selectionString"];
            NSData *jsonData = [stringMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *ratesDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                lastCurrencyDictionary = ratesDictionary;
                if (lastCurrencyDictionary.count > 0) {
                    if ([[lastCurrencyDictionary allKeys] containsObject:selectedCurrency]) {
                        lastCurrencyString = [NSString stringWithFormat:@"%@ %@", [lastCurrencyDictionary valueForKey:defaultCurrency], selectedCurrency];
                    } else {
                        defaultCurrency = [[lastCurrencyDictionary allKeys] objectAtIndex:0];
                        selectedCurrency = defaultCurrency;
                        lastCurrencyString = [NSString stringWithFormat:@"%@ %@", [lastCurrencyDictionary valueForKey:defaultCurrency], selectedCurrency];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"currencyNotification" object:nil];
                } else {
                    NSLog(@"");
                }
            }
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"defaultCurrencyChangedQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            defaultCurrency = (NSString *)[messageObject valueForKey:@"selectionString"];
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"transactionHistoryQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            NSString *transactionString = (NSString *)[messageObject valueForKey:@"selectionString"];
            NSData *jsonData = [transactionString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSArray *transactionDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                lastTransactionDictionary = transactionDictionary;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"transactionNotification" object:nil];
            }
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"qrQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            NSData *imgData;
            
            NSString *dataUrlImg = [messageObject valueForKey:@"selectionString"];
            NSRange range = [dataUrlImg rangeOfString:@";base64,"];
            if (range.location != NSNotFound) {
                NSRange removeRange = NSMakeRange(0, range.location + range.length);
                NSString *resultString = [dataUrlImg stringByReplacingCharactersInRange:removeRange withString:@""];
                imgData = [[NSData alloc] initWithBase64EncodedString:resultString options:0];
            } else {
                imgData = [[NSData alloc] initWithBase64EncodedString:dataUrlImg options:0];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qrCodeNotification" object:imgData];
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"mectoReceiveResult" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            
        } else {
            NSLog(@"unknown format");
        }
    }];
    
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"mectoErrorQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            isMectoOn = NO;
            NSString *errorString = [messageObject objectForKey:@"selectionString"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mectoErrorNotification" object:errorString];
        } else {
            NSLog(@"unknown format");
        }
    }];
}

- (NSString *)getBTCString:(NSNumber *)amount {
    amount = @([amount floatValue] / 100000000);
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[amount stringValue]];
    return [decimalNumber stringValue];
}

- (void)sendMessage:(id)message queue:(NSString *)queueName {
    [wormhole passMessageObject:message identifier:queueName];
}

- (void)saveData {
    
}

- (NSString *)getBalaneString {
    return lastBalanceString;
}

- (NSString *)getCurrencyString {
    return lastCurrencyString;
}

- (NSString *)getCurrencyPriceBySymbol:(NSString *)symbol {
    if ([lastCurrencyDictionary.allKeys containsObject:symbol]) {
        id currencyValue = [lastCurrencyDictionary valueForKey:symbol];
        if ([currencyValue isKindOfClass:[NSNumber class]]) {
            lastCurrencyString = [currencyValue stringValue];
        } else {
            lastCurrencyString = (NSString *)currencyValue;
        }
        return lastCurrencyString;
    } else {
        if (lastCurrencyString != nil) {
            return lastCurrencyString;
        } else {
            return @"";
        }
    }
}

- (NSString *)getSelectedCurrency {
    if (selectedCurrency == nil || [selectedCurrency isEqualToString:@""]) {
        return defaultCurrency;
    } else {
        return selectedCurrency;
    }
}

- (void)setSelectedCurrency:(NSString *)currency {
    selectedCurrency = currency;
}

- (NSArray *)getCurrencyList {
    if (lastCurrencyDictionary.count > 0) {
        return lastCurrencyDictionary.allKeys;
    } else {
        return nil;
    }
}

- (NSArray *)getTransactionsInfo {
    return lastTransactionDictionary;
}

- (void)setMecto:(BOOL)isOn {
    isMectoOn = isOn;
}

- (BOOL)isMectoOn {
    return isMectoOn;
}

@end
