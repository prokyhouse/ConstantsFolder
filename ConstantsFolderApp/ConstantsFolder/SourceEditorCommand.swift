//
//  SourceEditorCommand.swift
//  ConstantsFolder
//
//  Created by Кирилл Прокофьев on 26.05.2023.
//

import Foundation
import XcodeKit

public final class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    // MARK: - Internal methods
    public func perform(
        with invocation: XCSourceEditorCommandInvocation,
        completionHandler: @escaping (Error?) -> Void
    ) {
        guard isEnumConstantsExists(in: invocation) else {
            print("⚠️ Enum Constants не найден.")
            return
        }

        if let constantsDict = extractConstantsFromEnum(in: invocation) {
            let replacedValuesCount = replaceConstantsInBuffer(in: invocation, with: constantsDict)
            print("♻️ Значения из Constants: \(constantsDict)")
            print("✅ Заменено \(replacedValuesCount) значений.")
        } else {
            print("⚠️ Не найдены static-переменные в Constants.")
        }

        completionHandler(nil)
    }
}

// MARK: - Private methods

private extension SourceEditorCommand {
    func isEnumConstantsExists(in invocation: XCSourceEditorCommandInvocation) -> Bool {
        let searchString = Constants.enumConstantsMarker
        var isEnumConstantsFound = false

        for line in invocation.buffer.lines {
            if
                let lineString = line as? String,
                lineString.contains(searchString)
            {
                isEnumConstantsFound = true
                print("✅ \(searchString) найден!")
                break
            }
        }
        return isEnumConstantsFound
    }

    func extractConstantsFromEnum(
        in invocation: XCSourceEditorCommandInvocation
    ) -> [String: Any]? {
        guard
            let buffer = invocation.buffer as? XCSourceTextBuffer,
            let lines = buffer.lines as? [String]
        else {
            return nil
        }

        var constantsDict: [String: Any] = [:]
        var enumConstantsFound = false

        for line in lines {
            if !enumConstantsFound && line.contains(Constants.enumConstantsMarker) {
                enumConstantsFound = true
            } else if enumConstantsFound {
                if line.contains("}") {
                    break // Достигнут конец энамки Constants
                }

                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if let range = trimmedLine.range(of: Constants.definitionMarker) {
                    let constantLine = trimmedLine[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                    let regex = try! NSRegularExpression(pattern: Constants.regex)
                    let matches = regex.matches(
                        in: constantLine,
                        range: NSRange(constantLine.startIndex..., in: constantLine)
                    )

                    if let match = matches.first, match.numberOfRanges == 4 {
                        if
                            let nameRange = Range(match.range(at: 1), in: constantLine),
                            let typeRange = Range(match.range(at: 2), in: constantLine),
                            let valueRange = Range(match.range(at: 3), in: constantLine)
                        {
                            let name = String(constantLine[nameRange])
                            let type = String(constantLine[typeRange])
                            let value = String(constantLine[valueRange])

                            if let convertedValue = convertToCorrectType(
                                value: value,
                                ofType: type
                            ) {
                                constantsDict[name] = convertedValue
                            }
                        }
                    }
                }
            }
        }

        return constantsDict.isEmpty ? nil : constantsDict
    }

    func replaceConstantsInBuffer(
        in invocation: XCSourceEditorCommandInvocation,
        with constantsDict: [String: Any]
    ) -> Int {
        guard
            let buffer = invocation.buffer as? XCSourceTextBuffer,
            let lines = buffer.lines as? [String]
        else {
            return 0
        }

        var replacedValuesCount = 0

        var isInsideEnumConstants = false
        let enumConstantsMarker = Constants.enumConstantsMarker

        for (index, line) in lines.enumerated() {
            var updatedLineString = line

            if updatedLineString.contains(enumConstantsMarker) {
                isInsideEnumConstants = true
            } else if updatedLineString.contains("}") {
                isInsideEnumConstants = false
            }

            if !isInsideEnumConstants {
                for (key, value) in constantsDict {
                    let replacementString = "\(Constants.enumName).\(key)"
                    let replacedString = updatedLineString.replacingOccurrences(
                        of: "\(value)",
                        with: replacementString
                    )

                    if updatedLineString != replacedString {
                        updatedLineString = replacedString
                        replacedValuesCount += 1
                    }
                }

                buffer.lines[index] = updatedLineString
            }
        }

        return replacedValuesCount
    }

    // Функция для преобразования значения строки в соответствующий тип данных
    func convertToCorrectType(value: String, ofType type: String) -> Any? {
        switch type {
        case "CGFloat":
            return CGFloat(Double(value) ?? 0.0)

        case "Int":
            return Int(value)

        case "Double":
            return Double(value)

        case "String":
            return value

        default:
            return nil
        }
    }
}

// MARK: - Constants

private extension SourceEditorCommand {
    enum Constants {
        static let enumName: String = "Constants"
        static let enumConstantsMarker: String = "enum \(enumName)"
        static let definitionMarker: String = "static let"
        static let regex: String = #"(\w+):\s*([\w.]+)\s*=\s*([\w.]+)"#
    }
}
