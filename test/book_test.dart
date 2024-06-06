import 'package:pact_example/book.dart';
import 'package:pact_example/resository.dart';
import 'package:test/test.dart';
import 'package:pact_dart/pact_dart.dart';

void main() {
  test('empty collection', () async {
    final pact = PactMockService('BookConsumer','APIService');
    pact
      .newInteraction()
      .given('empty collection')
      .uponReceiving('a request for all books')
      .withRequest('GET', '/books')
      .willRespondWith(204, body: PactMatchers.Null()
    );

    pact.run(secure: true);

    final books = await Repository.books() ?? [];

    expect(books.length, equals(0));

    pact.writePactFile();
    pact.reset();
  });

  test('not empty collection', () async {
    final pact = PactMockService('BookConsumer','APIService');
    pact
        .newInteraction()
        .given('not empty collection')
        .uponReceiving('a request for all books')
        .withRequest('GET', '/books')
        .willRespondWith(200, body: {
      'count': PactMatchers.SomethingLike(1),
      'data': PactMatchers.EachLike([
        {
          'id': PactMatchers.uuid('f3a9cf4a-92d7-4aae-a945-63a6440b528b'),
          'title': PactMatchers.SomethingLike('Little book'),
          'description': PactMatchers.SomethingLike('A description for the book'),
        }
      ])
    }
    );

    pact.run(secure: false);

    final books = await Repository.books() ?? [];

    expect(books.length, equals(1));

    pact.writePactFile();
    pact.reset();
  });

  test('add a book without a description', () async {
    final pact = PactMockService('BookConsumer','APIService');
    pact
      .newInteraction()
      .given('inserted book without a description')
      .uponReceiving('a request for add a book')
      .withRequest('POST', '/book', body: {
        'id': PactMatchers.uuid('f3a9cf4a-92d7-4aae-a945-63a6440b528b'),
        'title': PactMatchers.SomethingLike('Little book'),
      })
      .willRespondWith(200, body: {
        'id': PactMatchers.uuid('f3a9cf4a-92d7-4aae-a945-63a6440b528b'),
        'title': PactMatchers.SomethingLike('Little book'),
      }
    );

    pact.run(secure: false);

    final Book? book = await Repository.book(title: 'A small book');

    expect(book, isNotNull);
    expect(book!.id, isNotNull);
    expect(book.title, isNotNull);

    pact.writePactFile();
    pact.reset();
  });

  test('add a book with a description', () async {
    final pact = PactMockService('BookConsumer','APIService');
    pact
      .newInteraction()
      .given('inserted book with a description')
      .uponReceiving('a request for add a book')
      .withRequest('POST', '/book')
      .willRespondWith(200, body: {
        'id': PactMatchers.uuid('f3a9cf4a-92d7-4aae-a945-63a6440b528b'),
        'title': PactMatchers.SomethingLike('Little book'),
        'description': PactMatchers.SomethingLike('A description for the book'),
      }
    );

    pact.run(secure: false);

    final Book? book = await Repository.book(title: 'A small book', description: 'A description for the book');

    expect(book, isNotNull);
    expect(book!.id, isNotNull);
    expect(book.title, isNotNull);
    expect(book.description, isNotNull);

    pact.writePactFile();
    pact.reset();
  });
}