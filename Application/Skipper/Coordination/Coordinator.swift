import UIKit

protocol InteractiveDismissable: UIAdaptivePresentationControllerDelegate {
    var didInteractiveDismissPresentedController: (() -> Void)? { get set }
    func presentationControllerDidDismiss(_: UIPresentationController)
    func setPresentationDelegate()
}

public protocol CoordinatorType: AnyObject, Presentable {
    associatedtype DeepLinkType
    associatedtype SessionType
    associatedtype Router: RouterType

    var router: Router { get }

    func start()
    func start(with deeplink: DeepLinkType?)
}

public class Coordinator<DeepLinkType, SessionType, Router: RouterType>: NSObject, CoordinatorType, InteractiveDismissable {
    public let router: Router
    public let session: SessionType
    public var childCoordinators: [Coordinator<DeepLinkType, SessionType, NavigationRouter>] = []

    var didInteractiveDismissPresentedController: (() -> Void)?

    public init(with router: Router, session: SessionType) {
        self.router = router
        self.session = session
        super.init()
        setPresentationDelegate()
    }

    public func start() {
        start(with: nil)
    }

    public func start(with _: DeepLinkType?) {}

    public func addChild(_ coordinator: Coordinator<DeepLinkType, SessionType, NavigationRouter>) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator<DeepLinkType, SessionType, NavigationRouter>?) {
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

typealias RootCoordinator = Coordinator<DeepLink, AppSession, AppRouter>
typealias NavigationCoordinator = Coordinator<DeepLink, AppSession, NavigationRouter>
