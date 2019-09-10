//
//  CardKViewController.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@class CardKViewController;

@protocol CardKViewControllerDelegate <NSObject>

- (void) cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *) seToken;

@end


//@property(null_unspecified,nonatomic,copy) UITextContentType textContentType;

@interface CardKViewController : UITableViewController

@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;
@property (strong) CardKTheme *theme;
@property (strong) NSString * purchaseButtonTitle;

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder;
//- (void) didChangeCardTheme;

@end

NS_ASSUME_NONNULL_END
