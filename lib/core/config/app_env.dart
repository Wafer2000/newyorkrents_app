class AppEnv {
  static const shopPublicHost  = String.fromEnvironment('SHOP_PUBLIC_HOST', defaultValue: '');
  static const myshopifyDomain = String.fromEnvironment('SHOP_MYSHOPIFY_DOMAIN', defaultValue: '');
  static const apiVersion      = String.fromEnvironment('SHOPIFY_API_VERSION', defaultValue: '2025-07');
  static const storefrontToken = String.fromEnvironment('STOREFRONT_TOKEN', defaultValue: '');
  static const pageSize        = int.fromEnvironment('PAGE_SIZE', defaultValue: 12);
  static const defaultSort     = String.fromEnvironment('DEFAULT_SORT', defaultValue: 'CREATED');
  static const defaultHandle   = String.fromEnvironment('DEFAULT_HANDLE', defaultValue: 'rooms');

  // NUEVO
  static const collectionHandlesCsv = String.fromEnvironment('COLLECTION_HANDLES', defaultValue: '');
  static List<String> get collectionHandles => collectionHandlesCsv
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty).toList();

  static const mfListCsv  = String.fromEnvironment('MF_LIST', defaultValue: '');
  static const mfRefMap   = String.fromEnvironment('MF_REF_MAP', defaultValue: '');

  static List<String> get graphqlEndpoints => [
    if (shopPublicHost.isNotEmpty) 'https://$shopPublicHost/api/$apiVersion/graphql.json',
    if (myshopifyDomain.isNotEmpty) 'https://$myshopifyDomain/api/$apiVersion/graphql.json',
  ];
}
