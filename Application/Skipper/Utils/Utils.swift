//
//  Utils.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

func delay(_ delay: Double, item: DispatchWorkItem) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: item
    )
}

/// Returns true if the app is launched under tests.
func isUnderUnitTests() -> Bool {
    return ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
}

func randomDebugString(wordsCount: Int) -> String {
    return """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eu suscipit orci, a ullamcorper mi.
    Curabitur vitae vehicula ligula, vel sagittis dolor. Maecenas elementum sed nibh at euismod.
    Etiam lacinia varius tortor eget porttitor. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Ut accumsan enim ac tortor commodo volutpat. Ut commodo eros eleifend, posuere nunc vitae, suscipit risus.
    Cras et nunc euismod neque posuere porttitor.
    Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut varius vehicula interdum.

    Curabitur feugiat convallis nisl quis vulputate.
    Sed eget quam mollis, luctus velit non, pulvinar arcu. Nullam dictum porttitor nibh quis pulvinar.
    Etiam eu accumsan risus, at pulvinar est. Maecenas varius pharetra velit, vel pharetra nunc facilisis a.
    Quisque rhoncus ante sed pharetra pulvinar. Duis id est pellentesque metus auctor commodo.
    Suspendisse fringilla nibh dui, nec auctor leo pulvinar quis. Vivamus ante ex, fermentum in rutrum quis, tincidunt et erat.
    Vivamus eleifend libero nec malesuada blandit. Phasellus dolor velit, eleifend et suscipit at, consectetur eu dolor.
    """.components(separatedBy: " ")
        .shuffled()
        .prefix(wordsCount)
        .joined(separator: " ")
}

// Checks if app can open url string. Does not check if url is a real site or currently online
// Strings without the protocol included such as http/https will fail
func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}
