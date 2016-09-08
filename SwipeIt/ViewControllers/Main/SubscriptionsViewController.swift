//
//  SubscriptionsViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift

// MARK: Properties
class SubscriptionsViewController: UIViewController, HideableHairlineViewController,
TitledViewModelViewController {

  // MARK: IBOutlets
  @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
  @IBOutlet fileprivate weak var toolbar: UIToolbar!

  // MARK: Private Properties
  fileprivate var pageViewController: PageViewController! {
    didSet {
      pageViewController.pageViewControllerDelegate = self
    }
  }

  // MARK: Public Properties
  var viewModel: SubscriptionsViewModel!

}

// MARK: Lifecycle
extension SubscriptionsViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Remove the line in the UINavigationBar so the UIToolbar and UINavigation bar appear as merged
    hideHairline()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    // show the line in the UINavigationBar whenever the view controller pushes content
    showHairline()
  }

}

// MARK: Setup
extension SubscriptionsViewController {

  fileprivate func setup() {
    bindTitle(viewModel)
    bindPageViewController()
    bindSegmentedControl()
  }

  // Binding any change of the PageViewController's selectedIndex to the segmentedControl
  fileprivate func bindPageViewController() {
    pageViewController.rx_selectedIndex
      .asObservable()
      .bindTo(segmentedControl.rx_value)
      .addDisposableTo(rx_disposeBag)
  }

  // Binding any change of the segmentedControl's value to the PageViewController's selectedIndex
  fileprivate func bindSegmentedControl() {
    segmentedControl.rx_value
      .asObservable()
      .bindTo(pageViewController.rx_selectedIndex)
      .addDisposableTo(rx_disposeBag)
  }

}

// MARK: PageViewControllerDelegate
extension SubscriptionsViewController: PageViewControllerDelegate {

  func pageViewController(_ pageViewController: PageViewController, didTransitionToIndex: Int) { }

  func pageViewController(_ pageViewController: PageViewController,
                          prepareForSegue segue: UIStoryboardSegue, sender: AnyObject?) {

    guard let segueEnum = StoryboardSegue.Main(optionalRawValue: segue.identifier) else { return }

    // Set the subredditListViewController viewModel and topScrollInset (to offset the toolbar)
    if let subredditListViewController
      = segue.destination as? SubredditListViewController,
      segueEnum == .PageSubredditList {
      subredditListViewController.viewModel = viewModel.subredditListViewModel
      subredditListViewController.topScrollInset = toolbar.frame.maxY
    }

    // Set the multiredditListViewController viewModel and topScrollInset (to offset the toolbar)
    if let multiredditListViewController
      = segue.destination as? MultiredditListViewController,
      segueEnum == .PageMultiredditList {
      multiredditListViewController.viewModel = viewModel.multiredditListViewModel
      multiredditListViewController.topScrollInset = toolbar.frame.maxY
    }
  }

}

// MARK: UIToolbarDelegate
extension SubscriptionsViewController: UIToolbarDelegate {

  // This will attach the UIToolbar to the navigation bar
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: Segues
extension SubscriptionsViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let segueEnum = StoryboardSegue.Main(optionalRawValue: segue.identifier) else { return }

    if let pageViewController = segue.destination as? PageViewController,
      segueEnum == .Page {
      self.pageViewController = pageViewController
    }
  }

}
