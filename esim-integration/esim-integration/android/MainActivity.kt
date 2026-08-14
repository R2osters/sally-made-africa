// android/app/src/main/kotlin/<ton/package>/MainActivity.kt
// Remplace "com.tonapp.esim" par ton applicationId réel.
package com.tonapp.esim

import android.app.PendingIntent
import android.content.*
import android.os.Build
import android.telephony.euicc.DownloadableSubscription
import android.telephony.euicc.EuiccManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val action = "com.tonapp.esim.DOWNLOAD"

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        MethodChannel(engine.dartExecutor.binaryMessenger, "app/esim")
            .setMethodCallHandler { call, result ->
                if (call.method == "install") {
                    installEsim(call.argument<String>("lpa")!!)
                    result.success(true)
                } else result.notImplemented()
            }
    }

    private fun installEsim(code: String) {
        if (Build.VERSION.SDK_INT < 28) return                 // eSIM = Android 9+
        val mgr = getSystemService(Context.EUICC_SERVICE) as? EuiccManager ?: return
        if (!mgr.isEnabled) return                             // appareil sans eSIM

        // Reçoit le résultat et ouvre l'UI système si une confirmation est requise
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                if (resultCode == EuiccManager.EMBEDDED_SUBSCRIPTION_RESULT_RESOLVABLE_ERROR) {
                    mgr.startResolutionActivity(this@MainActivity, 0, intent, pending())
                }
                ctx.unregisterReceiver(this)
            }
        }
        ContextCompat.registerReceiver(
            this, receiver, IntentFilter(action), ContextCompat.RECEIVER_NOT_EXPORTED
        )

        mgr.downloadSubscription(
            DownloadableSubscription.forActivationCode(code), true, pending()
        )
    }

    private fun pending(): PendingIntent {
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= 31) PendingIntent.FLAG_MUTABLE else 0)
        return PendingIntent.getBroadcast(
            this, 0, Intent(action).setPackage(packageName), flags
        )
    }
}
