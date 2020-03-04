import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

// servicesvideofeed
// servicesfeed
class CreateNewService {



  Future<int> addService(String price, String serviceCategoryName,
  String serviceOffered, String servicePhotoUrl, String uid, String serviceProviderToken,
  bool statusNotRequired, bool isVideo, String description, bool isPremium, String website,
  String shippingAddress, String subCategory, String actualPrice, String _timeTaken, String 
  country, String collectionType, String location, String phoneNumber, double longitude, 
  double latitude, String profilePicture, String fullName,
  String docID
  ) async {
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var  currentUser =  await Firestore.instance.collection('paymentplan')
     .document(uid).get();
    if(currentUser.data['lastBalance'] > 100000 && currentUser.data['countryCode'] == 'UG') {
      await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     }else if (currentUser.data['lastBalance'] > 4237 && currentUser.data['countryCode'] == 'KE'){
await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     } else if (currentUser.data['lastBalance'] > 224 && currentUser.data['countryCode'] == 'GH'){
await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     }else if (currentUser.data['lastBalance'] > 606 && currentUser.data['countryCode'] == 'ZA'){
await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     }else if (currentUser.data['lastBalance'] > 93796 && currentUser.data['countryCode'] == 'TZ'){
await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     }else if (currentUser.data['lastBalance'] > 41  && 
     currentUser.data['countryCode'] != 'UG' && 
     currentUser.data['countryCode'] != 'TZ' && 
     currentUser.data['countryCode'] != 'ZA' && 
     currentUser.data['countryCode'] != 'GH' && 
     currentUser.data['countryCode'] != 'KE'){
await Firestore.instance.collection('paymentplan').document(uid).setData({
        'isPremium': true
      }, merge: true);

     await Firestore.instance.collection('referalEngine').document(uid).setData({
        'isPremium': false
      }, merge: true);

      await Firestore.instance.collection('saloonServiceProvider').document(uid).setData({
        'isRequested': true
      }, merge: true);

      return Future.value(443);
     }else {
      //final docID = randomAlpha(12);
      // keep copy for services_feed for user
      // await Firestore.instance.collection('saloonServiceProvider')
      // .document(uid).collection('services_provided').add(<String, dynamic>{
      // 'price': price,
      // 'time': _timeTaken,
      // 'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'serviceCategoryName': serviceCategoryName,
      // 'serviceOffered': serviceOffered,
      // 'servicePhotoUrl': servicePhotoUrl,
      // 'uid': uid,
      // 'serviceProviderToken': serviceProviderToken,
      // 'statusNotRequired': statusNotRequired,
      // 'isVideo': isVideo,
      // 'description': description,
      // 'isPremium': false,
      // 'website': website,
      // 'shippingAddress': shippingAddress,
      // 'subCategory': subCategory,
      // 'country': country,
      // 'docID': docID,
      // 'location': location,
      // 'phoneNumber': phoneNumber,
      // 'longitude': longitude,
      // 'latitude': latitude,
      // 'profilePicture': profilePicture,
      // 'fullName': fullName,
      // 'fcm_token': prefs.getString('fcm_token'),
      // 'videoDefault': 'https://firebasestorage.googleapis.com/v0/b/esalonbusiness-d3f3d.appspot.com/o/snowyscreen.gif?alt=media&token=35458d60-5e73-4e7e-ae13-aad26ff095ec'
      // });
      
      Firestore.instance.collection('servicesfeed').document(docID).setData(<String, dynamic>{
      'price': price,
      'time': _timeTaken,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      'serviceCategoryName': serviceCategoryName,
      'serviceOffered': serviceOffered,
      'servicePhotoUrl': servicePhotoUrl,
      'uid': uid,
      'serviceProviderToken': serviceProviderToken,
      'statusNotRequired': statusNotRequired,
      'isVideo': isVideo,
      'description': description,
      'isPremium': false,
      'website': website,
      'shippingAddress': shippingAddress,
      'subCategory': subCategory,
      'country': country,
      'docID': docID,
      'location': location,
      'phoneNumber': phoneNumber,
      'longitude': longitude,
      'latitude': latitude,
      'profilePicture': prefs.getString('profilePicture'),
      'fullName': fullName,
      'fcm_token': prefs.getString('fcm_token'),
      'videoDefault': 'https://firebasestorage.googleapis.com/v0/b/esalonbusiness-d3f3d.appspot.com/o/snowyscreen.gif?alt=media&token=35458d60-5e73-4e7e-ae13-aad26ff095ec'
    }).then((onValue){
      if(isVideo){
         Firestore.instance.collection('servicesvideofeed').document(docID).setData(<String, dynamic>{
      'price': price,
      'time': _timeTaken,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      'serviceCategoryName': serviceCategoryName,
      'serviceOffered': serviceOffered,
      'servicePhotoUrl': servicePhotoUrl,
      'uid': uid,
      'serviceProviderToken': serviceProviderToken,
      'statusNotRequired': statusNotRequired,
      'isVideo': isVideo,
      'description': description,
      'isPremium': false,
      'website': website,
      'shippingAddress': shippingAddress,
      'subCategory': subCategory,
      'country': country,
      'docID': docID,
      'location': location,
      'phoneNumber': phoneNumber,
      'longitude': longitude,
      'latitude': latitude,
      'profilePicture': prefs.getString('profilePicture'),// profilePicture
      'fullName': fullName,
      'fcm_token': prefs.getString('fcm_token'),
      'videoDefault': 'https://firebasestorage.googleapis.com/v0/b/esalonbusiness-d3f3d.appspot.com/o/snowyscreen.gif?alt=media&token=35458d60-5e73-4e7e-ae13-aad26ff095ec'
    }).then((onValue){
      print('done');
    });
    print('done pictures');
      }
    });

    
  

    return Future.value(1);
    }
    }catch(e){
      print(e);
     return Future.value(0);
    }
  }
}

final CreateNewService serviceCreator = CreateNewService();
