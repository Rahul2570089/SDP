import 'package:pullventure_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class InvestorEndpoint extends Endpoint {
  Future<Investor> create(Session session, Investor investor) async {
    await Investor.insert(session, investor);
    return investor;
  }

  Future<Investor?> read(Session session, int id) async {
    return await Investor.findById(session, id);
  }

  Future<List<Investor>> readAll(Session session) async {
    return await Investor.find(session);
  }

  Future<Investor> update(Session session, Investor investor) async {
    await Investor.update(session, investor);
    return investor;
  }

  Future<void> delete(Session session, int id) async {
    await Investor.delete(session, where: (p0) => p0.id.equals(id),);
  }
}

