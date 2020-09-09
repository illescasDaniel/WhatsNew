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
		
		guard WhatsNewViewController.shouldPresentIfNewVersion else { return }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
			
			let attributedTitle = NSMutableAttributedString()
			attributedTitle.append(.init(string: "What's New in\n", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]))
			attributedTitle.append(.init(string: "Questions", attributes: [
				.font: UIFont.systemFont(ofSize: 30, weight: .heavy),
				.foregroundColor: UIColor.red
			]))
			
			let newFeatures = [
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "1New cool feature this and that !!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "2New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "3New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "4New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla"),
				NewFeature(image: UIImage(named: "Ghost")!,
					  title: "New cool feature 2!!",
					  subtitle: "blablbla blabablabbl ablblablablbblablbl ablabablabbl ablblablablbla")
			]
			
			let label = UILabel()
			label.text = "test"
			
			let whatsNewViewController = WhatsNewViewController.create(with: .init(
				title: .attributed(attributedTitle),
				subtitle: .default("Hi!!"),
				tintColor: .red,
				newFeatures: newFeatures,
				learnMoreLink: URL(string: "https://www.google.com")!,
				extraContentView: label,
				interfaceStyle: .light,
				sourceViewForPopoverStyleOnIPhoneIfFewElements: self.window?.rootViewController?.view
			))
		
			whatsNewViewController.delegate = self
			
			self.window?.rootViewController?.present(whatsNewViewController, animated: true)
		}
	}
}

extension AppDelegate: WhatsNewViewControllerDelegate {
	
	func whatsNewViewControllerDidSelect(_ whatsNewViewController: WhatsNewViewController, newFeature: NewFeature, withIndex index: Int) {
		print(newFeature.title)
	}
	
	func whatsNewViewControllerDidTapContinueButton(_ whatsNewViewController: WhatsNewViewController) {
		print("hey!")
	}
	
	func whatsNewViewControllerDidTapOpenLinkButton(_ whatsNewViewController: WhatsNewViewController, link: URL) {
		UIApplication.shared.open(link, options: [:], completionHandler: nil)
	}
}
//extension AppDelegate: UIPopoverPresentationControllerDelegate {
//	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//		return .none
//	}
//}
