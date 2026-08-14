// ios/Runner/AppDelegate.swift
// Garde l'attribut @main (templates Flutter récents) ou @UIApplicationMain selon ton projet.
import UIKit
import Flutter
import CoreTelephony

@main
@objc class AppDelegate: FlutterAppDelegate {

  // ⚠️ Référence forte OBLIGATOIRE. Sans elle, addPlan renvoie toujours .unknown.
  private let networkInfo = CTTelephonyNetworkInfo()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "app/esim",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "install",
            let lpa = (call.arguments as? [String: Any])?["lpa"] as? String else {
        result(FlutterMethodNotImplemented); return
      }
      self?.installEsim(lpa, result: result)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func installEsim(_ lpa: String, result: @escaping FlutterResult) {
    let provisioning = CTCellularPlanProvisioning()
    guard provisioning.supportsCellularPlan() else {
      result(FlutterError(code: "UNSUPPORTED", message: "Appareil sans eSIM", details: nil))
      return
    }

    // Décompose "LPA:1$smdp$matchingId[$oid]" en champs attendus par l'API
    let parts = lpa.replacingOccurrences(of: "LPA:1$", with: "").components(separatedBy: "$")
    let request = CTCellularPlanProvisioningRequest()
    request.address = parts.first ?? ""
    if parts.count > 1 { request.matchingID = parts[1] }
    if parts.count > 2 { request.oid = parts[2] }
    // Si ton opérateur exige un code de confirmation : request.confirmationCode = "..."

    provisioning.addPlan(with: request) { addResult in
      DispatchQueue.main.async {
        switch addResult {
        case .success:
          result(true)
        case .fail:
          result(FlutterError(code: "FAIL", message: "Installation refusée", details: nil))
        default:
          result(FlutterError(code: "UNKNOWN", message: "État inconnu — vérifie l'entitlement", details: nil))
        }
      }
    }
  }
}
