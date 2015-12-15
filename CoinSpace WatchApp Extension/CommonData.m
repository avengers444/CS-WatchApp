//
//  CommonData.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "CommonData.h"
#import "CommandMessage.h"

#define kUDBalance @"kBalance"
#define kUDCurrency @"kCurrency"
#define kUDQRCode @"kQRCode"

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
                MMWormholeTransitingTypeSessionMessage];
    
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
                        lastCurrencyDictionary = [commandMessage.messageValues valueForKey:@"currency"];
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
                        break;
                    case kDefaultCurrency: {
                        defaultCurrency = [commandMessage.messageValues valueForKey:@"defaultCurrency"];
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
    if (selectedCurrency == nil || [selectedCurrency isEqualToString:@""]) {
        selectedCurrency = defaultCurrency;
    }
}

- (NSString *)getBTCString:(NSNumber *)amount {
    amount = @([amount floatValue] / 100000000);
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[amount stringValue]];
    return [decimalNumber stringValue];
}

- (void)sendMessage:(id)message queue:(NSString *)queueName {
    [wormhole passMessageObject:message identifier:queueName];
}

- (void)saveData:(SaveType)kSaveType withValue:(NSString *)value {
    switch (kSaveType) {
        case kBalanceData:
            [userDefaults setValue:value forKey:[NSString stringWithFormat:@"%d", kBalanceData]];
            break;
        case kDenomination:
            [userDefaults setValue:value forKey:[NSString stringWithFormat:@"%d", kDenomination]];
            break;
        case kCurrencyData:
            [userDefaults setValue:value forKey:[NSString stringWithFormat:@"%d", kCurrencyData]];
            break;
        case kQRData:
            [userDefaults setValue:value forKey:[NSString stringWithFormat:@"%d", kQRData]];
            break;
        case kWalletId:
            [userDefaults setValue:value forKey:[NSString stringWithFormat:@"%d", kWalletId]];
            break;
        default:
            break;
    }
    [userDefaults synchronize];
}

- (NSString *)loadData:(SaveType)kSaveType {
    switch (kSaveType) {
        case kBalanceData:
            return [userDefaults valueForKey:[NSString stringWithFormat:@"%d", kBalanceData]];
            break;
        case kDenomination:
            return [userDefaults valueForKey:[NSString stringWithFormat:@"%d", kDenomination]];
            break;
        case kCurrencyData:
            return [userDefaults valueForKey:[NSString stringWithFormat:@"%d", kCurrencyData]];
            break;
        case kQRData:
            return [userDefaults valueForKey:[NSString stringWithFormat:@"%d", kQRData]];
            break;
        case kWalletId:
            return [userDefaults valueForKey:[NSString stringWithFormat:@"%d", kWalletId]];
            break;
        default:
            break;
    }
    return @"";
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

- (NSString *)getSelectedWalletId {
    return selectedWalletId;
}

@end
