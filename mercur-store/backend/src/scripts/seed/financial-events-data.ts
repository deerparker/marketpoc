import { ProductStatus } from '@medusajs/framework/utils'

export const financialEventSellers = [
    {
        name: 'Swift Movers',
        handle: 'swift-movers',
        email: 'movers_v2@example.com',
        description: 'Professional moving and relocation experts with over 10 years experience.',
        metadata: {
            rating: 4.8,
            review_count: 156,
            location: 'Birmingham, UK',
            phone: '+44 121 496 0789',
            is_verified: true,
            response_time: 'Within 1 hour'
        },
        products: [
            {
                title: 'Full House Move Service',
                handle: 'full-house-move',
                description: 'Professional moving service for 3-4 bedroom houses. Includes packing.',
                thumbnail: 'https://images.unsplash.com/photo-1600585152220-90363fe7e115?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'moving' }, { value: 'home' }, { value: 'service' }],
                metadata: { rating: 4.9, review_count: 85 },
                options: [
                    { title: 'Distance', values: ['Local', 'National'] }
                ],
                variants: [
                    {
                        title: 'Local Move',
                        options: { Distance: 'Local' },
                        prices: [{ amount: 50000, currency_code: 'eur' }] // 500.00
                    },
                    {
                        title: 'National Move',
                        options: { Distance: 'National' },
                        prices: [{ amount: 150000, currency_code: 'eur' }] // 1500.00
                    }
                ]
            },
            {
                title: 'Moving Boxes Kit',
                handle: 'moving-boxes-kit',
                description: 'Set of 20 large boxes and packing tape.',
                thumbnail: 'https://images.unsplash.com/photo-1586769852044-692d6e37d0d2?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'moving' }, { value: 'supplies' }],
                metadata: { rating: 4.5, review_count: 42 },
                options: [{ title: 'Size', values: ['Standard'] }],
                variants: [
                    {
                        title: 'Standard Kit',
                        options: { Size: 'Standard' },
                        prices: [{ amount: 4500, currency_code: 'eur' }]
                    }
                ]
            }
        ]
    },
    {
        name: 'Baby & Me',
        handle: 'baby-me',
        email: 'baby_v2@example.com',
        description: 'Boutique baby store specializing in high-quality nursery furniture and travel gear.',
        metadata: {
            rating: 4.9,
            review_count: 312,
            location: 'London, UK',
            phone: '+44 20 7946 0888',
            is_verified: true,
            response_time: 'Instant'
        },
        products: [
            {
                title: 'Premium Wooden Crib',
                handle: 'premium-crib',
                description: 'Sustainable wood crib with adjustable mattress height.',
                thumbnail: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'baby' }, { value: 'nursery' }, { value: 'furniture' }],
                metadata: { rating: 5.0, review_count: 89 },
                options: [{ title: 'Color', values: ['White', 'Natural'] }],
                variants: [
                    {
                        title: 'White',
                        options: { Color: 'White' },
                        prices: [{ amount: 29900, currency_code: 'eur' }]
                    },
                    {
                        title: 'Natural',
                        options: { Color: 'Natural' },
                        prices: [{ amount: 29900, currency_code: 'eur' }]
                    }
                ]
            },
            {
                title: 'All-Terrain Stroller',
                handle: 'terrain-stroller',
                description: 'Perfect for city walks and park trails.',
                thumbnail: 'https://images.unsplash.com/photo-1506306461947-2b7373f13673?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'baby' }, { value: 'travel' }],
                metadata: { rating: 4.7, review_count: 156 },
                options: [{ title: 'Color', values: ['Black'] }],
                variants: [
                    {
                        title: 'Black',
                        options: { Color: 'Black' },
                        prices: [{ amount: 45000, currency_code: 'eur' }]
                    }
                ]
            }
        ]
    },
    {
        name: 'Dream Weddings',
        handle: 'dream-weddings',
        email: 'wedding_v2@example.com',
        description: 'Expert wedding planners and coordinators dedicated to making your special day perfect.',
        metadata: {
            rating: 4.6,
            review_count: 98,
            location: 'Edinburgh, UK',
            phone: '+44 131 496 0999',
            is_verified: true,
            response_time: 'Within 24 hours'
        },
        products: [
            {
                title: 'Full Wedding Planning',
                handle: 'wedding-planning',
                description: 'End-to-end wedding coordination and planning service.',
                thumbnail: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'wedding' }, { value: 'service' }, { value: 'party' }],
                metadata: { rating: 4.8, review_count: 45 },
                options: [{ title: 'Package', values: ['Gold', 'Platinum'] }],
                variants: [
                    {
                        title: 'Gold',
                        options: { Package: 'Gold' },
                        prices: [{ amount: 200000, currency_code: 'eur' }]
                    },
                    {
                        title: 'Platinum',
                        options: { Package: 'Platinum' },
                        prices: [{ amount: 500000, currency_code: 'eur' }]
                    }
                ]
            },
            {
                title: 'DJ & Sound System',
                handle: 'dj-service',
                description: 'Professional DJ for 4 hours with full sound setup.',
                thumbnail: 'https://images.unsplash.com/photo-1516280440614-6697288d5d38?auto=format&fit=crop&q=80&w=1000',
                tags: [{ value: 'wedding' }, { value: 'music' }, { value: 'party' }],
                metadata: { rating: 4.4, review_count: 67 },
                options: [{ title: 'Duration', values: ['4 Hours'] }],
                variants: [
                    {
                        title: '4 Hours',
                        options: { Duration: '4 Hours' },
                        prices: [{ amount: 80000, currency_code: 'eur' }]
                    }
                ]
            }
        ]
    }
]
