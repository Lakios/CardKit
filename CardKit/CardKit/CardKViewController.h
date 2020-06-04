//
//  CardKViewController.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKTheme.h"


NS_ASSUME_NONNULL_BEGIN

@class CardKViewController;
@class CardKPaymentView;

@protocol CardKViewControllerDelegate <NSObject>

- (void)cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *)seToken allowSaveCard:(BOOL) allowSaveCard;
- (void)willShowController:(CardKViewController *) controller;

- (void)willShowPaymentView:(CardKPaymentView *) paymentView;
- (void)cardKPaymentView:(CardKPaymentView *) paymentView didCreateToken:(NSDictionary *) token;

@optional - (void)cardKitViewControllerScanCardRequest:(CardKViewController *)controller;

@end

@interface CardKViewController : UITableViewController

/*! Делегат контроллера*/
@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;

/*! Переопределить текст кнопки */
@property (strong) NSString * purchaseButtonTitle;

/*! Разрешить исспользование сканера карточки. */
@property BOOL allowedCardScaner;

/*! Разрешить сохранение карты*/
@property BOOL allowSaveBinding;

/*! Начальное состояние отображения checkbox*/
@property BOOL isSaveBinding;

/*!
@brief Присвоить данные карты
@param number Номер карты.
@param holderName Имя владельца карты.
@param date Дата истечения срока действия.
@param cvc Код проверки подлинности карты.
*/
- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc bindingId:(nullable NSString *)bindingId;

/*!
@brief Отобразить сканера карты
@param view Объект класса CardIOView.
@param animated Анимировать появления сканера карты.
*/
- (void)showScanCardView:(UIView *)view animated:(BOOL)animated;

/*!
 @brief Определение первой страницы
 @param cardKViewControllerDelegate делегат контроллера
 @param nController навигационный контроллер
 @param controller экземпляр контроллера CardKViewController
*/
+(UIViewController *) create:(id<CardKViewControllerDelegate>)cardKViewControllerDelegate navigationController:(UINavigationController * _Nullable) nController controller:(CardKViewController *) controller;

@end

NS_ASSUME_NONNULL_END
