//
//  AppLogTool.swift
//  SwiftDemo
//
//  Created by publicjoker on 12/10/2025.
//

import Foundation

func appLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let printItems: [Any] = ["[DemoApp]"] + items
    print(printItems, separator: separator, terminator: terminator)
}
