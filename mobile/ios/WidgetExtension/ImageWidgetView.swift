import SwiftUI
import WidgetKit

extension Image {
  @ViewBuilder
  func tintedWidgetImageModifier(forceFullColor: Bool) -> some View {
    if #available(iOS 18.0, *) {
      self
        .widgetAccentedRenderingMode(forceFullColor ? .accentedDesaturated : .fullColor)
    } else {
      self
    }
  }
}

struct UniversalPhotosWidgetView: View {
  var entry: ImageEntry

  var body: some View {
    if let image = entry.image {
      UniversalPhotosWidgetContentView(
        image: image,
        subtitle: entry.metadata.subtitle,
        deepLink: entry.metadata.deepLink,
        forceFullColor: entry.metadata.forceFullColor
      )
    } else {
      UniversalPhotosWidgetLoadingView(
        message: entry.metadata.error?.errorDescription,
        forceFullColor: entry.metadata.forceFullColor
      )
    }
  }
}

private struct UniversalPhotosWidgetLoadingView: View {
  let message: String?
  let forceFullColor: Bool

  var body: some View {
    let messageText = Text(message ?? "")
      .minimumScaleFactor(0.25)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)

    VStack(spacing: 8) {
      // This is used as a nicer way to center the image, rather than using offsets
      messageText.hidden()

      Image("LaunchImage")
        .tintedWidgetImageModifier(forceFullColor: forceFullColor)

      messageText
    }
  }
}

private struct UniversalPhotosWidgetContentView: View {
  let image: UIImage
  let subtitle: String?
  let deepLink: URL?
  let forceFullColor: Bool

  var body: some View {
    ZStack(alignment: .leading) {
      Color.clear.overlay(
        Image(uiImage: image)
          .resizable()
          .tintedWidgetImageModifier(forceFullColor: forceFullColor)
          .scaledToFill()
      )

      VStack {
        Spacer()
        if let subtitle {
          Text(subtitle)
            .foregroundColor(.white)
            .padding(6)
            .background(ContainerRelativeShape().fill(Color.black.opacity(0.6)))
            .font(.system(size: 16))
        }
      }
      .padding(16)
    }
    .widgetURL(deepLink)
  }
}

#Preview(
  "Medium",
  as: .systemMedium,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: UIImage(named: "LaunchImage"),
      metadata: EntryMetadata(
        subtitle: "1 year ago"
      )
    )
  }
)

#Preview(
  "Medium No Data",
  as: .systemMedium,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: nil
    )
  }
)

#Preview(
  "Medium No Data Error",
  as: .systemMedium,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: nil,
      metadata: EntryMetadata(error: WidgetError.fetchFailed)
    )
  }
)

#Preview(
  "Small",
  as: .systemSmall,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: UIImage(named: "LaunchImage"),
      metadata: EntryMetadata(
        subtitle: "Yesterday"
      )
    )
  }
)

#Preview(
  "Small No Data Error",
  as: .systemSmall,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: nil,
      metadata: EntryMetadata(error: WidgetError.fetchFailed)
    )
  }
)

#Preview(
  "Large",
  as: .systemLarge,
  widget: {
    UniversalPhotosRandomWidget()
  },
  timeline: {
    let date = Date()
    ImageEntry(
      date: date,
      image: UIImage(named: "LaunchImage"),
      metadata: EntryMetadata(
        subtitle: "2000 seconds ago"
      )
    )
  }
)
