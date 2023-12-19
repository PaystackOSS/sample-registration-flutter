package com.example.sample_registration

import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.example.sample_registration.model.CustomField
import com.example.sample_registration.model.PaystackIntentResponse
import com.example.sample_registration.model.TerminalResponse
import com.example.sample_registration.model.TransactionRequest
import com.example.sample_registration.model.TransactionResponse
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val gson = Gson()
    private var transactionStatus: String? = ""
    private var _result: MethodChannel.Result? = null

    private val CHANNEL = "com.example.sample_registration/payment"
    private val PACKAGE_NAME = "com.paystack.pos.staging"
    private val TRANSACTION = "com.paystack.pos.TRANSACT"
    private val TRANSACTION_RESULT_CODE = 14

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "makePayment") {
                val amount = call.argument("amount") ?: 0
                makePayment(amount)
                _result = result
//                result.success(transactionStatus)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun makePayment(amount: Int?) {
        val transactionRequest = amount?.let {
            TransactionRequest(
                amount = it,
                offlineReference = null,
                supplementaryReceiptData = null,
                metadata = mapOf(
                    "custom_fields" to listOf(
                        CustomField(
                            displayName = "App Name",
                            variableName = "app_name",
                            value = "Sample Registration"
                        )
                    )
                )
            )
        }

        val transactionIntent = Intent(Intent.ACTION_VIEW).apply {
            setPackage(PACKAGE_NAME)
            putExtra(TRANSACTION, gson.toJson(transactionRequest))
        }

        startActivityForResult(transactionIntent, 1)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val paystackIntentResponse: PaystackIntentResponse

        if (resultCode == TRANSACTION_RESULT_CODE) {
            paystackIntentResponse = gson.fromJson(
                data?.getStringExtra(TRANSACTION),
                PaystackIntentResponse::class.java
            )

            processResponse(paystackIntentResponse)
        }
        else {
            // handle invalid result code
            Toast.makeText(
                applicationContext,
                "Oops! Cannot process request.",
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    private fun processResponse(response: PaystackIntentResponse) {

        val terminalResponse: TerminalResponse = response.intentResponse
        val transactionResponse = gson.fromJson(
            terminalResponse.data,
            TransactionResponse::class.java
        )
        
        _result?.success(
            mapOf("status" to transactionResponse.status, "reference" to transactionResponse.reference)
        )

        transactionStatus = transactionResponse.reference
    }
}
