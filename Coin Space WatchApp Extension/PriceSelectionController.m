//
//  PriceSelectionController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "PriceSelectionController.h"
#import "CommonData.h"

@interface PriceSelectionController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *currencyPicker;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *confirmButton;
@property (strong, nonatomic) NSArray *pickersArray;

@property (weak, nonatomic) NSString *selectedCurrency;

@end

@implementation PriceSelectionController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSArray *currencyList = [[CommonData shaderData] getCurrencyList];
    
    if (currencyList != nil && currencyList.count > 0) {
        NSMutableArray *pickerItemsArray = [NSMutableArray array];
        for (NSString *itemCurrency in currencyList) {
            WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
            [pickerItem setTitle:itemCurrency];
            
            [pickerItemsArray addObject:pickerItem];
        }
        _pickersArray = [NSArray arrayWithArray:pickerItemsArray];
        
        [_currencyPicker setItems:_pickersArray];
        [_currencyPicker setEnabled:NO];
        
        WKPickerItem *defaultPickerItem = [_pickersArray objectAtIndex:0];
        _selectedCurrency = defaultPickerItem.title;
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [_currencyPicker setEnabled:YES];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)pickerCurrencySelect:(NSInteger)value {
    WKPickerItem *pickerItem = [_pickersArray objectAtIndex:value];
    if (pickerItem != nil) {
        _selectedCurrency = pickerItem.title;
    }
}

- (IBAction)confirmCurrency {
    [[CommonData shaderData] setSelectedCurrency:_selectedCurrency];
    [self dismissController];
}

@end



