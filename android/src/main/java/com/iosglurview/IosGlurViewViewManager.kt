package com.iosglurview

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.IosGlurViewViewManagerInterface
import com.facebook.react.viewmanagers.IosGlurViewViewManagerDelegate

@ReactModule(name = IosGlurViewViewManager.NAME)
class IosGlurViewViewManager : SimpleViewManager<IosGlurViewView>(),
  IosGlurViewViewManagerInterface<IosGlurViewView> {
  private val mDelegate: ViewManagerDelegate<IosGlurViewView>

  init {
    mDelegate = IosGlurViewViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<IosGlurViewView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): IosGlurViewView {
    return IosGlurViewView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: IosGlurViewView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "IosGlurViewView"
  }
}
