import 'dart:math';
import '../marketplace_provider.dart';

class StubDataGenerator {
  static const _sellers = [
    'Prime Mortgages',
    'Family First Insurance',
    'Elite Fitness Co',
    'Dream Weddings',
    'Tech Supplies Inc',
    'Legal Eagles',
    'Baby Bliss',
    'Global Travels',
    'Party Central',
    'Academic Excellence',
    'Home Comforts',
  ];

  static const _locations = [
    'New York, NY',
    'London, UK',
    'San Francisco, CA',
    'Austin, TX',
    'Chicago, IL',
    'Miami, FL',
    'Seattle, WA',
    'Boston, MA',
  ];

  // Helper to get list of images for a category
  static List<String> _getImages(String category) {
    return [
      'assets/stubbed_images/${category}_1.jpg',
      'assets/stubbed_images/${category}_2.jpg',
      'assets/stubbed_images/${category}_3.jpg',
    ];
  }

  static final _categories = {
    'housing': {
      'images': _getImages('housing'),
      'tags': [
        'buyingHouse',
        'smart-home',
        'interior design',
        'sofa',
        'mattress',
      ],
      'titles': [
        'Mortgage Broker Consultation',
        'Interior Design Package',
        'Smart Home Security System',
        'Moving Services',
        'Home Staging Consultation',
        'Premium Queen Mattress',
        'Luxury Sectional Sofa',
        'Garden Landscaping Service',
        'Patio Furniture Set',
        'Kitchen Renovation Quote',
      ],
    },
    'baby': {
      'images': _getImages('baby'),
      'tags': ['havingBaby', 'nursery', 'stroller', 'newborn'],
      'titles': [
        'Premium Baby Stroller',
        'Complete Nursery Set',
        'Newborn Photography Session',
        'Organic Baby Clothes Bundle',
        'Smart Baby Monitor',
        'Baby Proofing Service',
        'Lactation Consultant Visit',
        'Doula Services',
        'Diaper Subscription',
        'Convertible Car Seat',
      ],
    },
    'wedding': {
      'images': _getImages('wedding'),
      'tags': ['gettingMarried', 'wedding', 'bridal', 'invitations'],
      'titles': [
        'Full Wedding Planning',
        'Bridal Makeup Package',
        'Wedding Photography',
        'Custom Wedding Invitations',
        'Venue Styling Service',
        'Live Wedding Band',
        'Floral Arrangements Quote',
        'Honeymoon Planning',
        'Wedding Cake Tasting',
        'Groom Suit Tailoring',
      ],
    },
    'business': {
      'images': _getImages('business'),
      'tags': ['startingBusiness', 'marketing', 'office', 'incorporation'],
      'titles': [
        'Business Incorporation Package',
        'SEO & Marketing Audit',
        'Office Ergonomics Setup',
        'Professional Headshots',
        'Business Card Design',
        'Accounting Software Subscription',
        'Legal Retainer - Business',
        'Co-working Space Membership',
        'Virtual Assistant Service',
        'Branding Consultation',
      ],
    },
    'education': {
      'images': _getImages('education'),
      'tags': ['university', 'startingSchool', 'student', 'tuition'],
      'titles': [
        'University Admissions Consulting',
        'SAT/ACT Prep Course',
        'Student Laptop Bundle',
        'Textbook Rental Subscription',
        'Private Math Tutoring',
        'Language Learning Course',
        'Study Abroad Program',
        'Dorm Room Essentials Kit',
        'Career Counseling Session',
        'Coding Bootcamp',
      ],
    },
    'fitness': {
      'images': _getImages('fitness'),
      'tags': ['gettingFit', 'gym', 'yoga', 'nutrition'],
      'titles': [
        'Personal Training Session',
        'Gym Membership - Monthly',
        'Yoga Class Pass',
        'Nutrition Plan Customization',
        'Home Gym Equipment Set',
        'Protein Powder Subscription',
        'Fitness Tracker Watch',
        'Online Workout App',
        'Marathon Training Guide',
        'Healthy Meal Delivery',
      ],
    },
    'legal': {
      'images': _getImages('legal'),
      'tags': ['divorce', 'bereavement', 'will', 'legal advice'],
      'titles': [
        'Will & Testament Creation',
        'Family Law Consultation',
        'Divorce Mediation Service',
        'Estate Planning Package',
        'Contract Review',
        'Immigration Legal advice',
        'Intellectual Property Filing',
        'Tenant Dispute Resolution',
        'Power of Attorney Setup',
        'Notary Public Service',
      ],
    },
    'party': {
      'images': _getImages('party'),
      'tags': ['birthday', 'christmas', 'anniversary', 'party'],
      'titles': [
        'Birthday Party Planner',
        'Custom Cake Design',
        'Balloon Arch Decoration',
        'Event DJ Service',
        'Catering Buffet Quote',
        'Photo Booth Rental',
        'Christmas Tree Delivery',
        'Holiday Lighting Installation',
        'Surprise Gift Concierge',
        'Magician for Kids Party',
      ],
    },
    'travel': {
      'images': _getImages('travel'),
      'tags': ['vacation', 'trip'],
      'titles': [
        'Luxury Caribbean Cruise',
        'European Rail Pass',
        'Car Insurance Quote',
        'Travel Insurance Package',
        'Airport Transfer Service',
        'Weekend Getaway Package',
        'Guided City Tour',
        'Rental Car Upgrade',
        'Safari Adventure Quote',
        'Scuba Diving Course',
      ],
    },
    'retirement': {
      'images': _getImages('retirement'),
      'tags': ['retiring', 'pension', 'investment'],
      'titles': [
        'Retirement Planning Review',
        'Pension Pot Consolidation',
        'Senior Living Consultation',
        'Investment Portfolio Audit',
        'Estate Planning Basics',
        'Travel Insurance 65+',
        'Downsizing Consultation',
        'Grandparent Trust Fund',
        'Healthcare Supplement Plan',
        'Social Club Membership',
      ],
    },
    'automotive': {
      'images': _getImages('car'),
      'tags': ['buyingCar', 'insurance', 'driving'],
      'titles': [
        'Luxury Car Lease Deal',
        'Comprehensive Car Insurance',
        'Electric Vehicle Charging Home Install',
        'Classic Car Valuation',
        'Fleet Management Software',
        'Driving School Package',
        'Car Detailing Service',
        'Roadside Assistance Plan',
        'Winter Tyres Set',
        'Mechanic Consultation',
      ],
    },
  };

