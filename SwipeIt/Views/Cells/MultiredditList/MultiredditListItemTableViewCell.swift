//
//  MultiredditNameTableViewCell.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

class MultiredditListItemTableViewCell: UITableViewCell, ReusableCell {

  @IBOutlet fileprivate weak var nameLabel: UILabel!
  @IBOutlet fileprivate weak var subredditsLabel: UILabel!

  var viewModel: MultiredditListItemViewModel! {
    didSet {
      nameLabel.text = viewModel.name
      subredditsLabel.text = viewModel.subreddits
    }
  }
}
