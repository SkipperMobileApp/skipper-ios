import UIKit

protocol InteractiveDismissable: UIAdaptivePresentationControllerDelegate {
    var didInteractiveDismissPresentedController: (() -> Void)? { get set }
    func presentationControllerDidDismiss(_: UIPresentationController)
    func setPresentationDelegate()
}

public protocol CoordinatorType: AnyObject, Presentable {
    associatedtype DeepLinkType
    associatedtype Router: RouterType

    var router: Router { get }

    func start()
    func start(with deeplink: DeepLinkType?)
}

public class Coordinator<DeepLinkType, Router: RouterType>: NSObject, CoordinatorType, InteractiveDismissable {
    public let router: Router
    public var childCoordinators: [Coordinator<DeepLinkType, NavigationRouter>] = []

    var didInteractiveDismissPresentedController: (() -> Void)?

    public init(with router: Router) {
        self.router = router
        super.init()
        setPresentationDelegate()
    }

    public func start() {
        start(with: nil)
    }

    public func start(with _: DeepLinkType?) {}

    public func addChild(_ coordinator: Coordinator<DeepLinkType, NavigationRouter>) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator<DeepLinkType, NavigationRouter>?) {
        guard let coordinator = coordinator, let index = childCoordinators.firstIndex(where: { $0 === coordinator }) else {
            return
        }

        childCoordinators.remove(at: index)
    }

    public func removeAllChildren() {
        childCoordinators.removeAll()
    }

    public func toPresentable() -> UIViewController {
        return router.toPresentable()
    }

    func setPresentationDelegate() {
        if router.hasRootModule {
            toPresentable().presentationController?.delegate = self
        }
    }

    public func presentationControllerDidDismiss(_: UIPresentationController) {
        didInteractiveDismissPresentedController?()
    }
}

typealias RootCoordinator = Coordinator<DeepLink, AppRouter>
typealias NavigationCoordinator = Coordinator<DeepLink, NavigationRouter>
