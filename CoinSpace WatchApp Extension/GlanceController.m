//
//  GlanceController.m
//  Coin Space WatchApp Extension
//
//  Created by Evgeniy Orlov on 21.11.15.
//
//

#import "GlanceController.h"
#import "CommonData.h"

@interface GlanceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *currencyLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lastDateCurrency;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *glanceImage;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [[CommonData shaderData] initModule];    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    NSString *glancePrice = [[CommonData shaderData] getFullCurrencyInfo];
    NSString *lastDateString = [[CommonData shaderData] loadData:kLastCurrencyDate];
    
    [_currencyLabel setText:glancePrice];
    [_lastDateCurrency setText:lastDateString];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



