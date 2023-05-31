# ConstantsFolder Xcode Extension [Ru]

## Введение

ConstantsFolder - это расширение для Xcode, предназначенное для автоматического извлечения и использования констант из предопределенного Enum с именем `Constants`.

## Описание работы

ConstantsFolder автоматически сканирует ваш код на наличие Enum с именем `Constants` и извлекает из него все константы. Затем он заменяет все значения этих констант в вашем коде на их соответствующие имена, предварительно дополненные именем Enum, `Constants`.

## Запуск

Чтобы использовать расширение ConstantsFolder, следуйте приведенным ниже шагам:

1. Откройте проект в Xcode
2. В меню Xcode выберите `Editor -> ConstantsFolder`
3. Расширение начнет автоматически выполнять свою работу

## Примеры использования

Предположим, у вас есть следующий код:

```swift
enum Constants {
    static let screenWidth: CGFloat = 375.0
    static let screenHeight: CGFloat = 812.0
}

let width = 375.0
let height = 812.0
```

После применения расширения ConstantsFolder ваш код будет выглядеть следующим образом:

```swift
enum Constants {
    static let screenWidth: CGFloat = 375.0
    static let screenHeight: CGFloat = 812.0
}

let width = Constants.screenWidth
let height = Constants.screenHeight
```

Расширение ConstantsFolder облегчает использование и управление константами в вашем коде, делая его более чистым и удобочитаемым. Оно автоматически ищет и заменяет значения констант на их имена, что позволяет избежать дублирования кода и обеспечивает единый источник истины для всех ваших констант.

## Ограничения

Этот класс специально ищет Enum с именем Constants. Если ваш Enum имеет другое имя, класс его не найдет. 
Кроме того, он поддерживает только замену значений типов CGFloat, Int, Double и String. Если ваш Enum имеет другие типы данных, значения этих типов не будут заменены.

## Описание кода

Этот класс автоматически выполняет эти операции при его вызове. Основной точкой входа для этого является функция `perform(with:completionHandler:)`. Эта функция принимает `XCSourceEditorCommandInvocation` и обработчик завершения. Вызов содержит контекст, необходимый для выполнения команды: он предоставляет содержимое редактора исходного кода и позволяет его изменять.

`perform(with:completionHandler:)` использует несколько приватных вспомогательных методов для выполнения своих задач.

### Вспомогательные методы

1. `isEnumConstantsExists(in:)`: Этот метод просматривает все строки в буфере, чтобы проверить, существует ли Enum "Constants".
2. `extractConstantsFromEnum(in:)`: Этот метод извлекает константы из Enum "Constants". Он ищет строки в пределах объявления Enum и анализирует строки определения констант с использованием регулярных выражений.
3. `replaceConstantsInBuffer(in:with:)`: Этот метод заменяет значения констант в буфере на соответствующие ссылки на константы Enum "Constants".
4. `convertToCorrectType(value:ofType:)`: Этот метод используется для преобразования значений констант в их правильные типы данных.

# ConstantsFolder Xcode Extension [Eng]

## Introduction

ConstantsFolder is an Xcode extension designed to automatically extract and use constants from a predefined Enum named `Constants`.

## Description

ConstantsFolder automatically scans your code for an Enum named `Constants` and extracts all the constants from it. It then replaces all the values of these constants in your code with their corresponding names, prefixed with the Enum name, `Constants`.

## How to Use

To use the ConstantsFolder extension, follow these steps:

1. Open your project in Xcode.
2. From the Xcode menu, select `Editor -> ConstantsFolder`.
3. The extension will automatically start performing its tasks.

## Examples

Assuming you have the following code:

```swift
enum Constants {
    static let screenWidth: CGFloat = 375.0
    static let screenHeight: CGFloat = 812.0
}

let width = 375.0
let height = 812.0
```

After applying the ConstantsFolder extension, your code will look like this:

```swift
enum Constants {
    static let screenWidth: CGFloat = 375.0
    static let screenHeight: CGFloat = 812.0
}

let width = Constants.screenWidth
let height = Constants.screenHeight
```

The ConstantsFolder extension makes it easier to use and manage constants in your code, making it cleaner and more readable. It automatically finds and replaces constant values with their names, avoiding code duplication and providing a single source of truth for all your constants.

## Limitations

This extension specifically looks for an Enum named Constants. If your Enum has a different name, the extension won't find it. Additionally, it only supports replacing values of CGFloat, Int, Double, and String types. If your Enum has other data types, the values of those types won't be replaced.

## Code Description

This class automatically performs these operations when it is invoked. The main entry point for this is the `perform(with:completionHandler:)` function. This function takes an `XCSourceEditorCommandInvocation` and a completion handler. The invocation contains the context necessary to perform the command: it provides the content of the source code editor and allows you to modify it.

`perform(with:completionHandler:)` uses several private helper methods to complete its tasks.

### Helper Methods

1. `isEnumConstantsExists(in:)`: This method scans all lines in the buffer to check if the "Constants" Enum exists.
2. `extractConstantsFromEnum(in:)`: This method extracts constants from the "Constants" Enum. It searches for lines within the Enum declaration and parses constant definition lines using regular expressions.
3. `replaceConstantsInBuffer(in:with:)`: This method replaces constant values in the buffer with the corresponding "Constants" Enum constant references.
4. `convertToCorrectType(value:ofType:)`: This method is used to convert constant values into their correct data types.
