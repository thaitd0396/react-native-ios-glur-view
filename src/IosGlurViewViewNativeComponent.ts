import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  Double,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

export interface NativeProps extends ViewProps {
  /**
   * Opacity for the blur/tint view (0..1). Defaults to 1.
   */
  tintOpacity?: WithDefault<Double, 1>;

  /** Use SwiftUI Glur progressive blur instead of system UIBlurEffect. */
  useGlur?: WithDefault<boolean, false>;

  /** Glur: total radius when fully applied. */
  glurRadius?: WithDefault<Double, 8.0>;

  /** Glur: start of effect relative to view size. */
  glurOffset?: WithDefault<Double, 0.3>;

  /** Glur: distance from offset to fully applied, relative to view size. */
  glurInterpolation?: WithDefault<Double, 0.4>;

  /** Glur: direction of the effect. */
  glurDirection?: WithDefault<'up' | 'down' | 'left' | 'right', 'down'>;

  /** Glur: amount of noise to apply. */
  glurNoise?: WithDefault<Double, 0.1>;

  /** Glur: whether to pre-render using drawingGroup(). */
  glurDrawingGroup?: WithDefault<boolean, true>;

  /** Image URL or file path to render with Glur (http(s) or file path). */
  imageUri?: WithDefault<string, ''>;
}

export default codegenNativeComponent<NativeProps>('IosGlurViewView');
