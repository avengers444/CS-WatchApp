//
//  InputsRow.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 30.11.15.
//
//

#import "InputsRow.h"

@interface InputsRow()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *inputsLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *amountLabel;

@end

@implementation InputsRow

- (void)setInputsValue:(NSString *)inputsText withAmount:(NSString *)amount {
    [_inputsLabel setText:inputsText];
    [_amountLabel setText:amount];
}

@end
