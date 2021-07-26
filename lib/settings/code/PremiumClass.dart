import 'dart:async';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


const playStoreId = 'premium_plan';

class Premium{

  //In-app purchases instance
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  //Products for sale
  static List<ProductDetails> _products = [];
  //Past purchases
  static List<PurchaseDetails> _purchases = [];
  //Updates to purchase
  static StreamSubscription? _subscription;
  

  /// Initialize In-app purchases plugin.
  static Future<void> initializePlugin() async {

    // check if the plugin is available
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      print('In-app purchase plugin is not available');
    }else{
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

      await Future.wait([
      _getProducts(),
      _inAppPurchase.restorePurchases()
      ]);

      _subscription = purchaseUpdated.listen((purchase) async {
        purchase.forEach((element) {print(element.verificationData.localVerificationData);});
        await _getPastPurchases(purchase);
        await _verifyPurchase();
      },
      onDone: ()=> _subscription!.cancel(),
      onError: (e)=> print(e)
      );
    }
  }
  
  /// Check if the user has purchased the premium_plan, if purchased return the product details.
  static PurchaseDetails? _hasPurchased(){
    return _purchases.firstWhere((purchase) => purchase.productID == playStoreId);
  }

  /// Subcribe to the premium plan through google play store.
  static Future<void> buyProduct() async {
    ProductDetails? product = _products.firstWhere((product) => product.id == playStoreId);
    print('i want to buy ${product.id} ${product.description} ${product.price} ${GoogleUserData.instance.userEmail}');

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Get the product details for the premium_plan and add it to the _products list.
  static Future<void> _getProducts() async {
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({playStoreId});
    _products.addAll(response.productDetails);
  }

  /// Check if the user has purchased the premium_plan, if purchased then call the completePurchase on it.
  static Future<void> _verifyPurchase() async {
    PurchaseDetails? purchase = _hasPurchased();

    if (purchase != null && purchase.status == PurchaseStatus.purchased){
      await _inAppPurchase.completePurchase(purchase);
      print('purchase ${purchase.verificationData.localVerificationData}');
    }else if(purchase != null && purchase.status == PurchaseStatus.pending){
      await _inAppPurchase.completePurchase(purchase);
    }else if (purchase != null && purchase.status == PurchaseStatus.restored){
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  /// Check if the user has purchased the premium_plan, this returns True if has purchased does not return null.
  static bool get isPremiumUser => (_hasPurchased() != null) ? true : false;
  
  /// Completed all the purchases in user purchase list and then add it to the _purchases list.
  static Future<void> _getPastPurchases(List<PurchaseDetails> purchaseDetailsList) async { 

    for (PurchaseDetails purchase in purchaseDetailsList) {
      final pending = purchase.pendingCompletePurchase;
      if(pending){
         await _inAppPurchase.completePurchase(purchase);
      }

      if(purchase.error != null){
        print('the errors are ${purchase.error}');
      }else _purchases.add(purchase);

    }
  }

}