//
//  CustomErrors.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation

enum FallenMeterError: Error {
    case unexpectedParam
    case httpRequetError(String)
}
