import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../banking/bank_products/providers/owned_products_provider.dart';
import '../../banking/bank_products/providers/bank_products_provider.dart';
import '../../banking/bank_products/models/bank_product.dart';
import '../../../core/database/app_database.dart';
import '../../marketplace/marketplace_provider.dart';
import '../models/financial_event.dart';

// Mock data for available event templates
final availableEventTypesProvider = Provider<List<FinancialEvent>>((ref) {
  return [
    FinancialEvent(
      id: 'template_house',
      title: 'Buying a House',
      type: FinancialEventType.buyingHouse,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Check credit score'),
        TodoItem(id: '2', title: 'Find a real estate agent'),
        TodoItem(id: '3', title: 'Get pre-approved for a mortgage'),
        TodoItem(id: '4', title: 'Start house hunting'),
        TodoItem(id: '5', title: 'Make an offer'),
        TodoItem(id: '6', title: 'Schedule home inspection'),
        TodoItem(id: '7', title: 'Close the deal'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'First-time Home Buyer Guide',
          content: 'Step by step guide to buying your first home...',
        ),
        Guide(
          id: 'g2',
          title: 'Understanding Mortgages',
          content: 'Fixed vs Variable rates explained...',
        ),
        Guide(
          id: 'g3',
          title: 'Closing Costs Checklist',
          content: 'What to expect when closing...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_baby',
      title: 'Having a Baby',
      type: FinancialEventType.havingBaby,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Find a pediatrician'),
        TodoItem(id: '2', title: 'Prepare the nursery'),
        TodoItem(id: '3', title: 'Pack hospital bag'),
        TodoItem(id: '4', title: 'Buy essential baby gear'),
        TodoItem(id: '5', title: 'Install car seat'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Newborn Essentials Checklist',
          content: 'What you really need for a newborn...',
        ),
        Guide(
          id: 'g2',
          title: 'Sleep Training 101',
          content: 'Basics of getting your baby to sleep...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_married',
      title: 'Getting Married',
      type: FinancialEventType.gettingMarried,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Set a budget'),
        TodoItem(id: '2', title: 'Choose a venue'),
        TodoItem(id: '3', title: 'Send invitations'),
        TodoItem(id: '4', title: 'Book caterer'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Wedding Planning 101',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_retirement',
      title: 'Retirement Planning',
      type: FinancialEventType.retirement,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Review retirement accounts'),
        TodoItem(id: '2', title: 'Plan healthcare coverage'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Retirement Basics',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_business',
      title: 'Starting a Business',
      type: FinancialEventType.startingBusiness,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Write business plan'),
        TodoItem(id: '2', title: 'Register business'),
        TodoItem(id: '3', title: 'Set up accounting'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Business Startup Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_university',
      title: 'Starting University',
      type: FinancialEventType.university,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Apply for student loans'),
        TodoItem(id: '2', title: 'Find accommodation'),
        TodoItem(id: '3', title: 'Buy textbooks'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'University Prep Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_school',
      title: 'Starting School',
      type: FinancialEventType.startingSchool,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Buy school supplies'),
        TodoItem(id: '2', title: 'Get uniform'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Back to School Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_christmas',
      title: 'Christmas',
      type: FinancialEventType.christmas,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Buy gifts'),
        TodoItem(id: '2', title: 'Decorate home'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Christmas Planning Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_anniversary',
      title: 'Anniversary',
      type: FinancialEventType.anniversary,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Plan celebration'),
        TodoItem(id: '2', title: 'Book restaurant'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Anniversary Ideas',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_birthday',
      title: 'Birthday',
      type: FinancialEventType.birthday,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Plan party'),
        TodoItem(id: '2', title: 'Send invitations'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Birthday Party Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_car',
      title: 'Buying a Car',
      type: FinancialEventType.buyingCar,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Research models'),
        TodoItem(id: '2', title: 'Get insurance quotes'),
        TodoItem(id: '3', title: 'Test drive vehicles'),
      ],
      guides: [
        Guide(id: 'g1', title: 'Car Buying Guide', content: 'Guide content...'),
      ],
    ),
    FinancialEvent(
      id: 'template_job',
      title: 'New Job',
      type: FinancialEventType.newJob,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Update resume'),
        TodoItem(id: '2', title: 'Buy professional attire'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'New Job Preparation',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_divorce',
      title: 'Divorce',
      type: FinancialEventType.divorce,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Consult lawyer'),
        TodoItem(id: '2', title: 'Organize finances'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Divorce Financial Guide',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_bereavement',
      title: 'Bereavement',
      type: FinancialEventType.bereavement,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Arrange funeral'),
        TodoItem(id: '2', title: 'Handle estate matters'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Bereavement Support',
          content: 'Guide content...',
        ),
      ],
    ),
    FinancialEvent(
      id: 'template_fitness',
      title: 'Getting Fit',
      type: FinancialEventType.gettingFit,
      date: DateTime.now(),
      location: '',
      selectedTodos: [
        TodoItem(id: '1', title: 'Join a gym'),
        TodoItem(id: '2', title: 'Hire a personal trainer'),
        TodoItem(id: '3', title: 'Buy workout clothes'),
        TodoItem(id: '4', title: 'Meal prep plan'),
      ],
      guides: [
        Guide(
          id: 'g1',
          title: 'Fitness 101',
          content: 'Starting your fitness journey...',
        ),
      ],
    ),
  ];
});

// ... (keep availableEventTypesProvider as is)

class FinancialEventsNotifier extends AsyncNotifier<List<FinancialEvent>> {
  @override
  Future<List<FinancialEvent>> build() {
    final database = ref.watch(appDatabaseProvider);

    // Subscribe to the stream from the database
    final stream = database.watchLifeEvents();

    // Forward stream events to the state
    final subscription = stream.listen((events) {
      final domainEvents = events.map((e) {
        return FinancialEvent(
          id: e.id,
          title: e.title,
          type: e.type,
          date: e.date,
          location: e.location,
          selectedTodos: List<TodoItem>.from(e.selectedTodos),
          guides: List<Guide>.from(e.guides),
          budget: e.budget,
          depositAmount: e.depositAmount,
        );
      }).toList();
      state = AsyncData(domainEvents);
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() => subscription.cancel());

    // Return initial empty list or current value while waiting for stream
    return Future.value([]);
  }

  Future<void> addEvent(FinancialEvent event) async {
    final database = ref.read(appDatabaseProvider);

    await database.addLifeEvent(
      LifeEventsCompanion.insert(
        id: event.id,
        title: event.title,
        type: event.type,
        date: event.date,
        location: event.location,
        selectedTodos: event.selectedTodos,
        guides: event.guides,
        budget: Value(event.budget),
        depositAmount: Value(event.depositAmount),
      ),
    );
  }

  Future<void> removeEvent(String id) async {
    final database = ref.read(appDatabaseProvider);
    await database.deleteLifeEvent(id);
  }

  Future<void> toggleTodo(String eventId, String todoId) async {
    final database = ref.read(appDatabaseProvider);

    // We need to fetch the current event, modify it, and update it.
    // Since we are inside the notifier, we might have the current state,
    // but safe to do a transaction or just update.
    // For simplicity, we'll find it in the current state.

    final currentList = state.value;
    if (currentList == null) return;

    final event = currentList.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final updatedTodos = event.selectedTodos.map((todo) {
      if (todo.id == todoId) {
        return TodoItem(
          id: todo.id,
          title: todo.title,
          isCompleted: !todo.isCompleted,
        );
      }
      return todo;
    }).toList();

    final updatedEvent = event.copyWith(selectedTodos: updatedTodos);

    // Convert back to DB entity to update
    // We created an updateLifeEvent method in AppDatabase that takes a LifeEvent (Drift generated class)
    // We need to construct a LifeEvent object.

    final driftEvent = LifeEvent(
      id: updatedEvent.id,
      title: updatedEvent.title,
      type: updatedEvent.type,
      date: updatedEvent.date,
      location: updatedEvent.location,
      selectedTodos: updatedEvent.selectedTodos,
      guides: updatedEvent.guides,
      budget: updatedEvent.budget,
      depositAmount: updatedEvent.depositAmount,
    );

    await database.updateLifeEvent(driftEvent);
  }
}

final financialEventsProvider =
    AsyncNotifierProvider<FinancialEventsNotifier, List<FinancialEvent>>(() {
      return FinancialEventsNotifier();
    });

// Provider to get marketplace recommendations for a specific event
final eventMarketplaceRecommendationsProvider =
    Provider.family<List<Product>, FinancialEvent>((ref, event) {
      final allProductsAsync = ref.watch(marketplaceProvider);

      return allProductsAsync.when(
        data: (products) {
          final keywords = _getKeywordsForEvent(event.type);
          if (keywords.isEmpty) return [];

          final eventTag = keywords.first.toLowerCase();

          final matched = products.where((product) {
            // 1. Primary match: Life event tag (e.g., 'christmas')
            if (product.tags.any((t) => t.toLowerCase() == eventTag)) {
              return true;
            }

            // 2. Secondary match: Specific keywords as whole words
            final searchString = ' ${product.title} ${product.description} '
                .toLowerCase();
            return keywords.skip(1).any((k) {
              final pattern = RegExp('\\b${RegExp.escape(k.toLowerCase())}\\b');
              return pattern.hasMatch(searchString);
            });
          }).toList();

          return matched;
        },
        loading: () => [],
        error: (err, stack) => [],
      );
    });

List<String> _getKeywordsForEvent(FinancialEventType type) {
  switch (type) {
    case FinancialEventType.buyingHouse:
      return [
        'buyingHouse',
        'security',
        'smart-home',
        'mattress',
        'sofa',
        'interior design',
        'garden',
        'patio',
      ];
    case FinancialEventType.havingBaby:
      return [
        'havingBaby',
        'baby',
        'nursery',
        'newborn',
        'stroller',
        'pram',
        'crib',
        'baby monitor',
      ];
    case FinancialEventType.gettingMarried:
      return [
        'gettingMarried',
        'wedding',
        'bridal',
        'marriage',
        'invitations',
        'honeymoon',
      ];
    case FinancialEventType.retirement:
      return ['retirement', 'estate planning', 'will', 'photography course'];
    case FinancialEventType.startingBusiness:
      return [
        'startingBusiness',
        'business formation',
        'incorporation',
        'business card',
        'office furniture',
        'office chair',
      ];
    case FinancialEventType.university:
      return ['university', 'student laptop', 'textbook rental', 'dorm room'];
    case FinancialEventType.startingSchool:
      return [
        'startingSchool',
        'school uniform',
        'backpack',
        'stationery',
        'lunchbox',
      ];
    case FinancialEventType.christmas:
      return [
        'christmas',
        'tree',
        'turkey',
        'wreath',
        'hamper',
        'baubles',
        'stocking',
        'pudding',
        'mince',
        'reindeer',
      ];
    case FinancialEventType.anniversary:
      return ['anniversary', 'spa day', 'fine dining', 'jewelry'];
    case FinancialEventType.birthday:
      return ['birthday', 'party planning', 'cake'];
    case FinancialEventType.buyingCar:
      return [
        'buyingCar',
        'gps',
        'navigation',
        'dashcam',
        'car detailing',
        'car care',
      ];
    case FinancialEventType.newJob:
      return ['newJob', 'suit', 'briefcase', 'career coaching'];
    case FinancialEventType.divorce:
      return ['divorce', 'legal advice', 'therapy'];
    case FinancialEventType.bereavement:
      return ['bereavement', 'funeral', 'memorial'];
    case FinancialEventType.gettingFit:
      return [
        'gettingFit',
        'fitness',
        'gym',
        'trainer',
        'nutrition',
        'protein',
        'yoga',
        'dumbbell',
        'weights',
        'running',
      ];
  }
}

/// Maps FinancialEventType to recommended bank product IDs
List<String> _getBankProductIdsForEvent(FinancialEventType type) {
  switch (type) {
    case FinancialEventType.buyingHouse:
      return ['mortgage_standard', 'home_insurance_safe', 'savings_plus'];
    case FinancialEventType.havingBaby:
      return ['junior_isa', 'life_insurance_family', 'savings_plus'];
    case FinancialEventType.gettingMarried:
      return ['personal_loan', 'savings_plus', 'life_insurance_family'];
    case FinancialEventType.retirement:
      return ['savings_plus', 'fixed_rate_bond', 'life_insurance_family'];
    case FinancialEventType.startingBusiness:
      return ['business_loan', 'business_account'];
    case FinancialEventType.university:
      return ['student_loan', 'student_account', 'credit_card_student'];
    case FinancialEventType.startingSchool:
      return ['junior_isa', 'savings_plus'];
    case FinancialEventType.christmas:
      return ['personal_loan', 'credit_card_gold'];
    case FinancialEventType.anniversary:
      return ['personal_loan', 'credit_card_gold'];
    case FinancialEventType.birthday:
      return ['personal_loan', 'credit_card_gold'];
    case FinancialEventType.buyingCar:
      return ['car_loan', 'car_insurance_compare'];
    case FinancialEventType.newJob:
      return ['premier_account', 'credit_card_gold'];
    case FinancialEventType.divorce:
      return ['personal_loan', 'basic_account'];
    case FinancialEventType.bereavement:
      return ['life_insurance_family', 'savings_plus'];
    case FinancialEventType.gettingFit:
      return ['health_insurance_vital', 'personal_loan'];
  }
}

/// Provider that returns relevant bank products for a life event
final eventBankProductsProvider =
    Provider.family<List<BankProduct>, FinancialEventType>((ref, eventType) {
      final allProducts = ref.watch(bankProductsProvider);
      final recommendedIds = _getBankProductIdsForEvent(eventType);

      return allProducts
          .where((product) => recommendedIds.contains(product.id))
          .toList();
    });
