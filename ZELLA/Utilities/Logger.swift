//
//  Logger.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation

struct Logger {
    static func log(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        print("[\(file.components(separatedBy: "/").last ?? ""):\(line)] \(message)")
        #endif
    }
}
