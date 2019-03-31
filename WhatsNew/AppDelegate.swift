//
//  AppDelegate.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.newFeaturesPopup()
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	// MARK: - Convenience
	
	private func newFeaturesPopup() {
		
		//guard WhatsNewViewController.shouldPresentIfNewVersion else { return }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
			
			let whatsNewViewController = WhatsNewViewController(nibName: "WhatsNewViewController", bundle: nil)
			
			let attributedTitle = NSMutableAttributedString()
			attributedTitle.append(.init(string: "What's New in ", attributes: WhatsNewViewController.titleAttributes))
			attributedTitle.append(.init(string: "Questions", attributes: [
				.font: WhatsNewViewController.titleAttributes[.font]!,
				.foregroundColor: UIColor.purple
			]))
			
			whatsNewViewController.parameters.attributedTitle = attributedTitle
			// or: whatsNewViewController.parameters.title = "What's new"
			//whatsNewViewController.parameters.subtitle = "We hope you enjoy these\nawesome new features"
			//whatsNewViewController.parameters.dark = true
			
			whatsNewViewController.parameters.newFeatures = [
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature this and that !!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				.init(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla")
			]
			
			whatsNewViewController.tintColor = .purple
			whatsNewViewController.delegate = self
			whatsNewViewController.popoverIfFewElements(sourceView: self.window?.rootViewController?.view, delegate: self)
			
			self.window?.rootViewController?.present(whatsNewViewController, animated: true)
		}
	}
}

extension AppDelegate: WhatsNewViewControllerDelegate {
	func didSelect(newFeature: NewFeature, withIndex index: Int) {
		print(newFeature.title)
	}
}
extension AppDelegate: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}
