//
//  TransactionDetailController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 28.11.15.
//
//

#import "CommonData.h"
#import "InputsRow.h"
#import "OutputsRow.h"
#import "TransactionDetailController.h"

@interface TransactionDetailController ()

@property (weak, nonatomic) NSDictionary *transactionInfo;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *transactionIdLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *transactionFee;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *inputsTable;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *outputsTable;

@end

@implementation TransactionDetailController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    if ([context isKindOfClass:[NSDictionary class]]) {
        _transactionInfo = (NSDictionary *)context;
    }
    
    [self setTitle:@"Detail"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self configureView];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)configureView {
    if (_transactionInfo != nil) {
        [_transactionIdLabel setText:[_transactionInfo valueForKey:@"id"]];
        NSNumber *fee = [_transactionInfo objectForKey:@"fee"];
        [_transactionFee setText:[[CommonData shaderData] getBTCString:fee]];
        
        NSArray *inputsArray = [_transactionInfo objectForKey:@"ins"];
        NSArray *outputsArray = [_transactionInfo objectForKey:@"outs"];
        
        [_inputsTable setNumberOfRows:inputsArray.count withRowType:@"inputsRow"];
        [_outputsTable setNumberOfRows:outputsArray.count withRowType:@"outputsRow"];
        
        int inputsIndex = 0;
        for (NSDictionary *inputsInfo in inputsArray) {
            InputsRow *inputRow = [_inputsTable rowControllerAtIndex:inputsIndex];
            NSNumber *amount = [inputsInfo valueForKey:@"amount"];
            [inputRow setInputsValue:[inputsInfo valueForKey:@"address"] withAmount:[[CommonData shaderData] getBTCString:amount]];
            inputsIndex++;
        }
        int outputsIndex = 0;
        for (NSDictionary *outputsInfo in outputsArray) {
            OutputsRow *outputRow = [_outputsTable rowControllerAtIndex:outputsIndex];
            NSNumber *amount = [outputsInfo valueForKey:@"amount"];
            [outputRow setOutputsValue:[outputsInfo valueForKey:@"address"] withAmount:[[CommonData shaderData] getBTCString:amount]];
            outputsIndex++;
        }
    }
}

@end



