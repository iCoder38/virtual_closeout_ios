import Alamofire

class APIManager {
    static let shared = APIManager()

    private init() {}

    /// Reusable request method returning raw [String: Any]
    func postRequest(
        url: String,
        parameters: [String: Any],
        showLoader: Bool = true,
        viewController: UIViewController?,
        completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> Void
    ) {
        if showLoader {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }

        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseJSON { response in
            if showLoader {
                ERProgressHud.sharedInstance.hide()
            }

            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let status = json["status"] as? String, status.lowercased() == "success" {
                        completion(true, json)
                    } else {
                        let msg = json["msg"] as? String ?? "Something went wrong"
                        if let vc = viewController {
                            Utils.showAlert(alerttitle: "Error", alertmessage: msg, ButtonTitle: "Ok", viewController: vc)
                        }
                        completion(false, json)
                    }
                } else {
                    completion(false, nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let vc = viewController {
                    Utils.showAlert(alerttitle: "Server Error", alertmessage: error.localizedDescription, ButtonTitle: "Ok", viewController: vc)
                }
                completion(false, nil)
            }
        }
    }
}

