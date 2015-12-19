//
//  CommonData.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "CommonData.h"
#import "CommandMessage.h"

@implementation CommonData

static CommonData *sharedData = nil;

+ (CommonData *)shaderData {
    @synchronized (self) {
        if (sharedData == nil) {
            sharedData = [[CommonData alloc] init];
            
            [sharedData subscribe];
        }
        return sharedData;
    }
}

- (void)subscribe {
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coinspace.wallet"];
    [userDefaults synchronize];
    
    selectedWalletId = [self loadData:kWalletId];
    
    watchConnectivityListeningWormhole = [MMWormholeSession sharedListeningSession];
    [watchConnectivityListeningWormhole activateSessionListening];
    
    wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.coinspace.wallet" optionalDirectory:nil transitingType:
                MMWormholeTransitingTypeSessionContext];
    [watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"comandAnswerQueue" listener:^(id  _Nullable messageObject) {
        if ([messageObject isKindOfClass:[NSDictionary class]]) {
            NSString *messageString = [messageObject valueForKey:@"selectionString"];
            NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dictionaryMessage = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                CommandMessage *commandMessage = [[CommandMessage alloc] initWithDictionary:dictionaryMessage];
                
                switch (commandMessage.command) {
                    case kBalance: {
                        NSNumber *balance = [commandMessage.messageValues valueForKey:@"balance"];
                        NSString *denomination = [commandMessage.messageValues valueForKey:@"denomination"];
                        NSString *balanceWalletId = [commandMessage.messageValues valueForKey:@"walletId"];
                        
                        if (![balanceWalletId isEqualToString:selectedWalletId]) {
                            selectedWalletId = balanceWalletId;
                        }
                        
                        [self saveData:kBalanceData withValue:[self getBTCString:balance]];
                        [self saveData:kDenomination withValue:denomination];
                        
                        lastBalanceString = [NSString stringWithFormat:@"%@ %@", [self getBTCString:balance], denomination];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"balanceNotification" object:nil];
                    }
                        break;
                    case kCurrency: {
                        NSDictionary *currencyDictionary = [commandMessage.messageValues valueForKey:@"currency"];
                        if (currencyDictionary.count > 0) {
                            lastCurrencyDictionary = currencyDictionary;
                            
                            [self saveData:kCurrencyData withValue:lastCurrencyDictionary];
                            
                            if ([[lastCurrencyDictionary allKeys] containsObject:selectedCurrency]) {
                                lastCurrencyString = [NSString stringWithFormat:@"%@", [lastCurrencyDictionary valueForKey:selectedCurrency]];
                            } else {
                                defaultCurrency = [[lastCurrencyDictionary allKeys] objectAtIndex:0];
                                selectedCurrency = defaultCurrency;
                                lastCurrencyString = [NSString stringWithFormat:@"%@", [lastCurrencyDictionary valueForKey:selectedCurrency]];
                                
                                [self saveData:kDefaultSelectedCurrency withValue:selectedCurrency];
                            }
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"currencyNotification" object:nil];
                        } else {
                            NSLog(@"currency dictionary is empty");
                        }
                    }
                        break;
                    case kDefaultCurrency: {
                        defaultCurrency = [commandMessage.messageValues valueForKey:@"defaultCurrency"];
                        [self saveData:kDefaultUsedCurrency withValue:defaultCurrency];
                    }
                        break;
                    case kTransaction: {
                        lastTransactionDictionary = [commandMessage.messageValues objectForKey:@"transactions"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"transactionNotification" object:nil];
                    }
                        break;
                    case kQr: {
                        NSData *imgData;
                        
                        NSString *lastSavedQr = [self loadData:kQRData];
                        NSString *walletId = [commandMessage.messageValues valueForKey:@"address"];
                        NSString *dataUrlImg = [commandMessage.messageValues valueForKey:@"qr"];
                        NSRange range = [dataUrlImg rangeOfString:@";base64,"];
                        if (range.location != NSNotFound) {
                            NSRange removeRange = NSMakeRange(0, range.location + range.length);
                            NSString *resultString = [dataUrlImg stringByReplacingCharactersInRange:removeRange withString:@""];
                            imgData = [[NSData alloc] initWithBase64EncodedString:resultString options:0];
                            
                            if (![walletId isEqualToString:selectedWalletId]) {
                                [self saveData:kQRData withValue:resultString];
                            } else {
                                if (lastSavedQr == nil || ![lastSavedQr isEqualToString:resultString]) {
                                    [self saveData:kQRData withValue:resultString];
                                }
                            }
                        } else {
                            imgData = [[NSData alloc] initWithBase64EncodedString:dataUrlImg options:0];
                            
                            if (![walletId isEqualToString:selectedWalletId]) {
                                [self saveData:kQRData withValue:dataUrlImg];
                            } else {
                                if (lastSavedQr == nil || ![lastSavedQr isEqualToString:dataUrlImg]) {
                                    [self saveData:kQRData withValue:dataUrlImg];
                                }
                            }
                        }
                        
                        [self saveData:kWalletId withValue:walletId];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qrCodeNotification" object:imgData];
                    }
                        break;
                    case kMectoError: {
                        if (isMectoOn == YES) {
                            NSString *errorString = [commandMessage.messageValues valueForKey:@"errorString"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"mectoErrorNotification" object:errorString];
                        }
                        isMectoOn = NO;
                    }
                        break;
                    case kMectoResult: {
                        
                    }
                        break;
                    case kMectoStatus: {
                        NSString *mectoStatus = [commandMessage.messageValues valueForKey:@"status"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastMectoStatus" object:mectoStatus];
                    }
                        break;
                    default:
                        break;
                }
            }
        } else {
            NSLog(@"unknown format");
        }
    }];
}

