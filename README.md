# react-native-ios-glur-view

# IMPORTANT! -> COPY FILES IN `ios/Glur/Sources/Glur/Resources/*` TO MAIN PROJECT.

Progressive iOS blur (SwiftUI Glur) + system blur view for React Native (Fabric).

## Installation

```sh
npm install react-native-ios-glur-view
# or
yarn add react-native-ios-glur-view
```

### iOS setup

1. Install pods in your app (or the `example`):

```sh
cd ios && pod install
```

2. Rebuild the iOS app. This library is a Fabric component and relies on codegen.

### Android setup

No manual steps. Rebuild the Android app if used in a monorepo to refresh codegen.

## Usage

```tsx
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { IosGlurView } from 'react-native-ios-glur-view';

export default function Example() {
  return (
    <View style={styles.container}>
      <IosGlurView
        // Switch between SwiftUI Glur and system blur
        useGlur
        // Glur configuration
        glurRadius={25}
        glurOffset={0.3}
        glurInterpolation={0.35}
        glurDirection="down"
        glurNoise={0.01}
        glurDrawingGroup
        // Shared props
        tintOpacity={1}
        // Optional: render an image with Glur
        imageUri="https://images.unsplash.com/photo-1761438180295-9ea187978263?q=80&w=1964"
        style={styles.box}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  box: { width: '50%', height: '50%' },
});
```

## Props

- **tintOpacity**: number (0..1, default 1)
  - Opacity for the blur/tint layer.
- **useGlur**: boolean (default false)
  - When true, uses SwiftUI Glur progressive blur. When false, uses system `UIBlurEffect`.
- **glurRadius**: number (default 8.0)
  - Total radius when the effect is fully applied.
- **glurOffset**: number (default 0.3)
  - Start of the effect relative to view size (0..1).
- **glurInterpolation**: number (default 0.4)
  - Distance from offset to fully applied, relative to view size (0..1).
- **glurDirection**: 'up' | 'down' | 'left' | 'right' (default 'down')
  - Direction the progressive blur travels.
- **glurNoise**: number (default 0.1)
  - Amount of noise applied by Glur.
- **glurDrawingGroup**: boolean (default true)
  - Whether to pre-render using SwiftUI `drawingGroup()` for performance.
- **imageUri**: string (default empty)
  - Optional image URL or file path to render with Glur.

## Regenerating codegen (only if contributing or after renaming)

This library is a Fabric view and uses RN codegen. If you modify names (e.g., component name) or the native/JS spec, regenerate and rebuild:

- iOS: `cd ios && pod install`, then clean/rebuild in Xcode.
- Android: clean Gradle build and rebuild.

## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
