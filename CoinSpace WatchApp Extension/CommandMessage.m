//
//  CommandMessage.m
//  CoinSpace
//
//  Created by Evgeniy Orlov on 12.12.15.
//
//

#import "CommandMessage.h"

@implementation CommandMessage

- (id)initWithDictionary:(NSDictionary *)commandDictionary {
    self = [super init];
    
    NSArray *tmpCommands = [[NSArray alloc] initWithObjects:Commands];
    NSMutableDictionary *tmpMutDict = [NSMutableDictionary dictionary];
    
    for (NSString *key in commandDictionary.allKeys) {
        if ([key isEqualToString:@"command"]) {
            NSString *stringCommand = [commandDictionary valueForKey:@"command"];
            
            if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kBalance]]) {
                _command = kBalance;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kCurrency]]) {
                _command = kCurrency;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kDefaultCurrency]]) {
                _command = kDefaultCurrency;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kTransaction]]) {
                _command = kTransaction;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kQr]]) {
                _command = kQr;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kMectoError]]) {
                _command = kMectoError;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kMectoResult]]) {
                _command = kMectoResult;
            } else if ([stringCommand isEqualToString:[tmpCommands objectAtIndex:kMectoStatus]]) {
                _command = kMectoStatus;
            }
        } else {
            [tmpMutDict setObject:[commandDictionary objectForKey:key] forKey:key];
        }
    }
    
    _messageValues = [NSDictionary dictionaryWithDictionary:tmpMutDict];
    
    return self;
}

@end
