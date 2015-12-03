//
//  SendController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "SendController.h"

@interface SendController ()

@end

@implementation SendController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setTitle:@"Send bitcoins"];
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



