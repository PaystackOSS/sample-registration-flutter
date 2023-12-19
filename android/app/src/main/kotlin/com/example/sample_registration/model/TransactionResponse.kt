package com.example.sample_registration.model

import com.google.gson.annotations.SerializedName

data class TransactionResponse(
    val id: String?,
    val amount: Int?,
    val reference: String?,
    val status: String?,
    val currency: String?,
    @SerializedName("country_code")
    val countryCode: String?,
    @SerializedName("paid_at")
    val paidAt: String?,
    val terminal: String?
)
