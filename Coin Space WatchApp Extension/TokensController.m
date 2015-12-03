//
//  TokensController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "TokensController.h"

@interface TokensController ()

@end

@implementation TokensController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setTitle:@"Tokens"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



