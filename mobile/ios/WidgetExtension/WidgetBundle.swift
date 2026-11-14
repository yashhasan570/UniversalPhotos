import SwiftUI
import WidgetKit

@main
struct UniversalPhotosWidgetBundle: WidgetBundle {
  var body: some Widget {
    UniversalPhotosRandomWidget()
    UniversalPhotosMemoryWidget()
  }
}
