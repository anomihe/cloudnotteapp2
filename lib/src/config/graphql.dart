import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  // static HttpLink httpLink = HttpLink(
  //   "https://api-v3.cloudnottapp2.com/graphql",
  // );
  // static HttpLink httpLink = HttpLink(
  //   "https://staging-api-v3.cloudnottapp2.com/graphql",

  // );
  static HttpLink httpLink = HttpLink(
  //  "https://staging-api-v3.cloudnottapp2.com/graphql",
    "https://api-v3.cloudnottapp2.com/graphql",
    defaultHeaders: {
      "Cache-Control": "no-cache",
      "Pragma": "no-cache",
    },
  );

  Future<GraphQLClient> clientToQuery({String? token}) async {
    await initHiveForFlutter();
    final store = HiveStore(await HiveStore.openBox(HiveStore.defaultBoxName));
    final cache = GraphQLCache(store: store);

    if (token != null && token.isNotEmpty) {
      final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
      final Link link = authLink.concat(httpLink);
      return GraphQLClient(
        link: link,
        cache: GraphQLCache(),
        queryRequestTimeout: Duration(seconds: 15),
      );
    } else {
      return GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      );
    }
  }
}

class GraphQLConfig2 {
  static HttpLink httpLink = HttpLink(
    "https://learn-api.cloudnottapp2.com/graphql",
    defaultHeaders: {
      'Connection': 'keep-alive', // Optional: Keep connection alive
    },
  );

  Future<GraphQLClient> clientToQuery({String? token}) async {
    await initHiveForFlutter();
    final store = HiveStore(await HiveStore.openBox(HiveStore.defaultBoxName));
    final cache = GraphQLCache(store: store);

    final Link link = token != null && token.isNotEmpty
        ? AuthLink(getToken: () async => 'Bearer $token').concat(httpLink)
        : httpLink;

    return GraphQLClient(
      link: link,
      cache: cache,
      queryRequestTimeout: Duration(seconds: 60),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
      ),
    );
  }
}
