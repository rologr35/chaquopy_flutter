package com.chaquopy.chaquopy

import android.content.Context
import androidx.annotation.NonNull
import com.chaquo.python.PyException
import com.chaquo.python.PyObject
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/** ChaquopyPlugin */
class ChaquopyPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "chaquopy")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    //  * This will run python code consisting of error and result output...
    fun _runPythonTextCode(code: String): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()
        val _python: Python = Python.getInstance()
        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")

        try {
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            _console.callAttrThrows("mainTextCode", code)
            _returnOutput["scriptOutput"] = _textOutputStream.callAttr("getvalue").toString()
            return _returnOutput
        } catch (e: PyException) {
            throw e
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "runPythonScript") {
            try {
                val code: String = call.arguments() ?: ""
                val _result: Map<String, Any?> = _runPythonTextCode(code)
                result.success(_result)
            } catch (e: Exception) {
                result.error("Exception", e.message.toString(), -1)
            }
        } else if (call.method == "isStarted") {
            try {
                result.success(Python.isStarted())
            } catch (e: Exception) {
                result.error("Exception", e.message.toString(), -1)
            }
        } else if (call.method == "start") {
            try {
                context?.let {
                    if (!Python.isStarted()) {
                        Python.start(AndroidPlatform(it))
                    }
                    result.success(true)
                } ?: run {
                    result.error("Exception", "No Context", -1)
                }
            } catch (e: Exception) {
                result.error("Exception", e.message.toString(), -1)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }
}
