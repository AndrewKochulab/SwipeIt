//
//  PageViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: PageViewControllerDelegate
public protocol PageViewControllerDelegate {

  // Called when the view controller changes to another page
  func pageViewController(_ pageViewController: PageViewController, didTransitionToIndex: Int)

  // Called when the view controller prepares for a segue, to allow parent view controller to inject
  // properties into child view controller
  func pageViewController(_ pageViewController: PageViewController,
                          prepareForSegue segue: UIStoryboardSegue, sender: AnyObject?)

}

open class PageViewController: UIPageViewController {

  // Dynamic so it can be observable
  fileprivate dynamic var _selectedIndex: Int = 0

  open var selectedIndex: Int {
    get {
      return _selectedIndex
    }
    set {
      setSelectedIndex(newValue, animated: true)
    }
  }

  open var pageViewControllers: [UIViewController] = []

  open var pageViewControllerDelegate: PageViewControllerDelegate?

  override init(transitionStyle style: UIPageViewControllerTransitionStyle,
                                navigationOrientation: UIPageViewControllerNavigationOrientation,
                                options: [String : Any]?) {

    super.init(transitionStyle: style, navigationOrientation: navigationOrientation,
               options: options)
    commonSetup()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    commonSetup()
  }

  fileprivate func commonSetup() {
    self.dataSource = self
    self.delegate = self
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    performPageSegues()
  }

  // A very hacky way to automatically perform segues defined in the storyboard
  // storyboardSegueTemplates has a property named segueClassName which contains the mangled name
  // for the Segue's class e.g. 't3gdxPageSegue'; it also has the identifier property to perform
  // the segue with identifier call.
  fileprivate func performPageSegues() {
    guard let segueTemplates = value(forKey: "storyboardSegueTemplates") as? [AnyObject] else {
      return
    }

    segueTemplates
      .filter {
        ($0.value(forKey: "segueClassName") as? String)?.contains("PageSegue") ?? false
      }.flatMap { $0.value(forKey: "identifier") as? String }
      .forEach { self.performSegue(withIdentifier: $0, sender: nil) }
  }

  open func setSelectedIndex(_ index: Int, animated: Bool) {
    guard index < pageViewControllers.count else {
      return
    }
    let viewController = pageViewControllers[index]
    setViewControllers([viewController],
                       direction: (index > _selectedIndex ? .forward : .reverse),
                       animated: animated, completion: nil)
  }

}

// MARK: UIPageViewControllerDelegate,
extension PageViewController: UIPageViewControllerDelegate {

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 didFinishAnimating finished: Bool,
                                                    previousViewControllers: [UIViewController],
                                                    transitionCompleted completed: Bool) {
    guard let viewController = pageViewController.viewControllers?.last,
      let index = pageViewControllers.index(of: viewController)
      , finished && completed else {
        return
    }
    _selectedIndex = index
    pageViewControllerDelegate?.pageViewController(self, didTransitionToIndex: index)
  }
}

// MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = pageViewControllers.index(of: viewController) , index - 1 >= 0 else {
      return nil
    }
    return pageViewControllers[index - 1]
  }

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController)
    -> UIViewController? {
      guard let index = pageViewControllers.index(of: viewController)
        , index + 1 < pageViewControllers.count else {
          return nil
      }
      return pageViewControllers[index + 1]
  }

}

// MARK: Segue
extension PageViewController {

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    pageViewControllerDelegate?.pageViewController(self, prepareForSegue: segue, sender: sender as AnyObject?)
  }

}

// MARK: Rx Bindings
// swiftlint:disable variable_name
extension PageViewController {

  public var rx_selectedIndex: ControlProperty<Int> {
    let source: Observable<Int> = Observable.deferred { [weak self] () -> Observable<Int> in
      return (self?.rx_observe(Int.self, "_selectedIndex") ?? Observable.empty())
        .map { index in
          index ?? 0
      }
    }

    let bindingObserver = UIBindingObserver(UIElement: self) {
      (pageViewController, selectedIndex: Int) in
      pageViewController.selectedIndex = selectedIndex
    }

    return ControlProperty(values: source, valueSink: bindingObserver)
  }
}

// MARK: PageSegue
open class PageSegue: UIStoryboardSegue {

  override init(identifier: String?, source: UIViewController, destination: UIViewController) {
    super.init(identifier: identifier, source: source, destination: destination)

    if let pageViewController = source as? PageViewController {
      var viewControllers = pageViewController.pageViewControllers ?? []
      viewControllers.append(destination)
      pageViewController.pageViewControllers = viewControllers
    }
  }

  override open func perform() { }
}
