/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/anonymous_idp_endpoint.dart' as _in0zita6;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../auth/username_auth_endpoint.dart' as _iyfwvj9b;
import '../endpoints/public_feed_endpoint.dart' as _ilzpnpna;
import '../endpoints/user_endpoint.dart' as _iymy5306;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    initializeOwnEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeOwnEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeOwnEndpoints(server);
  }

  @override
  void initializeOwnEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'anonymousIdp': _in0zita6.AnonymousIdpEndpoint()
        ..initialize(
          server,
          'anonymousIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'usernameAuth': _iyfwvj9b.UsernameAuthEndpoint()
        ..initialize(
          server,
          'usernameAuth',
          null,
        ),
      'publicFeed': _ilzpnpna.PublicFeedEndpoint()
        ..initialize(
          server,
          'publicFeed',
          null,
        ),
      'user': _iymy5306.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['anonymousIdp'] = _is.EndpointConnector(
      name: 'anonymousIdp',
      endpoint: endpoints['anonymousIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['anonymousIdp'] as _in0zita6.AnonymousIdpEndpoint)
                      .login(
                        session,
                        token: params['token'],
                      ),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['usernameAuth'] = _is.EndpointConnector(
      name: 'usernameAuth',
      endpoint: endpoints['usernameAuth']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'pseudo': _is.ParameterDescription(
              name: 'pseudo',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['usernameAuth'] as _iyfwvj9b.UsernameAuthEndpoint)
                      .register(
                        session,
                        params['pseudo'],
                        params['password'],
                      ),
        ),
        'signIn': _is.MethodConnector(
          name: 'signIn',
          params: {
            'pseudo': _is.ParameterDescription(
              name: 'pseudo',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['usernameAuth'] as _iyfwvj9b.UsernameAuthEndpoint)
                      .signIn(
                        session,
                        params['pseudo'],
                        params['password'],
                      ),
        ),
      },
    );
    connectors['publicFeed'] = _is.EndpointConnector(
      name: 'publicFeed',
      endpoint: endpoints['publicFeed']!,
      methodConnectors: {
        'listDuels': _is.MethodConnector(
          name: 'listDuels',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicFeed'] as _ilzpnpna.PublicFeedEndpoint)
                      .listDuels(
                        session,
                        limit: params['limit'],
                      ),
        ),
        'listVotes': _is.MethodConnector(
          name: 'listVotes',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicFeed'] as _ilzpnpna.PublicFeedEndpoint)
                      .listVotes(
                        session,
                        params['duelId'],
                      ),
        ),
        'countVotes': _is.MethodConnector(
          name: 'countVotes',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicFeed'] as _ilzpnpna.PublicFeedEndpoint)
                      .countVotes(
                        session,
                        params['duelId'],
                      ),
        ),
        'authorName': _is.MethodConnector(
          name: 'authorName',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicFeed'] as _ilzpnpna.PublicFeedEndpoint)
                      .authorName(
                        session,
                        params['authUserId'],
                      ),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'createDuel': _is.MethodConnector(
          name: 'createDuel',
          params: {
            'question': _is.ParameterDescription(
              name: 'question',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'optionAText': _is.ParameterDescription(
              name: 'optionAText',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'optionAUrl': _is.ParameterDescription(
              name: 'optionAUrl',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'optionBText': _is.ParameterDescription(
              name: 'optionBText',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'optionBUrl': _is.ParameterDescription(
              name: 'optionBUrl',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).createDuel(
                    session,
                    params['question'],
                    params['type'],
                    params['optionAText'],
                    params['optionAUrl'],
                    params['optionBText'],
                    params['optionBUrl'],
                  ),
        ),
        'vote': _is.MethodConnector(
          name: 'vote',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'choix': _is.ParameterDescription(
              name: 'choix',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint).vote(
                session,
                params['duelId'],
                params['choix'],
              ),
        ),
        'updateProfile': _is.MethodConnector(
          name: 'updateProfile',
          params: {
            'pseudo': _is.ParameterDescription(
              name: 'pseudo',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).updateProfile(
                    session,
                    params['pseudo'],
                  ),
        ),
        'uploadImage': _is.MethodConnector(
          name: 'uploadImage',
          params: {
            'bytes': _is.ParameterDescription(
              name: 'bytes',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).uploadImage(
                    session,
                    params['bytes'],
                    params['fileName'],
                  ),
        ),
        'deleteDuel': _is.MethodConnector(
          name: 'deleteDuel',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).deleteDuel(
                    session,
                    params['duelId'],
                  ),
        ),
      },
    );
  }
}
