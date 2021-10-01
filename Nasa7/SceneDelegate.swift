//
//  SceneDelegate.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 25.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // swiftlint:disable:next line_length
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
          window = UIWindow(frame: UIScreen.main.bounds)
          let tabBarController = UITabBarController()
          let viewController = ViewController()
          tabBarController.setViewControllers([viewController], animated: false)
          self.window?.rootViewController = tabBarController
          window?.makeKeyAndVisible()
          window?.windowScene = windowScene
          }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
