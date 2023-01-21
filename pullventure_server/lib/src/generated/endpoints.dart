/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/example_endpoint.dart' as _i2;
import '../endpoints/investor_endpoint.dart' as _i3;
import '../endpoints/startup_endpoint.dart' as _i4;
import 'package:pullventure_server/src/generated/investor_class.dart' as _i5;
import 'package:pullventure_server/src/generated/startup_class.dart' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'example': _i2.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'investor': _i3.InvestorEndpoint()
        ..initialize(
          server,
          'investor',
          null,
        ),
      'startUp': _i4.StartUpEndpoint()
        ..initialize(
          server,
          'startUp',
          null,
        ),
    };
    connectors['example'] = _i1.EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['example'] as _i2.ExampleEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    connectors['investor'] = _i1.EndpointConnector(
      name: 'investor',
      endpoint: endpoints['investor']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'investor': _i1.ParameterDescription(
              name: 'investor',
              type: _i1.getType<_i5.Investor>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['investor'] as _i3.InvestorEndpoint).create(
            session,
            params['investor'],
          ),
        ),
        'read': _i1.MethodConnector(
          name: 'read',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['investor'] as _i3.InvestorEndpoint).read(
            session,
            params['id'],
          ),
        ),
        'readAll': _i1.MethodConnector(
          name: 'readAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['investor'] as _i3.InvestorEndpoint).readAll(session),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'investor': _i1.ParameterDescription(
              name: 'investor',
              type: _i1.getType<_i5.Investor>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['investor'] as _i3.InvestorEndpoint).update(
            session,
            params['investor'],
          ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['investor'] as _i3.InvestorEndpoint).delete(
            session,
            params['id'],
          ),
        ),
      },
    );
    connectors['startUp'] = _i1.EndpointConnector(
      name: 'startUp',
      endpoint: endpoints['startUp']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'startUp': _i1.ParameterDescription(
              name: 'startUp',
              type: _i1.getType<_i6.StartUp>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['startUp'] as _i4.StartUpEndpoint).create(
            session,
            params['startUp'],
          ),
        ),
        'read': _i1.MethodConnector(
          name: 'read',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['startUp'] as _i4.StartUpEndpoint).read(
            session,
            params['id'],
          ),
        ),
        'readAll': _i1.MethodConnector(
          name: 'readAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['startUp'] as _i4.StartUpEndpoint).readAll(session),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'startUp': _i1.ParameterDescription(
              name: 'startUp',
              type: _i1.getType<_i6.StartUp>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['startUp'] as _i4.StartUpEndpoint).update(
            session,
            params['startUp'],
          ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['startUp'] as _i4.StartUpEndpoint).delete(
            session,
            params['id'],
          ),
        ),
      },
    );
  }
}
