import UIKit

public class AppRouter: PresentationRouterType {
    let window: UIWindow

    public var hasRootModule: Bool {
        return window.rootViewController != nil
    }

    init(with window: UIWindow) {
        self.window = window
    }

    public func setRootModule(_ module: Presentable) {
        setRootModule(module, transitionOptions: nil)
    }

    func setRootModule(
        _ module: Presentable,
        transitionOptions: UIWindow.TransitionOptions? = nil
    ) {
        let controller = module.toPresentable()

        if let transitionOptions = transitionOptions {
            window.setRootViewController(controller, options: transitionOptions)
        } else {
            window.rootViewController = controller
        }
        window.makeKeyAndVisible()
    }

    func dismissAllViews(_ animated: Bool = false, completion: (() -> Void)? = nil) {
        window.rootViewController?.dismiss(animated: animated, completion: completion)
    }

    public func toPresentable() -> UIViewController {
        assert(
            window.rootViewController != nil,
            "setRootModule must be already called at this moment"
        )
        return window.rootViewController!
    }
}
