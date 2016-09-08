// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum L10n {
  /// Close
  case closeableButtonClose
  /// Login
  case walkthroughButtonLogin
  /// Cancel
  case alertButtonCancel
  /// OK
  case alertButtonOK
  /// Login
  case loginTitle
  /// Login error
  case loginErrorTitle
  /// Could not log in. Please try again later
  case loginErrorUnknown
  /// Login was cancelled
  case loginErrorUserCancelled
  /// Subscriptions
  case subscriptionsTitle
  /// hidden
  case linkScoreHidden
  /// GIF
  case linkIndicatorGIF
  /// NSFW
  case linkIndicatorNSFW
  /// Spoiler
  case linkIndicatorSpoiler
  /// Album
  case linkIndicatorAlbum
  /// Stickied
  case linkContextStickied
  /// Locked
  case linkContextLocked
  /// Read more
  case linkContentSelfPostReadMore
  /// Upvote
  case linkUpvote
  /// Downvote
  case linkDownvote
  /// Hot
  case listingTypeHot
  /// New
  case listingTypeNew
  /// Rising
  case listingTypeRising
  /// Controversial
  case listingTypeControversial
  /// Top
  case listingTypeTop
  /// Gilded
  case listingTypeGilded
  /// Past hour
  case listingTypeRangeHour
  /// Past 24 hours
  case listingTypeRangeDay
  /// Past week
  case listingTypeRangeWeek
  /// Past month
  case listingTypeRangeMonth
  /// Past year
  case listingTypeRangeYear
  /// All-time
  case listingTypeRangeAllTime
  /// Retry
  case retry
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .closeableButtonClose:
        return L10n.tr("Closeable.Button.Close")
      case .walkthroughButtonLogin:
        return L10n.tr("Walkthrough.Button.Login")
      case .alertButtonCancel:
        return L10n.tr("Alert.Button.Cancel")
      case .alertButtonOK:
        return L10n.tr("Alert.Button.OK")
      case .loginTitle:
        return L10n.tr("Login.Title")
      case .loginErrorTitle:
        return L10n.tr("Login.Error.Title")
      case .loginErrorUnknown:
        return L10n.tr("Login.Error.Unknown")
      case .loginErrorUserCancelled:
        return L10n.tr("Login.Error.UserCancelled")
      case .subscriptionsTitle:
        return L10n.tr("Subscriptions.Title")
      case .linkScoreHidden:
        return L10n.tr("Link.Score.Hidden")
      case .linkIndicatorGIF:
        return L10n.tr("Link.Indicator.GIF")
      case .linkIndicatorNSFW:
        return L10n.tr("Link.Indicator.NSFW")
      case .linkIndicatorSpoiler:
        return L10n.tr("Link.Indicator.Spoiler")
      case .linkIndicatorAlbum:
        return L10n.tr("Link.Indicator.Album")
      case .linkContextStickied:
        return L10n.tr("Link.Context.Stickied")
      case .linkContextLocked:
        return L10n.tr("Link.Context.Locked")
      case .linkContentSelfPostReadMore:
        return L10n.tr("Link.Content.SelfPost.ReadMore")
      case .linkUpvote:
        return L10n.tr("Link.Upvote")
      case .linkDownvote:
        return L10n.tr("Link.Downvote")
      case .listingTypeHot:
        return L10n.tr("ListingType.Hot")
      case .listingTypeNew:
        return L10n.tr("ListingType.New")
      case .listingTypeRising:
        return L10n.tr("ListingType.Rising")
      case .listingTypeControversial:
        return L10n.tr("ListingType.Controversial")
      case .listingTypeTop:
        return L10n.tr("ListingType.Top")
      case .listingTypeGilded:
        return L10n.tr("ListingType.Gilded")
      case .listingTypeRangeHour:
        return L10n.tr("ListingType.Range.Hour")
      case .listingTypeRangeDay:
        return L10n.tr("ListingType.Range.Day")
      case .listingTypeRangeWeek:
        return L10n.tr("ListingType.Range.Week")
      case .listingTypeRangeMonth:
        return L10n.tr("ListingType.Range.Month")
      case .listingTypeRangeYear:
        return L10n.tr("ListingType.Range.Year")
      case .listingTypeRangeAllTime:
        return L10n.tr("ListingType.Range.AllTime")
      case .retry:
        return L10n.tr("Retry")
    }
  }

  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
