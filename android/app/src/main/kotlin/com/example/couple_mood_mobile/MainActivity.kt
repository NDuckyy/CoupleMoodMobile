package com.example.couple_mood_mobile

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import vn.zalopay.sdk.Environment
import vn.zalopay.sdk.ZaloPaySDK
import vn.zalopay.sdk.ZaloPayError
import vn.zalopay.sdk.listeners.PayOrderListener

class MainActivity : FlutterActivity() {

    private val CHANNEL = "zalopay_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        ZaloPaySDK.init(2553, Environment.SANDBOX)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "payOrder") {
                    val token = call.argument<String>("zptoken")

                    if (token.isNullOrEmpty()) {
                        result.error("ERROR", "Token rỗng", null)
                        return@setMethodCallHandler
                    }

                    ZaloPaySDK.getInstance().payOrder(
                        this,
                        token,
                        "couplemood://payment-result",
                        object : PayOrderListener {
                            override fun onPaymentSucceeded(
                                transactionId: String,
                                transToken: String,
                                appTransID: String
                            ) {
                                result.success("SUCCESS")
                            }

                            override fun onPaymentCanceled(
                                zpTransToken: String,
                                appTransID: String
                            ) {
                                result.success("CANCELED")
                            }

                            override fun onPaymentError(
                                error: ZaloPayError,
                                zpTransToken: String,
                                appTransID: String
                            ) {
                                result.success("FAILED")
                            }
                        }
                    )
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        ZaloPaySDK.getInstance().onResult(intent)
    }
}
