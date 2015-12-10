//
//  OutputsRow.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 30.11.15.
//
//

#import "OutputsRow.h"

@interface OutputsRow()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *outputsLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *amountLabel;

@end

@implementation OutputsRow

- (void)setOutputsValue:(NSString *)outputsText withAmount:(NSString *)amount {
    [_outputsLabel setText:outputsText];
    [_amountLabel setText:amount];
}

@end
