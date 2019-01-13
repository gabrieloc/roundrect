# roundrect

A library for programaticaly generating image assets and styling `UIButton` with generated assets.

## Creating Images
The conveniences in `ImageGeneration.swift`  allow images to be generated from a view, or given various style properties like fill, stroke, corner radius, etc. For example, to create a 3px/3px image with a 1px blue stroke and a single red fill:
```swift
let image = UIImage(
  fill: .red,
  stroke: (
    color: .blue, 
    width: 1
  )
)
```
This image can be made resizable and applied to a `UIButton`, but since there is a lot of busywork associated with handling all the different states a button can have, the conveniences in `ButtonStyle` can be used instead. A combination of a button `Style` (eg. filled vs bordered) and `Theme` (eg. light or dark) can be provided when creating or modifying an existing `UIButton`:
```swift
let button = UIButton(
  style: .filled(
    cornerRadius: 8
  ),
  theme: .light
)
```
This will yield a button with a tintable fill and a corner radius of 8.

## Code coverage
Image generation and button styling tests rely on [FBSnapshotTestCase](https://github.com/uber/ios-snapshot-test-case), which is linked using Carthage. To see what's tested, view the reference images in `roundrectTests/recorded/`. `SampleSheetTests` generates an asset displaying every combination of style and theme, providing a quick preview of what's available:
![roundrect](sample.png)
