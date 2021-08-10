import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


const playStoreId = 'premium_plan';

/// This class contains information about the user's current plan.
class Premium with ChangeNotifier{

  // Creating a singleton instance of premium.
  Premium._();
  static Premium instance = Premium._();

  //In-app purchases instance
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  //Products for sale
  static List<ProductDetails> _products = [];
  //Past purchases
  static List<PurchaseDetails> _purchases = [];
  //Updates to purchase
  static StreamSubscription? _subscription;

  static DateTime? _transactionDate;
  static DateTime? _expirationDate;

  DateTime? get premiumPurchaseDate => _transactionDate;
  DateTime? get premiumExpirationDate => _expirationDate;

  /// we are going to use this value to check the user's subscription status when networkConnectivity is not available.
  bool? userIsPremiumWhenOffline;
  

  /// Initialize In-app purchases plugin.
  Future<void> initializePlugin() async {

    // check if the plugin is available
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-app purchase plugin is not available');
    }else{
      await updateUserSubcriptionStatus();
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream; 

      _subscription = purchaseUpdated.listen((purchase) async {
        purchase.forEach((element) {debugPrint(element.verificationData.localVerificationData);});
        await _getPastPurchases(purchase);
        await _completePurchase();

        // Notify the listeners about update to stream.
        notifyListeners();
      },
      onDone: ()=> _subscription!.cancel(),
      onError: (e)=> debugPrint(e)
      );

      await Future.wait([
      _getProducts(),
      _inAppPurchase.restorePurchases()
      ]);

    }
  }
  
  /// Check if the user has purchased the premium_plan, if purchased return the product details.
  static PurchaseDetails? _hasPurchased(){
    if(_purchases.isNotEmpty)
    return _purchases.firstWhere((purchase) => purchase.productID == playStoreId);
    else
    return null;
  }

  /// Subcribe to the premium plan through google play store.
  static Future<void> buyProduct() async {
    ProductDetails? product = _products.firstWhere((product) => product.id == playStoreId);

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Get the product details for the premium_plan and add it to the _products list.
  static Future<void> _getProducts() async {
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({playStoreId});
    _products.addAll(response.productDetails);
  }

  /// Check if the user has purchased the premium_plan, if purchased then call the completePurchase on it.
  static Future<void> _completePurchase() async {
    PurchaseDetails? purchase = _hasPurchased();

    if (purchase != null && purchase.status == PurchaseStatus.purchased){
      await _inAppPurchase.completePurchase(purchase);
      debugPrint('purchase ${purchase.verificationData.localVerificationData}');
    }else if(purchase != null && purchase.status == PurchaseStatus.pending){
      await _inAppPurchase.completePurchase(purchase);
    }else if (purchase != null && purchase.status == PurchaseStatus.restored){
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  /// Check if the user has purchased the premium_plan, this returns True if has purchased does not return null.
  bool get isPremiumUser => (_hasPurchased() != null) ? true : false;
  
  /// Completed all the purchases in user purchase list and then add it to the _purchases list.
  Future<void> _getPastPurchases(List<PurchaseDetails> purchaseDetailsList) async { 

    for (PurchaseDetails purchase in purchaseDetailsList) {
      final pending = purchase.pendingCompletePurchase;
      if(pending){
         await _inAppPurchase.completePurchase(purchase);
      }
      

      // Intialize the date only once, if they are null.
      if (_transactionDate == null && _expirationDate == null){
        _transactionDate = DateTime.fromMillisecondsSinceEpoch(int.parse(purchase.transactionDate!));
        _expirationDate = _transactionDate!.add(Duration(days: 372));

        /*In case of Auto-Renewal of subscription. while the expirationDate is before the current time assign 
        the expirationDate to the transactionDate(Because the auto-renew date will be the date it expired).
        Then add the 372 days(Because of the grace period) to the new expirationDate.
        */
        while (_expirationDate!.isBefore(DateTime.now())){
          _transactionDate = _expirationDate;
          _expirationDate = _transactionDate!.add(Duration(days: 372));
        }

        /// After all the process above has been performed then call the native code to set the expirationDate of the subscription.
        await NativeCodeCaller.instance.setPremiumExpirationDate(premiumExpirationDateInMillis: _expirationDate!.millisecondsSinceEpoch);
        /// Then update the user subscription status.
        await updateUserSubcriptionStatus();

        debugPrint("TranscationDate: $_transactionDate \n ExpirationDate: $_expirationDate");
      }


      if(purchase.error != null){
        debugPrint('the errors are ${purchase.error}');
      }else _purchases.add(purchase);

    }
  }

  /// This is done by recalling the getUserIsPremium method of the native code.
  Future<void> updateUserSubcriptionStatus() async {
    userIsPremiumWhenOffline = await NativeCodeCaller.instance.getUserIsPremium();
  }
}