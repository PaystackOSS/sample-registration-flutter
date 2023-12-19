package com.example.sample_registration.model

import com.google.gson.annotations.SerializedName

data class CustomField(
    @SerializedName("display_name")
    val displayName: String,
    @SerializedName("variable_name")
    val variableName: String,
    val value: String?
)
