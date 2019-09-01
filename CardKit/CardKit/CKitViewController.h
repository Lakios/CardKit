//
//  CKitViewController.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CKitViewController;

@protocol CKitViewControllerDelegate <NSObject>

- (void) cardKitViewController:(CKitViewController *)controller didCreateSeToken:(NSString *) seToken;

@end

@interface CKitViewController : UITableViewController

@property (weak, nonatomic) id<CKitViewControllerDelegate> cKitDelegate;

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder;

@end

NS_ASSUME_NONNULL_END