- (void)initModule {
    defaultCurrency = @"USD";
    selectedCurrency = [self loadData:kDefaultSelectedCurrency];
    if (selectedCurrency == nil || [selectedCurrency isEqualToString:@""]) {
        selectedCurrency = defaultCurrency;
        [self saveData:kDefaultSelectedCurrency withValue:selectedCurrency];
    }
    
    lastCurrencyDictionary = [self loadData:kCurrencyData];
}

- (NSString *)getBTCString:(NSNumber *)amount {
    amount = @([amount floatValue] / 100000000);
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[amount stringValue]];
    return [decimalNumber stringValue];
}

- (void)sendMessage:(id)message queue:(NSString *)queueName {
    [wormhole passMessageObject:message identifier:queueName];
}

- (void)saveData:(SaveType)kSaveType withValue:(id)value {
    NSString *saveKey = [NSString stringWithFormat:@"%d", kSaveType];
    [userDefaults setObject:value forKey:saveKey];
    
    if (kSaveType == kCurrencyData) {
        NSDate *currentDate = [NSDate date];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd h:mm a"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];

        [userDefaults setObject:dateString forKey:[NSString stringWithFormat:@"%d", kLastCurrencyDate]];
    }
    
    [userDefaults synchronize];
}

- (id)loadData:(SaveType)kSaveType {
    NSString *loadKey = [NSString stringWithFormat:@"%d", kSaveType];
    return [userDefaults objectForKey:loadKey];
}

- (NSString *)getBalaneString {
    if (lastBalanceString == nil || lastBalanceString.length == 0) {
        NSString *balance = [self loadData:kBalanceData];
        NSString *denomination = [self loadData:kDenomination];
        
        if (balance != nil && denomination != nil) {
            lastBalanceString = [NSString stringWithFormat:@"%@ %@", balance, denomination];
        } else {
            return nil;
        }
    }
    
    return lastBalanceString;
}

- (NSString *)getCurrencyString {
    if (lastCurrencyString == nil) {
        NSString *priceValue = [self getCurrencyPriceBySymbol:selectedCurrency];
        if (priceValue != nil) {
            lastCurrencyString = [NSString stringWithFormat:@"%@ %@", priceValue, selectedCurrency];
        }
    }
    return lastCurrencyString;
}

- (NSString *)getCurrencyPriceBySymbol:(NSString *)symbol {
    if ([lastCurrencyDictionary.allKeys containsObject:symbol]) {
        id currencyValue = [lastCurrencyDictionary valueForKey:symbol];
        if ([currencyValue isKindOfClass:[NSNumber class]]) {
            return [currencyValue stringValue];
        } else {
            return (NSString *)currencyValue;
        }
    }
    return nil;
}

- (NSString *)getSelectedCurrency {
    if (selectedCurrency == nil || [selectedCurrency isEqualToString:@""]) {
        selectedCurrency = defaultCurrency;
        
        [self saveData:kDefaultSelectedCurrency withValue:selectedCurrency];
        
        return defaultCurrency;
    } else {
        return selectedCurrency;
    }
}

- (void)setSelectedCurrency:(NSString *)currency {
    selectedCurrency = currency;
    [self saveData:kDefaultSelectedCurrency withValue:currency];
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

- (NSString *)getSelectedWalletId {
    return selectedWalletId;
}

- (NSString *)getFullCurrencyInfo {
    return [NSString stringWithFormat:@"%@ %@", [self getCurrencyPriceBySymbol:selectedCurrency], selectedCurrency];
}

@end
