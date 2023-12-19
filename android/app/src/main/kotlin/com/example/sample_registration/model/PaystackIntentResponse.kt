package com.example.sample_registration.model

data class PaystackIntentResponse (
    val intentKey: String,
    val intentResponseCode: Int,
    val intentResponse: TerminalResponse
)