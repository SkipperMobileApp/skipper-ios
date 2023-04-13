import UIKit

public protocol RouterType: AnyObject, Presentable {
    func setRootModule(_ module: Presentable)
    var hasRootModule: Bool { get }
}

public extension RouterType {
    var hasRootModule: Bool { return true }
}

// MARK: - PresentationRouterType

public protocol PresentationRouterType: RouterType {
    func present(_ module: Presentable)
    func present(
        _ module: Presentable,
        animated: Bool,
        modalPresentationStyle: UIModalPresentationStyle?
    )
    func dismissModule()
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

public extension PresentationRouterType {
    func present(_ module: Presentable) {
        present(module, animated: true)
    }

    func present(
        _ module: Presentable,
        animated: Bool,
        modalPresentationStyle: UIModalPresentationStyle? = nil
    ) {
        let controller = module.toPresentable()
        if let presentationStyle = modalPresentationStyle {
            controller.modalPresentationStyle = presentationStyle
        }
        toPresentable().topModalViewController()
            .present(controller, animated: animated, completion: nil)
    }

    func dismissModule() {
        dismissModule(animated: true)
    }

    func dismissModule(animated: Bool) {
        dismissModule(animated: animated, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        toPresentable().dismiss(animated: animated, completion: completion)
    }
}

// MARK: - NavigationRouterType

public protocol NavigationRouterType: PresentationRouterType {
    typealias FinishHandler = () -> Void

    func push(_ module: Presentable)
    func push(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, finishHandler: (() -> Void)?)
    func popModule()
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool, animated: Bool)
    func popToRootModule()
    func popToRootModule(animated: Bool)
}

private extension UIViewController {
    func topModalViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topModalViewController()
        }
        return self
    }
}
