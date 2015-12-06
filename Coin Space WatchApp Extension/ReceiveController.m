//
//  ReceiveController.m
//  Coin Space
//
//  Created by Evgeniy Orlov on 22.11.15.
//
//

#import "CommonData.h"
#import "ReceiveController.h"

@interface ReceiveController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *qrImageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSwitch *mectoSwitch;

@end

@implementation ReceiveController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [[CommonData shaderData] sendMessage:@"showQrCode" queue:@"requestCommandQueue"];
    
    [self setTitle:@"Receive"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQrCodeNotification:) name:@"qrCodeNotification" object:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)onQrCodeNotification:(NSNotification *)notification {
    NSData *imgData = notification.object;
    if (imgData != nil) {
        UIImage *qrImage = [UIImage imageWithData:imgData];
        [_qrImageView setImage:qrImage];
    }
}

- (void)onMectorErrorNotification:(NSNotification *)notification {
    NSString *errorMessage = notification.object;
    WKAlertAction *alerAction = [WKAlertAction actionWithTitle:@"Ok" style:WKAlertActionStyleDefault handler:^{

    }];
    
    [_mectoSwitch setOn:NO];
    [self presentAlertControllerWithTitle:@"CoinSpace" message:errorMessage preferredStyle:WKAlertControllerStyleAlert actions:@[alerAction]];
}

- (IBAction)mectoSwitchAction:(BOOL)value {
    [[CommonData shaderData] setMecto:value];
    if (value == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMectorErrorNotification:) name:@"mectoErrorNotification" object:nil];
        [[CommonData shaderData] sendMessage:@"turnMectoOn" queue:@"requestCommandQueue"];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mectoErrorNotification" object:nil];
        [[CommonData shaderData] sendMessage:@"TurnMectoOff" queue:@"requestCommandQueue"];
    }
}

@end



