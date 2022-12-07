//
//  Constrainable.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//  Copyright © 2022 Denis Kovalev. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that determines object that can be constrained to other views using Autolayout
public protocol Constrainable {}

extension UIView: Constrainable {}
extension UILayoutGuide: Constrainable {}
