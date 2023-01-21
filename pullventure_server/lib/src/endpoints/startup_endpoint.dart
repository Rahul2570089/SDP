import 'package:pullventure_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class StartUpEndpoint extends Endpoint {
  Future<StartUp> create(Session session, StartUp startUp) async {
    await StartUp.insert(session, startUp);
    return startUp;
  }

  Future<StartUp?> read(Session session, int id) async {
    return await StartUp.findById(session, id);
  }

  Future<List<StartUp>> readAll(Session session) async {
    return await StartUp.find(session);
  }

  Future<StartUp> update(Session session, StartUp startUp) async {
    await StartUp.update(session, startUp);
    return startUp;
  }

  Future<void> delete(Session session, int id) async {
    await StartUp.delete(session, where: (p0) => p0.id.equals(id),);
  }
}

