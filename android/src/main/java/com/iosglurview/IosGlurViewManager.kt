package com.iosglurview

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.IosGlurViewManagerInterface
import com.facebook.react.viewmanagers.IosGlurViewManagerDelegate

@ReactModule(name = IosGlurViewManager.NAME)
class IosGlurViewManager : SimpleViewManager<IosGlurView>(),
  IosGlurViewManagerInterface<IosGlurView> {
  private val mDelegate: ViewManagerDelegate<IosGlurView>

  init {
    mDelegate = IosGlurViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<IosGlurView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): IosGlurView {
    return IosGlurView(context)
  }

  // All methods are no-ops since this is an iOS-only component
  override fun setTintOpacity(view: IosGlurView?, value: Double) {
    // Android view is empty - no-op
  }

  override fun setUseGlur(view: IosGlurView?, value: Boolean) {
    // Android view is empty - no-op
  }

  override fun setGlurRadius(view: IosGlurView?, value: Double) {
    // Android view is empty - no-op
  }

  override fun setGlurOffset(view: IosGlurView?, value: Double) {
    // Android view is empty - no-op
  }

  override fun setGlurInterpolation(view: IosGlurView?, value: Double) {
    // Android view is empty - no-op
  }

  override fun setGlurDirection(view: IosGlurView?, value: String?) {
    // Android view is empty - no-op
  }

  override fun setGlurNoise(view: IosGlurView?, value: Double) {
    // Android view is empty - no-op
  }

  override fun setGlurDrawingGroup(view: IosGlurView?, value: Boolean) {
    // Android view is empty - no-op
  }

  override fun setImageUri(view: IosGlurView?, value: String?) {
    // Android view is empty - no-op
  }

  companion object {
    const val NAME = "IosGlurView"
  }
}


