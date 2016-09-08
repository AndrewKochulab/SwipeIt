//
//  SubredditListViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 04/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxDataSources

// MARK: Properties
class SubredditListViewController: UIViewController, InsettableScrollViewViewController {

  // MARK: IBOutlets
  @IBOutlet fileprivate weak var tableView: UITableView!

  // MARK: Public Properties
  var viewModel: SubredditListViewModel!

  // MARK: InsettableScrollViewViewController Property
  var topScrollInset: CGFloat = 0
}

// MARK: Lifecycle
extension SubredditListViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.deselectRows(true)
  }
}

// MARK: Setup
extension SubredditListViewController {

  fileprivate func setup() {
    bindTableView()
    setupInsettableScrollView(tableView)
    viewModel.requestAllSubreddits()
  }

  fileprivate func bindTableView() {
    let dataSource =
      RxTableViewSectionedReloadDataSource<SectionViewModel<SubredditListItemViewModel>>()

    dataSource.configureCell = { (_, tableView, indexPath, viewModel) in
      let cell = tableView.dequeueReusableCell(SubredditListItemTableViewCell.self,
                                               indexPath: indexPath)
      cell.viewModel = viewModel
      return cell
    }

    dataSource.titleForHeaderInSection = { (dataSource, index) in
      return dataSource.sectionAtIndex(index).title
    }

    dataSource.sectionIndexTitles = { dataSource in
      return dataSource.sectionModels.map { $0.title }
    }

    dataSource.sectionForSectionIndexTitle = { (_, _, index) in
      return index
    }

    viewModel
      .viewModels
      .bindTo(tableView.rx_itemsWithDataSource(dataSource))
      .addDisposableTo(rx_disposeBag)
  }
}

// MARK: Segues
extension SubredditListViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let segueEnum = StoryboardSegue.Main(optionalRawValue: segue.identifier) else { return }

    if let linkSwipeViewController = segue.navigationRootViewController as? LinkSwipeViewController,
      let cell = sender as? SubredditListItemTableViewCell , segueEnum == .LinkList {
      linkSwipeViewController.viewModel = cell.viewModel.linkSwipeViewModel
    }
  }
}