  List<Product> generateStubs(int count) {
    final random = Random();
    final products = <Product>[];
    final categoryKeys = _categories.keys.toList();

    for (int i = 0; i < count; i++) {
      final categoryKey = categoryKeys[random.nextInt(categoryKeys.length)];
      final category = _categories[categoryKey]!;
      final titles = category['titles'] as List<String>;
      final title = titles[random.nextInt(titles.length)];
      final tags = [...(category['tags'] as List<String>), categoryKey];

      final images = category['images'] as List<String>;
      final image = images[random.nextInt(images.length)];

      final sellerName = _sellers[random.nextInt(_sellers.length)];
      final sellerId =
          'seller_${sellerName.toLowerCase().replaceAll(' ', '_')}';

      // Weigh towards one_time
      String purchaseType;
      final typeRoll = random.nextDouble();
      if (typeRoll < 0.6) {
        purchaseType = 'one_time';
      } else if (typeRoll < 0.85) {
        purchaseType = 'subscription';
      } else {
        purchaseType = 'quote_required';
      }

      int price = 0;
      if (purchaseType != 'quote_required') {
        price = (random.nextInt(500) + 10) * 100; // $10 to $510
      }

      // Generate varied fulfillment journeys
      Map<String, dynamic> fulfillmentJourney;
      final fulfillmentRoll = random.nextDouble();

      if (fulfillmentRoll < 0.25) {
        // WhatsApp Journey
        fulfillmentJourney = {
          'type': 'whatsapp',
          'config': {
            'phone': '+1555${random.nextInt(9000) + 1000}',
            'message_template':
                'Hi $sellerName, I am interested in $title. Can you provide more details?',
          },
        };
      } else if (fulfillmentRoll < 0.50) {
        // External Link Journey
        fulfillmentJourney = {
          'type': 'link',
          'config': {
            'url':
                'https://example.com/products/${title.replaceAll(' ', '-').toLowerCase()}',
            'button_text': 'Buy on Website',
          },
        };
      } else if (fulfillmentRoll < 0.75) {
        // Voucher Journey
        fulfillmentJourney = {
          'type': 'voucher',
          'config': {
            'code': 'SAVE${random.nextInt(50) + 10}',
            'instructions':
                'Show this code at checkout to receive your discount.',
          },
        };
      } else {
        // Manual/In-App Journey (Default)
        fulfillmentJourney = {'type': 'manual', 'config': {}};
      }

      final id =
          'prod_${i}_${title.toLowerCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^a-z0-9_]'), '')}';

      products.add(
        Product(
          id: id,
          title: title,
          description:
              'A generic description for $title providing excellent value and service.',
          price: price,
          currencyCode: 'USD',
          variants: [],
          seller: Seller(
            id: sellerId,
            name: sellerName,
            location: _locations[random.nextInt(_locations.length)],
            rating: 3.5 + random.nextDouble() * 1.5,
            reviewCount: random.nextInt(500) + 10,
            isVerified: random.nextBool(),
            photo: 'https://i.pravatar.cc/150?u=$sellerId',
          ),
          images: [image],
          tags: tags,
          rating: 3.0 + random.nextDouble() * 2.0,
          reviewCount: random.nextInt(200),
          metadata: {
            'purchase_type': purchaseType,
            'subscription_period': purchaseType == 'subscription'
                ? 'month'
                : null,
            'fulfillment_journey': fulfillmentJourney,
          },
        ),
      );
    }
    return products;
  }
}
