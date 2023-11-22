//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Khoa Le on 22/11/2023.
//

import UIKit
import CurrencyConverterFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: UIWindowSceneDelegate
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene, 
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        (scene as? UIWindowScene)
            .map(UIWindow.init(windowScene:))
            .map(bootstrap(from:))
    }

    // MARK: Side Effects
    
    /// Sets up the root view controller and appearance then shows the window and makes it the key window.
    /// - Parameter window: The backdrop for your app’s user interface and the object that dispatches events to your views.
    private func bootstrap(from window: UIWindow) {
        self.window = window
        let currencyConverterBuilder: CurrencyConverterBuilder = CurrencyConverterBuilder()
        let viewController = currencyConverterBuilder.build()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
