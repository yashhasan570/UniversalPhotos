import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:universal_photos_mobile/infrastructure/repositories/network.repository.dart';
import 'package:universal_photos_mobile/services/api.service.dart';

void main() {
  List<Request> redirect(String from, String to) {
    final requests = <Request>[];
    NetworkRepository.client = MockClient((request) async {
      requests.add(request);
      final address = request.url.toString();
      if (address.startsWith(from)) {
        return Response('', 308, headers: {'location': address.replaceFirst(from, to)}, isRedirect: true);
      }
      return switch (request.url.path) {
        '/.well-known/universal_photos' => Response('{"api":{"endpoint":"/api"}}', 200),
        '/api/server/ping' => Response('{"res":"pong"}', 200),
        _ => Response('', 404),
      };
    });
    return requests;
  }

  group('resolveEndpoint', () {
    test('Should use https when the server redirects http to https', () async {
      redirect('http://universal_photos.test', 'https://universal_photos.test');

      expect(await ApiService().resolveEndpoint('http://universal_photos.test'), 'https://universal_photos.test/api');
    });

    test('Should throw before sending anything to another server the address redirects to', () async {
      final requests = redirect('http://universal_photos.test', 'https://other.test');

      await expectLater(
        ApiService().resolveEndpoint('http://universal_photos.test'),
        throwsA(isA<ServerRedirectException>().having((e) => e.to.origin, 'to', 'https://other.test')),
      );
      expect(requests.single.followRedirects, isFalse);
    });
  });
}
