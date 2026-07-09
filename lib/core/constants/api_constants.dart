class ApiConstants {
  static const String baseUrl = 'https://zeron-3000.ssh.bd';

  // General
  static const String config = '/api/v1/config';
  static const String banners = '/api/v1/banners';
  static const String categories = '/api/v1/categories';
  static const String popularFoods = '/api/v1/products/popular';
  static const String foodCampaigns = '/api/v1/campaigns/item';

  static String restaurants(int offset, int limit) =>
      '/api/v1/restaurants/get-restaurants/all?offset=$offset&limit=$limit';

  // Auth endpoints
  static const String authRegister = '/api/v1/auth/register';
  static const String authVerifyOtp = '/api/v1/auth/verify-otp';
  static const String authLogin = '/api/v1/auth/login';
  static const String authForgotPassword = '/api/v1/auth/forgot-password';
  static const String authResetPassword = '/api/v1/auth/reset-password';
  static const String authRefreshToken = '/api/v1/auth/refresh-token';
  static const String authLogout = '/api/v1/auth/logout';
  static const String authSocialLogin = '/api/v1/auth/social-login';


  //Get My Profile
  static const String getMyProfile = '/api/v1/auth/me';
  static const String updateProfile = '/api/v1/users/profile';

  //Active offers 
  static const String activeOffers = '/api/v1/meters/my-meters';





  //Referral
  static const String getMyReferralCode = '/api/v1/referrals/my-code';
  static const String getListMyReferral = '/api/v1/referrals/my-referrals?page=1&limit=20';
  static const String createReferral = '/api/v1/referrals/invite';



  //Suppliers
  static const String getSuppliers = '/api/v1/suppliers?page=1&limit=20';
  static const String getSupplierDetails = '/api/v1/suppliers/{{supplierId}}';


  //Offers
  static const String getActiveOffers = '/api/v1/offers?page=1&limit=20';
  static const String getOfferDetails = '/api/v1/offers/{{offerId}}'; 
  static const String getCompareOffers = '/api/v1/offers/compare?ids={{offerId}},o2b3c4d5-e6f7-8901-bcde-f23456789012';
  static const String getRecomndedOffer = '/api/v1/offers/recommended/a1b2c3d4-e5f6-7890-abcd-ef1234567890';
  
  //Agreements
  static const String getListMyAgreements = '/api/v1/agreements/my-agreements';
  static const String getMyAgreementDetails = '/api/v1/agreements/my-agreements/{{agreementId}}';




  //Bills
  static const String uploadBills = '/api/v1/bills/upload';
  static const String getMyBills = '/api/v1/bills?page=1&limit=20';
  static const String getMyBillDetails = '/api/v1/bills/{{billId}}';
  static const String billAnalysis = '/api/v1/bills/{{billId}}/analyze';
  static const String getBillAnalysis = '/api/v1/bills/{{billId}}/analysis';



  // Default headers (can be extended at request time)
  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // Cache keys
  static const String cacheBanners = 'banners';
  static const String cacheCategories = 'categories';
  static const String cachePopularFoods = 'popularFoods';
  static const String cacheFoodCampaigns = 'foodCampaigns';
  static const String cacheRestaurants = 'restaurants';
  static const String cacheRestaurantsTotalSize = 'restaurantsTotalSize';
}

