# 1.0.0

- `ImageSource` is now a class instead of a struct. Originally I used a struct to get the best performance possible. However the performance penalty for using an extra class is very small and image sources use reference semantics because they can be updated as they are downloaded. This should make the interface cleaner and easier to reason about.
- `ImageSource` properties for both the image and individual images are no longer optional.
- Animation properties now support animated HEIC files. This is available for iOS 13/macOS 10.15/etc only.
- UIKit integration, including `ImageSourceView`, are now in their own target. This is to allow the SwiftUI integration to use the same name for it's view.