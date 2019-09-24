# Документация CardKit SDK

## Выбор темы

```swift
// Светлая тема
CardKTheme.setTheme(CardKTheme.light());

// Темная тема
CardKTheme.setTheme(CardKTheme.dark());

// Текущая тема IOS ТОЛЬКО ДЛЯ IOS 13.0+
CardKTheme.setTheme(CardKTheme.system());
```

## Инициализация CardKViewController

- publicKey - публичный ключ, для генерации seToken;
- mdOrder - идентификатор заказа.

```swift
CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
```

## Параметры объекта CardKViewController

| Название Параметра  |   Тип данных   |  Значение по умолчанию  | Обязательный | Описание                                   |
| :-----------------: | :------------: | :---------------------: | :----------: | ------------------------------------------ |
|    cKitDelegate     | ViewController |            -            |      Да      | -                                          |
|  allowedCardScaner  |      BOOL      |         `false`         |     Нет      | Разрешить исспользование сканера карточки. |
| purchaseButtonTitle |     String     | `Purchase` / `Оплатить` |     Нет      | Изменить текст кнопки.                     |

## Поддержка IPad. Отображение формы в Popover

1. Выбрать тему и инициализировать `CardKViewController`.

```swift
// ViewController.h
CardKTheme.setTheme(CardKTheme.dark());

let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
controller.cKitDelegate = self
controller.allowedCardScaner = false;
...
```

2. Проверить версию IOS текущего устройства. Если версия 13.0+, тогда отобразить форму.

```swift
...
if #available(iOS 13.0, *) {
  self.present(controller, animated: true)
  return;
}
...
```

3.  Если версия < 13.0, инициализировать `UINavigationController` и атрибуту `modalPresentationStyle` присвоить значение `.formSheet`.

```swift
...
let navController = UINavigationController(rootViewController: controller)
navController.modalPresentationStyle = .formSheet
...
```

4. Атрибуту `leftBarButtonItem` в CardKViewController присвоить объект класса `UIBarButtonItem`.

```swift
...
let closeBarButtonItem = UIBarButtonItem(
  title: "Close",
  style: .done,
  target: self,
  action: #selector(_close(sender:)) //Функция _close реализована ниже.
)
controller.navigationItem.leftBarButtonItem = closeBarButtonItem
...
```

5. Отобразить форму.

```swift
...
self.present(navController, animated: true)
```

Пример функции можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L91).

**Функция \_close**

```swift
@objc func _close(sender:UIButton){
  self.navigationController?.dismiss(animated: true, completion: nil)
}
```

**Результат: На риссунке 1 - IOS 13. На риссунке 2 - IOS 10.**

![Result IOS 13](/images/ios13_popover.png)

  <div align="center"> Рисунок 1. Popover IOS 13 </div>

![Result IOS 13](/images/ios10_popover.png)

<div align="center"> Рисунок 1. Popover IOS 10 </div>

## Отображение формы на отдельной странице

1. Выбрать тему и инициализировать `CardKViewController`.

```swift
// ViewController.h
CardKTheme.setTheme(CardKTheme.light());

let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
controller.cKitDelegate = self
controller.allowedCardScaner = true
controller.purchaseButtonTitle = "Custom purchase button";
...
```

2. Добавить `CardKViewController` в `NavigationController`.

```swift
...
self.navigationController?.pushViewController(controller, animated: true)
```

Пример функции можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L155).

**Результат**

![Result IOS 13](/images/form_in_new_window.png)

  <div align="center"> Рисунок 3. Форма на отдельной странице. </div>

## Получение SeToken

Для получения SeToken необходимо реализовать функцию `cardKitViewController`.

- cotroller - объект класса `CardKViewController`;
- didCreateSeToken - готовый `SeToken`.

```swift
// ViewController.h
func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String) {
  debugPrint(seToken)
  ...
  controller.present(alert, animated: true)
}
```

Пример функции можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L244).

## Работа с Card.io

Для работы с Card.io необходимо:

1. реализвать класс `SampleAppCardIO` c функцией `cardIOView`;

- cardIOView - объект класса `CardIOView`;
- didScanCard - данные карты после сканирования;

Если есть данные карты, то вызываем функцию `setCardNumber` и присваиваем данные карты.

```swift
// ViewController.h
class SampleAppCardIO: NSObject, CardIOViewDelegate {
  weak var cardKController: CardKViewController? = nil

  func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
    if let info = cardInfo {
      cardKController?.setCardNumber(info.cardNumber, holderName: info.cardholderName, expirationDate: nil, cvc: nil)
    }
    cardIOView?.removeFromSuperview()
  }
}
```

Пример реализации класса можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L45).

2. реализовать функцию `cardKitViewControllerScanCardRequest()`

- cotroller - объект класса `CardKViewController`;

```swift
// ViewController.h
func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {
  let cardIO = CardIOView(frame: controller.view.bounds)
  cardIO.hideCardIOLogo = true
  cardIO.scanExpiry = false
  cardIO.autoresizingMask = [.flexibleWidth, .flexibleHeight]

  sampleAppCardIO = SampleAppCardIO()
  sampleAppCardIO?.cardKController = controller
  cardIO.delegate = sampleAppCardIO

  controller.showScanCardView(cardIO, animated: true)
}
```

Пример функции можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L254).

3. атрибуту allowedCardScaner присвоить значение `True`. Желательно использовать функция `CardIOUtilities.canReadCardWithCamera()`;

4. вызвать функцию CardIOUtilities.preloadCardIO();

```swift
// ViewController.h
func _openController() {
  ...
  controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
  ...
  CardIOUtilities.preloadCardIO()
}
```

Пример функции можно посмотреть [здесь](https://gitlab.com/yurykorolev/cardkit/blob/webview/SampleApp/SampleApp/ViewController.swift#L64).
