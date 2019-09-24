# Документация CardKit SDK

**Выбор темы**

```swift
// Светлая тема
CardKTheme.setTheme(CardKTheme.light());

// Темная тема
CardKTheme.setTheme(CardKTheme.dark());

// Текущая тема IOS пользователя ТОЛЬКО ДЛЯ IOS 13.0+
CardKTheme.setTheme(CardKTheme.system());
```

## Инициализация CardKViewController

- publicKey - публичный ключ, для генерации seToken;
- mdOrder - идентификатор заказа;

```swift
CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
```

## Параметры объекта CardKViewController

| Название Параметра  |    Тип данных    |  Значение по умолчанию  | Обязательный | Описание                                   |
| :-----------------: | :--------------: | :---------------------: | :----------: | ------------------------------------------ |
|    cKitDelegate     | UIViewController |            -            |      Да      | -                                          |
|  allowedCardScaner  |       BOOL       |         `false`         |     Нет      | Разрешить исспользование сканера карточки. |
| purchaseButtonTitle |      String      | `Purchase` / `Оплатить` |     Нет      | Изменить текст кнопки.                     |

## Поддержка IPad. Отображение формы в Popover

1. Выбрать тему и инициализировать `CardKViewController`.

```swift
// ViewController.h _openController()
CardKTheme.setTheme(CardKTheme.light());

let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
controller.cKitDelegate = self
controller.allowedCardScaner = true;
controller.purchaseButtonTitle = "Custom purchase button";
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

5. Отобразить форму

```swift
...
self.present(navController, animated: true)
```

**Функция \_close**

```swift
@objc func _close(sender:UIButton){
  self.navigationController?.dismiss(animated: true, completion: nil)
}
```

**Результат: На риссунке 1 - IOS 13. На риссунке 2 - IOS 10.**

![Result IOS 13](/images/ios13_popover.png)

  <p align=center> Рисунок 1. Popover IOS 13 </p>

![Result IOS 13](/images/ios10_popover.png)

<p align=center> Рисунок 1. Popover IOS 10 </p>

## Отображение формы отдельной страницей

1. Выбрать тему и инициализировать `CardKViewController`.

```swift
// ViewController.h _openDarkUINavigation()
CardKTheme.setTheme(CardKTheme.dark());

let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
controller.allowedCardScaner = false;
controller.cKitDelegate = self
...
```

2. Добавить `CardKViewController` в `NavigationController`.

```swift
...
self.navigationController?.pushViewController(controller, animated: true)
```

**Результат**

![Result IOS 13](/images/form_in_new_window.png)

  <p align=center> Рисунок 3. Форма в новом окне </p>
