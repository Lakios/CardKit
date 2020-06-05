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

- (void)cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *)seToken;
@optional - (void)cardKitViewControllerScanCardRequest:(CardKViewController *)controller;

@end

@interface CardKViewController : UITableViewController

/*! Lелегат контроллера*/
@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;

/*! Переопределить текст кнопки */
@property (strong) NSString * purchaseButtonTitle;

/*! Разрешить исспользование сканера карточки. */
@property BOOL allowedCardScaner;

/*! Режим запуска */
@property BOOL isTestMod;
/*!
@brief Инициализация CardKViewController
@param mdOrder Строка содержащая идентификатор заказа.
*/
- (instancetype)initWithMdOrder:(NSString *)mdOrder;

/*!
@brief Присвоить данные карты
@param number Номер карты.
@param holderName Имя владельца карты.
@param date Дата истечения срока действия.
@param cvc Код проверки подлинности карты.
*/
- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc;

/*!
@brief Отобразить сканера карты
@param view Объект класса CardIOView.
@param animated Анимировать появления сканера карты.
*/
- (void)showScanCardView:(UIView *)view animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
