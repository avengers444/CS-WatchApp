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
    [self setTitle:@"Receive"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQrCodeNotification:) name:@"qrCodeNotification" object:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [[CommonData shaderData] sendMessage:@"showQrCode" queue:@"requestCommandQueue"];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"qrCodeNotification" object:nil];
}

- (void)onQrCodeNotification:(NSNotification *)notification {
    __weak NSData *imgData = notification.object;
    if (imgData != nil) {
        __weak UIImage *qrImage = [UIImage imageWithData:imgData];
        [_qrImageView setImage:qrImage];
    }
}

- (IBAction)mectoSwitchAction:(BOOL)value {
    if (value == YES) {
        [[CommonData shaderData] sendMessage:@"mectoOff" queue:@"requestCommandQueue"];
    } else {
        [[CommonData shaderData] sendMessage:@"mectoOn" queue:@"requestCommandQueue"];
    }
}

@end



