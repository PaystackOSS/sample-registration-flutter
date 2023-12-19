package com.example.sample_registration.model

data class TransactionRequest(
    val amount: Int,
    val offlineReference: String?,
    val supplementaryReceiptData: SupplementaryReceiptData?,
    val metadata: Map<String, Any>?
)

data class SupplementaryReceiptData(
    val developerSuppliedText: String?,
    val developerSuppliedImageUrlPath: String?,
    val barcodeOrQrcodeImageText: String?,
    val textImageType: TextImageFormat?
)

enum class TextImageFormat {
    QR_CODE,
    AZTEC_BARCODE
}