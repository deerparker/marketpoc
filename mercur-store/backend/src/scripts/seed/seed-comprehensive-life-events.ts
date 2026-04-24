import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import {
    createProductsWorkflow,
    createStockLocationsWorkflow,
    updateProductsWorkflow
} from '@medusajs/medusa/core-flows'
import {
    createSellerWorkflow,
    createLocationFulfillmentSetAndAssociateWithSellerWorkflow,
} from '@mercurjs/b2c-core/workflows'
import { SELLER_MODULE } from '@mercurjs/b2c-core/modules/seller'
import { FULFILLMENT_MODULE } from '../../modules/fulfillment'

// ========================================
// LIFE EVENT TAGS
// ========================================
// These map to FinancialEventType in Flutter app
const LIFE_EVENT_TAGS = {
    BUYING_HOUSE: 'buyingHouse',
    HAVING_BABY: 'havingBaby',
    GETTING_MARRIED: 'gettingMarried',
    RETIREMENT: 'retirement',
    STARTING_BUSINESS: 'startingBusiness',
    UNIVERSITY: 'university',
    STARTING_SCHOOL: 'startingSchool',
    CHRISTMAS: 'christmas',
    ANNIVERSARY: 'anniversary',
    BIRTHDAY: 'birthday',
    BUYING_CAR: 'buyingCar',
    NEW_JOB: 'newJob',
    DIVORCE: 'divorce',
    BEREAVEMENT: 'bereavement',
    GETTING_FIT: 'gettingFit'
}

// ========================================
// SELLER DATA DEFINITIONS
// ========================================
const lifeEventSellers = [
    // =========== BUYING HOUSE ===========
    {
        name: 'Home Essentials Co',
        email: 'home@mercurjs.com',
        description: 'Everything you need to make your new house a home. Furniture, decor, and expert services.',
        metadata: {
            location: 'Manchester, UK',
            phone: '+44 161 496 0234',
            rating: 4.7,
            review_count: 890,
            is_verified: true,
            response_time: 'Within 4 hours'
        },
        products: [
            {
                title: 'Smart Home Security System',
                description: 'Complete home security kit with cameras and sensors.',
                prices: [{ amount: 45000, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'security' }, { value: 'smart-home' }],
                options: [{ title: 'Kit', values: ['Standard'] }],
                variants: [{ title: 'Standard', options: { Kit: 'Standard' }, prices: [{ amount: 45000, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600'
            },
            {
                title: 'Premium Mattress King Size',
                description: 'Memory foam mattress for the best sleep.',
                prices: [{ amount: 89900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'bedroom' }, { value: 'furniture' }],
                options: [{ title: 'Size', values: ['King'] }],
                variants: [{ title: 'King', options: { Size: 'King' }, prices: [{ amount: 89900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600'
            },
            {
                title: 'Modular Sofa Set',
                description: 'Configurable 4-piece sectional sofa.',
                prices: [{ amount: 249900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'living-room' }, { value: 'furniture' }],
                options: [{ title: 'Color', values: ['Grey'] }],
                variants: [{ title: 'Grey', options: { Color: 'Grey' }, prices: [{ amount: 249900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600'
            },
            {
                title: 'Moving Day Service Package',
                description: 'Full moving service with packing and transport.',
                prices: [{ amount: 75000, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'service' }, { value: 'moving' }],
                options: [{ title: 'Type', values: ['Full Service'] }],
                variants: [{ title: 'Full Service', options: { Type: 'Full Service' }, prices: [{ amount: 75000, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'MOVEHOME-2026', button_text: 'Book Moving' } } }
            },
            {
                title: 'Interior Design Consultation',
                description: '2-hour session with certified interior designer.',
                prices: [{ amount: 15000, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'service' }, { value: 'design' }],
                options: [{ title: 'Duration', values: ['2 Hour'] }],
                variants: [{ title: '2 Hour', options: { Duration: '2 Hour' }, prices: [{ amount: 15000, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'DESIGN-CONSULT', button_text: 'Get Voucher' } } }
            }
        ]
    },
    {
        name: 'Garden & Outdoor Living',
        email: 'garden@mercurjs.com',
        products: [
            {
                title: 'Professional Lawn Mower',
                description: 'Petrol-powered lawn mower for large gardens.',
                prices: [{ amount: 59900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'garden' }, { value: 'tools' }],
                options: [{ title: 'Model', values: ['Pro 500'] }],
                variants: [{ title: 'Pro 500', options: { Model: 'Pro 500' }, prices: [{ amount: 59900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600'
            },
            {
                title: 'Patio Furniture Set',
                description: '6-person outdoor dining set with umbrella.',
                prices: [{ amount: 89900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_HOUSE }, { value: 'garden' }, { value: 'furniture' }],
                options: [{ title: 'Color', values: ['Natural Wood'] }],
                variants: [{ title: 'Natural Wood', options: { Color: 'Natural Wood' }, prices: [{ amount: 89900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600'
            }
        ]
    },
    // =========== HAVING BABY ===========
    {
        name: 'Baby Bliss Boutique',
        email: 'babybliss@mercurjs.com',
        description: 'Curated essentials and services for new and expecting parents.',
        metadata: {
            location: 'London, UK',
            phone: '+44 20 8946 0567',
            rating: 4.9,
            review_count: 342,
            is_verified: true,
            response_time: 'Instant'
        },
        products: [
            {
                title: 'Premium Baby Stroller',
                description: 'All-terrain comfort for your baby.',
                prices: [{ amount: 45000, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'stroller' }, { value: 'pram' }],
                options: [{ title: 'Color', values: ['Grey', 'Black'] }],
                variants: [
                    { title: 'Grey', options: { Color: 'Grey' }, prices: [{ amount: 45000, currency_code: 'eur' }] },
                    { title: 'Black', options: { Color: 'Black' }, prices: [{ amount: 45000, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1591027480007-a42f4aa88fde?w=600'
            },
            {
                title: 'Newborn Essentials Kit',
                description: 'Everything for the first 3 months.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'newborn' }, { value: 'essentials' }],
                options: [{ title: 'Size', values: ['0-3 Months'] }],
                variants: [{ title: '0-3 Months', options: { Size: '0-3 Months' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=600'
            },
            {
                title: 'Convertible Crib',
                description: 'Grows with your child from crib to toddler bed.',
                prices: [{ amount: 69900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'nursery' }, { value: 'furniture' }],
                options: [{ title: 'Color', values: ['White'] }],
                variants: [{ title: 'White', options: { Color: 'White' }, prices: [{ amount: 69900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1586105251261-72a756497a11?w=600'
            },
            {
                title: 'Baby Monitor Pro',
                description: 'HD video monitor with night vision and app control.',
                prices: [{ amount: 24900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'tech' }, { value: 'monitor' }],
                options: [{ title: 'Model', values: ['Pro 4K'] }],
                variants: [{ title: 'Pro 4K', options: { Model: 'Pro 4K' }, prices: [{ amount: 24900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600'
            },
            {
                title: 'Nursery Design Consultation',
                description: '1-hour video call with an expert designer.',
                prices: [{ amount: 7500, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'service' }, { value: 'design' }],
                options: [{ title: 'Duration', values: ['1 Hour'] }],
                variants: [{ title: '1 Hour', options: { Duration: '1 Hour' }, prices: [{ amount: 7500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1522771753062-811c7da0f04e?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'NURSERY-DESIGN', button_text: 'Get Voucher' } } }
            },
            {
                title: 'Baby Photography Session',
                description: 'Professional newborn photoshoot at your home.',
                prices: [{ amount: 29900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.HAVING_BABY }, { value: 'service' }, { value: 'photography' }],
                options: [{ title: 'Type', values: ['Home Session'] }],
                variants: [{ title: 'Home Session', options: { Type: 'Home Session' }, prices: [{ amount: 29900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'BABY-PHOTO-2026', button_text: 'Book Session' } } }
            }
        ]
    },
    // =========== GETTING MARRIED ===========
    {
        name: 'Dream Weddings',
        email: 'weddings@mercurjs.com',
        products: [
            {
                title: 'Wedding Invitation Suite',
                description: 'Custom designed invitation set for 100 guests.',
                prices: [{ amount: 49900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_MARRIED }, { value: 'invitations' }, { value: 'stationery' }],
                options: [{ title: 'Style', values: ['Classic', 'Modern'] }],
                variants: [
                    { title: 'Classic', options: { Style: 'Classic' }, prices: [{ amount: 49900, currency_code: 'eur' }] },
                    { title: 'Modern', options: { Style: 'Modern' }, prices: [{ amount: 49900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=600'
            },
            {
                title: 'Wedding Photography Package',
                description: 'Full day coverage with 500+ edited photos.',
                prices: [{ amount: 299900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_MARRIED }, { value: 'service' }, { value: 'photography' }],
                options: [{ title: 'Package', values: ['Full Day'] }],
                variants: [{ title: 'Full Day', options: { Package: 'Full Day' }, prices: [{ amount: 299900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'WEDDING-PHOTO', button_text: 'Book Photographer' } } }
            },
            {
                title: 'Wedding Cake Consultation',
                description: 'Tasting session with master cake artist.',
                prices: [{ amount: 9900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_MARRIED }, { value: 'service' }, { value: 'catering' }],
                options: [{ title: 'Type', values: ['Tasting'] }],
                variants: [{ title: 'Tasting', options: { Type: 'Tasting' }, prices: [{ amount: 9900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'CAKE-TASTING', button_text: 'Book Tasting' } } }
            },
            {
                title: 'Bridal Hair & Makeup Trial',
                description: 'Pre-wedding styling trial with top artist.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_MARRIED }, { value: 'service' }, { value: 'beauty' }],
                options: [{ title: 'Type', values: ['Trial'] }],
                variants: [{ title: 'Trial', options: { Type: 'Trial' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'BRIDAL-BEAUTY', button_text: 'Book Trial' } } }
            },
            {
                title: 'Honeymoon Planning Service',
                description: 'Bespoke honeymoon itinerary planning.',
                prices: [{ amount: 29900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_MARRIED }, { value: 'service' }, { value: 'travel' }],
                options: [{ title: 'Type', values: ['Luxury'] }],
                variants: [{ title: 'Luxury', options: { Type: 'Luxury' }, prices: [{ amount: 29900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'HONEYMOON-PLAN', button_text: 'Start Planning' } } }
            }
        ]
    },
    // =========== GETTING FIT ===========
    {
        name: 'FitLife Pro',
        email: 'fitlife@mercurjs.com',
        products: [
            {
                title: 'Personal Training 10-Pack',
                description: '10 x 1-hour sessions with certified trainer.',
                prices: [{ amount: 59900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'service' }, { value: 'trainer' }],
                options: [{ title: 'Type', values: ['Standard'] }],
                variants: [{ title: 'Standard', options: { Type: 'Standard' }, prices: [{ amount: 59900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'PT-10PACK', button_text: 'Get Sessions' } } }
            },
            {
                title: 'Premium Gym Membership Annual',
                description: '12-month full access to all FitLife gyms.',
                prices: [{ amount: 49900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'membership' }, { value: 'gym' }],
                options: [{ title: 'Duration', values: ['12 Months'] }],
                variants: [{ title: '12 Months', options: { Duration: '12 Months' }, prices: [{ amount: 49900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'GYM-ANNUAL', button_text: 'Join Now' } } }
            },
            {
                title: 'Premium Running Trainers',
                description: 'Professional-grade running shoes with cushioning.',
                prices: [{ amount: 17900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'trainer' }, { value: 'running' }, { value: 'shoes' }],
                options: [{ title: 'Size', values: ['UK 8', 'UK 9', 'UK 10'] }],
                variants: [
                    { title: 'UK 8', options: { Size: 'UK 8' }, prices: [{ amount: 17900, currency_code: 'eur' }] },
                    { title: 'UK 9', options: { Size: 'UK 9' }, prices: [{ amount: 17900, currency_code: 'eur' }] },
                    { title: 'UK 10', options: { Size: 'UK 10' }, prices: [{ amount: 17900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600'
            },
            {
                title: 'Adjustable Dumbbell Set',
                description: '5-40kg adjustable dumbbells with stand.',
                prices: [{ amount: 39900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'equipment' }, { value: 'weights' }],
                options: [{ title: 'Weight', values: ['5-40kg'] }],
                variants: [{ title: '5-40kg', options: { Weight: '5-40kg' }, prices: [{ amount: 39900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1534368420009-621bfab424a8?w=600'
            },
            {
                title: 'Yoga Mat Premium',
                description: 'Extra thick eco-friendly yoga mat.',
                prices: [{ amount: 6900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'yoga' }, { value: 'equipment' }],
                options: [{ title: 'Color', values: ['Blue', 'Purple'] }],
                variants: [
                    { title: 'Blue', options: { Color: 'Blue' }, prices: [{ amount: 6900, currency_code: 'eur' }] },
                    { title: 'Purple', options: { Color: 'Purple' }, prices: [{ amount: 6900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600'
            },
            {
                title: 'Nutrition Consultation',
                description: 'Personalized diet plan from certified nutritionist.',
                prices: [{ amount: 12900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'service' }, { value: 'nutrition' }],
                options: [{ title: 'Type', values: ['1 Session'] }],
                variants: [{ title: '1 Session', options: { Type: '1 Session' }, prices: [{ amount: 12900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'NUTRITION-PLAN', button_text: 'Book Consultation' } } }
            },
            {
                title: 'Fitness Tracker Pro',
                description: 'Advanced fitness watch with heart rate and GPS.',
                prices: [{ amount: 29900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'tech' }, { value: 'wearable' }],
                options: [{ title: 'Color', values: ['Black'] }],
                variants: [{ title: 'Black', options: { Color: 'Black' }, prices: [{ amount: 29900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=600'
            },
            {
                title: 'Whey Protein 2kg',
                description: 'Premium whey protein powder for muscle building.',
                prices: [{ amount: 4900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.GETTING_FIT }, { value: 'nutrition' }, { value: 'supplement' }],
                options: [{ title: 'Flavor', values: ['Chocolate', 'Vanilla'] }],
                variants: [
                    { title: 'Chocolate', options: { Flavor: 'Chocolate' }, prices: [{ amount: 4900, currency_code: 'eur' }] },
                    { title: 'Vanilla', options: { Flavor: 'Vanilla' }, prices: [{ amount: 4900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=600'
            }
        ]
    },
    // =========== BUYING CAR ===========
    {
        name: 'Auto Pro Garage',
        email: 'autopro@mercurjs.com',
        products: [
            {
                title: 'Premium GPS Navigation',
                description: 'Touchscreen sat-nav with lifetime map updates.',
                prices: [{ amount: 24900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_CAR }, { value: 'electronics' }, { value: 'navigation' }],
                options: [{ title: 'Screen', values: ['7 inch'] }],
                variants: [{ title: '7 inch', options: { Screen: '7 inch' }, prices: [{ amount: 24900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1532559725-7ee24fb72d42?w=600'
            },
            {
                title: 'Dashboard Camera HD',
                description: 'Front and rear dash cam with night vision.',
                prices: [{ amount: 17900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_CAR }, { value: 'electronics' }, { value: 'safety' }],
                options: [{ title: 'Model', values: ['Dual HD'] }],
                variants: [{ title: 'Dual HD', options: { Model: 'Dual HD' }, prices: [{ amount: 17900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=600'
            },
            {
                title: 'Full Car Detailing Service',
                description: 'Complete interior and exterior clean.',
                prices: [{ amount: 14900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_CAR }, { value: 'service' }, { value: 'cleaning' }],
                options: [{ title: 'Type', values: ['Full Detail'] }],
                variants: [{ title: 'Full Detail', options: { Type: 'Full Detail' }, prices: [{ amount: 14900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'DETAIL-FULL', button_text: 'Book Detailing' } } }
            },
            {
                title: 'Car Care Kit Premium',
                description: 'Complete wash and polish kit with microfiber cloths.',
                prices: [{ amount: 8900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BUYING_CAR }, { value: 'accessories' }, { value: 'care' }],
                options: [{ title: 'Kit', values: ['Premium'] }],
                variants: [{ title: 'Premium', options: { Kit: 'Premium' }, prices: [{ amount: 8900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=600'
            }
        ]
    },
    // =========== STARTING BUSINESS ===========
    {
        name: 'Office Solutions Pro',
        email: 'office@mercurjs.com',
        products: [
            {
                title: 'Ergonomic Desk Chair Pro',
                description: 'High-back mesh office chair with lumbar support.',
                prices: [{ amount: 39900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_BUSINESS }, { value: 'furniture' }, { value: 'office' }],
                options: [{ title: 'Color', values: ['Black', 'Grey'] }],
                variants: [
                    { title: 'Black', options: { Color: 'Black' }, prices: [{ amount: 39900, currency_code: 'eur' }] },
                    { title: 'Grey', options: { Color: 'Grey' }, prices: [{ amount: 39900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=600'
            },
            {
                title: 'Standing Desk Electric',
                description: 'Height-adjustable electric standing desk.',
                prices: [{ amount: 59900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_BUSINESS }, { value: 'furniture' }, { value: 'desk' }],
                options: [{ title: 'Size', values: ['140cm'] }],
                variants: [{ title: '140cm', options: { Size: '140cm' }, prices: [{ amount: 59900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=600'
            },
            {
                title: 'Business Formation Package',
                description: 'Company registration and legal setup.',
                prices: [{ amount: 89900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_BUSINESS }, { value: 'service' }, { value: 'legal' }],
                options: [{ title: 'Type', values: ['Limited Company'] }],
                variants: [{ title: 'Limited Company', options: { Type: 'Limited Company' }, prices: [{ amount: 89900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'BIZ-FORMATION', button_text: 'Start Formation' } } }
            },
            {
                title: 'Business Card Design',
                description: '500 premium business cards with custom design.',
                prices: [{ amount: 9900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_BUSINESS }, { value: 'marketing' }, { value: 'print' }],
                options: [{ title: 'Quantity', values: ['500'] }],
                variants: [{ title: '500', options: { Quantity: '500' }, prices: [{ amount: 9900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=600'
            },
            {
                title: 'Website Development Package',
                description: 'Professional 5-page business website.',
                prices: [{ amount: 249900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_BUSINESS }, { value: 'service' }, { value: 'web' }],
                options: [{ title: 'Pages', values: ['5 Pages'] }],
                variants: [{ title: '5 Pages', options: { Pages: '5 Pages' }, prices: [{ amount: 249900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'WEB-PACKAGE', button_text: 'Start Project' } } }
            }
        ]
    },
    // =========== UNIVERSITY ===========
    {
        name: 'Campus Essentials',
        email: 'campus@mercurjs.com',
        products: [
            {
                title: 'Student Laptop Bundle',
                description: 'Laptop with case, mouse, and headphones.',
                prices: [{ amount: 89900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.UNIVERSITY }, { value: 'tech' }, { value: 'laptop' }],
                options: [{ title: 'Model', values: ['Standard'] }],
                variants: [{ title: 'Standard', options: { Model: 'Standard' }, prices: [{ amount: 89900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600'
            },
            {
                title: 'Dorm Room Bedding Set',
                description: 'Complete single bed set with duvet and pillows.',
                prices: [{ amount: 12900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.UNIVERSITY }, { value: 'bedding' }, { value: 'dorm' }],
                options: [{ title: 'Color', values: ['Navy', 'Grey'] }],
                variants: [
                    { title: 'Navy', options: { Color: 'Navy' }, prices: [{ amount: 12900, currency_code: 'eur' }] },
                    { title: 'Grey', options: { Color: 'Grey' }, prices: [{ amount: 12900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=600'
            },
            {
                title: 'Textbook Rental Service',
                description: 'Semester textbook rental subscription.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.UNIVERSITY }, { value: 'service' }, { value: 'books' }],
                options: [{ title: 'Duration', values: ['1 Semester'] }],
                variants: [{ title: '1 Semester', options: { Duration: '1 Semester' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'TEXTBOOK-RENTAL', button_text: 'Start Rental' } } }
            },
            {
                title: 'Study Desk with Storage',
                description: 'Compact desk with shelving for small spaces.',
                prices: [{ amount: 24900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.UNIVERSITY }, { value: 'furniture' }, { value: 'desk' }],
                options: [{ title: 'Color', values: ['Oak'] }],
                variants: [{ title: 'Oak', options: { Color: 'Oak' }, prices: [{ amount: 24900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=600'
            }
        ]
    },
    // =========== RETIREMENT ===========
    {
        name: 'Golden Years Living',
        email: 'retirement@mercurjs.com',
        products: [
            {
                title: 'Estate Planning Consultation',
                description: 'Professional will and estate planning service.',
                prices: [{ amount: 49900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.RETIREMENT }, { value: 'service' }, { value: 'legal' }],
                options: [{ title: 'Type', values: ['Full Package'] }],
                variants: [{ title: 'Full Package', options: { Type: 'Full Package' }, prices: [{ amount: 49900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'ESTATE-PLAN', button_text: 'Book Consultation' } } }
            },
            {
                title: 'Travel Photography Course',
                description: 'Online course for capturing travel memories.',
                prices: [{ amount: 14900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.RETIREMENT }, { value: 'course' }, { value: 'hobbies' }],
                options: [{ title: 'Type', values: ['Online'] }],
                variants: [{ title: 'Online', options: { Type: 'Online' }, prices: [{ amount: 14900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'PHOTO-COURSE', button_text: 'Start Course' } } }
            },
            {
                title: 'Garden Tool Set Premium',
                description: 'Complete gardening toolkit for enthusiasts.',
                prices: [{ amount: 17900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.RETIREMENT }, { value: 'garden' }, { value: 'hobbies' }],
                options: [{ title: 'Set', values: ['Complete'] }],
                variants: [{ title: 'Complete', options: { Set: 'Complete' }, prices: [{ amount: 17900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600'
            }
        ]
    },
    // =========== CHRISTMAS ===========
    {
        name: 'Holiday Gift Shop',
        email: 'christmas@mercurjs.com',
        products: [
            {
                title: 'Christmas Hamper Luxury',
                description: 'Premium selection of festive treats and wine.',
                prices: [{ amount: 12900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.CHRISTMAS }, { value: 'gift' }, { value: 'food' }],
                options: [{ title: 'Size', values: ['Large'] }],
                variants: [{ title: 'Large', options: { Size: 'Large' }, prices: [{ amount: 12900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Family Board Games Bundle',
                description: 'Collection of 5 classic family board games.',
                prices: [{ amount: 7900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.CHRISTMAS }, { value: 'gift' }, { value: 'games' }],
                options: [{ title: 'Bundle', values: ['5 Games'] }],
                variants: [{ title: '5 Games', options: { Bundle: '5 Games' }, prices: [{ amount: 7900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1606503153255-59d7c4f7e4e4?w=600'
            },
            {
                title: 'Christmas Tree Delivery',
                description: 'Premium Nordmann Fir delivered to your door.',
                prices: [{ amount: 8900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.CHRISTMAS }, { value: 'service' }, { value: 'tree' }],
                options: [{ title: 'Size', values: ['6ft', '7ft'] }],
                variants: [
                    { title: '6ft', options: { Size: '6ft' }, prices: [{ amount: 8900, currency_code: 'eur' }] },
                    { title: '7ft', options: { Size: '7ft' }, prices: [{ amount: 10900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'TREE-DELIVERY', button_text: 'Order Tree' } } }
            }
        ]
    },
    // =========== BIRTHDAY / ANNIVERSARY ===========
    {
        name: 'Celebration Central',
        email: 'celebrate@mercurjs.com',
        products: [
            {
                title: 'Spa Day Experience',
                description: 'Full day spa package with treatments.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BIRTHDAY }, { value: LIFE_EVENT_TAGS.ANNIVERSARY }, { value: 'service' }, { value: 'spa' }],
                options: [{ title: 'Type', values: ['Full Day'] }],
                variants: [{ title: 'Full Day', options: { Type: 'Full Day' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'SPA-DAY', button_text: 'Book Spa Day' } } }
            },
            {
                title: 'Fine Dining Experience',
                description: 'Tasting menu for 2 at Michelin restaurant.',
                prices: [{ amount: 29900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BIRTHDAY }, { value: LIFE_EVENT_TAGS.ANNIVERSARY }, { value: 'service' }, { value: 'dining' }],
                options: [{ title: 'Covers', values: ['2 People'] }],
                variants: [{ title: '2 People', options: { Covers: '2 People' }, prices: [{ amount: 29900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'FINE-DINING', button_text: 'Book Table' } } }
            },
            {
                title: 'Premium Watch Gift Box',
                description: 'Elegant watch in presentation gift box.',
                prices: [{ amount: 24900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BIRTHDAY }, { value: LIFE_EVENT_TAGS.ANNIVERSARY }, { value: 'gift' }, { value: 'jewelry' }],
                options: [{ title: 'Style', values: ['Classic'] }],
                variants: [{ title: 'Classic', options: { Style: 'Classic' }, prices: [{ amount: 24900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=600'
            },
            {
                title: 'Party Planning Service',
                description: 'Full event planning for up to 50 guests.',
                prices: [{ amount: 49900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.BIRTHDAY }, { value: LIFE_EVENT_TAGS.ANNIVERSARY }, { value: 'service' }, { value: 'party' }],
                options: [{ title: 'Guests', values: ['Up to 50'] }],
                variants: [{ title: 'Up to 50', options: { Guests: 'Up to 50' }, prices: [{ amount: 49900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'PARTY-PLAN', button_text: 'Plan Party' } } }
            }
        ]
    },
    // =========== STARTING SCHOOL ===========
    {
        name: 'School Ready Store',
        email: 'school@mercurjs.com',
        products: [
            {
                title: 'School Uniform Set',
                description: 'Complete uniform pack including blazer.',
                prices: [{ amount: 14900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_SCHOOL }, { value: 'uniform' }, { value: 'clothing' }],
                options: [{ title: 'Age', values: ['5-6', '7-8', '9-10'] }],
                variants: [
                    { title: '5-6', options: { Age: '5-6' }, prices: [{ amount: 14900, currency_code: 'eur' }] },
                    { title: '7-8', options: { Age: '7-8' }, prices: [{ amount: 15900, currency_code: 'eur' }] },
                    { title: '9-10', options: { Age: '9-10' }, prices: [{ amount: 16900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600'
            },
            {
                title: 'Kids Backpack with Lunchbox',
                description: 'Matching backpack and lunchbox set.',
                prices: [{ amount: 4900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_SCHOOL }, { value: 'backpack' }, { value: 'accessories' }],
                options: [{ title: 'Design', values: ['Dinosaur', 'Unicorn'] }],
                variants: [
                    { title: 'Dinosaur', options: { Design: 'Dinosaur' }, prices: [{ amount: 4900, currency_code: 'eur' }] },
                    { title: 'Unicorn', options: { Design: 'Unicorn' }, prices: [{ amount: 4900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600'
            },
            {
                title: 'Stationery Starter Kit',
                description: 'Pencils, pens, rulers and notebooks.',
                prices: [{ amount: 2900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.STARTING_SCHOOL }, { value: 'stationery' }, { value: 'supplies' }],
                options: [{ title: 'Type', values: ['Complete'] }],
                variants: [{ title: 'Complete', options: { Type: 'Complete' }, prices: [{ amount: 2900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=600'
            }
        ]
    },
    // =========== NEW JOB ===========
    {
        name: 'Career Wardrobe',
        email: 'career@mercurjs.com',
        description: 'Premium business attire and career support services for professionals.',
        metadata: {
            location: 'London, UK',
            phone: '+44 20 7946 0123',
            rating: 4.8,
            review_count: 156,
            is_verified: true,
            response_time: 'Within 2 hours'
        },
        products: [
            {
                title: 'Professional Suit',
                description: 'Tailored business suit in navy or charcoal.',
                prices: [{ amount: 39900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.NEW_JOB }, { value: 'clothing' }, { value: 'suit' }],
                options: [{ title: 'Color', values: ['Navy', 'Charcoal'] }],
                variants: [
                    { title: 'Navy', options: { Color: 'Navy' }, prices: [{ amount: 39900, currency_code: 'eur' }] },
                    { title: 'Charcoal', options: { Color: 'Charcoal' }, prices: [{ amount: 39900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=600'
            },
            {
                title: 'Business Bag Leather',
                description: 'Premium leather laptop briefcase.',
                prices: [{ amount: 24900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.NEW_JOB }, { value: 'bag' }, { value: 'accessories' }],
                options: [{ title: 'Color', values: ['Brown', 'Black'] }],
                variants: [
                    { title: 'Brown', options: { Color: 'Brown' }, prices: [{ amount: 24900, currency_code: 'eur' }] },
                    { title: 'Black', options: { Color: 'Black' }, prices: [{ amount: 24900, currency_code: 'eur' }] }
                ],
                thumbnail: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600'
            },
            {
                title: 'Career Coaching Session',
                description: '90-minute session with executive coach.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: LIFE_EVENT_TAGS.NEW_JOB }, { value: 'service' }, { value: 'coaching' }],
                options: [{ title: 'Duration', values: ['90 mins'] }],
                variants: [{ title: '90 mins', options: { Duration: '90 mins' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'CAREER-COACH', button_text: 'Book Session' } } }
            }
        ]
    }
]

// ========================================
// HELPER FUNCTIONS
// ========================================
async function createCustomSeller(
    container: any,
    data: { name: string, email: string, description?: string, metadata?: any }
) {
    const authService = container.resolve(Modules.AUTH)
    let authIdentity
    try {
        const res = await authService.register('emailpass', {
            body: { email: data.email, password: 'secret' }
        })
        authIdentity = res.authIdentity
    } catch (e) {
        console.log('User might already exist', e.message)
    }

    const { result: seller } = await createSellerWorkflow.run({
        container,
        input: {
            auth_identity_id: authIdentity?.id,
            member: { name: data.name, email: data.email },
            seller: {
                name: data.name,
                description: data.description,
                metadata: data.metadata
            }
        }
    })
    return seller
}

// ========================================
// MAIN SEED FUNCTION
// ========================================
export default async function seedComprehensiveLifeEvents({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL)
    const [defaultSalesChannel] = await salesChannelModuleService.listSalesChannels({ name: 'Default Sales Channel' })
    const fulfillmentModule = container.resolve(FULFILLMENT_MODULE) as any
    const productModule = container.resolve(Modules.PRODUCT) as any

    logger.info('=== Starting Comprehensive Life Events Seeding ===')
    logger.info(`Total sellers to create: ${lifeEventSellers.length}`)

    for (const data of lifeEventSellers) {
        logger.info(`\n--- Creating seller: ${data.name} ---`)

        // 1. Create or fetch Seller
        let seller
        try {
            seller = await createCustomSeller(container, {
                name: data.name,
                email: data.email,
                description: data.description,
                metadata: data.metadata
            })
        } catch (e) {
            logger.warn(`Seller ${data.name} creation failed. Fetching existing...`)
            const sellerModule = container.resolve(SELLER_MODULE) as any
            const [existing] = await sellerModule.listSellers({ name: data.name })
            if (existing) {
                seller = existing
                logger.info(`Updating existing seller: ${seller.id}`)
                await sellerModule.updateSellers({
                    id: seller.id,
                    description: data.description,
                    metadata: data.metadata
                })
            } else {
                logger.error(`Could not find seller ${data.name}. Skipping.`)
                continue
            }
        }

        // 2. Create Stock Location
        const link = container.resolve(ContainerRegistrationKeys.LINK)
        let stock
        try {
            const { result: [stockResult] } = await createStockLocationsWorkflow(container).run({
                input: {
                    locations: [{ name: `Stock for ${data.name}`, address: { city: 'Berlin', country_code: 'de', address_1: 'Test St' } }]
                }
            })
            stock = stockResult

            await link.create([
                { [SELLER_MODULE]: { seller_id: seller.id }, [Modules.STOCK_LOCATION]: { stock_location_id: stock.id } },
                { [Modules.STOCK_LOCATION]: { stock_location_id: stock.id }, [Modules.FULFILLMENT]: { fulfillment_provider_id: 'manual_manual' } },
                { [Modules.SALES_CHANNEL]: { sales_channel_id: defaultSalesChannel.id }, [Modules.STOCK_LOCATION]: { stock_location_id: stock.id } }
            ])
        } catch (e) {
            logger.warn(`Stock location for ${data.name} may exist. Continuing...`)
        }

        // 3. Fulfillment Set
        try {
            await createLocationFulfillmentSetAndAssociateWithSellerWorkflow.run({
                container,
                input: {
                    fulfillment_set_data: { name: `${seller.id} set`, type: 'shipping' },
                    location_id: stock?.id,
                    seller_id: seller.id
                }
            })
        } catch (e) {
            logger.warn(`Fulfillment Set for ${data.name} likely exists.`)
        }

        // 4. Create Products with Tags
        // First ensure all tags exist
        const allTags = new Set<string>()
        data.products.forEach(p => p.tags?.forEach(t => allTags.add(t.value)))

        if (allTags.size > 0) {
            try {
                const existingTags = await productModule.listProductTags({ value: Array.from(allTags) })
                const existingValues = new Set(existingTags.map((t: any) => t.value))
                const missingValues = Array.from(allTags).filter(t => !existingValues.has(t))

                if (missingValues.length > 0) {
                    await productModule.createProductTags(missingValues.map(t => ({ value: t })))
                }
            } catch (e) {
                logger.warn(`Tag creation issue: ${e.message}`)
            }
        }

        // Resolve tag IDs
        const resolvedTags = await productModule.listProductTags({ value: Array.from(allTags) })
        const tagMap = new Map(resolvedTags.map((t: any) => [t.value, t.id]))

        // Map products with resolved tag IDs
        const productsToCreate = data.products.map(p => ({
            ...p,
            tags: p.tags?.map(t => ({ id: tagMap.get(t.value) })).filter(t => t.id),
            sales_channels: [{ id: defaultSalesChannel.id }],
            status: 'published'
        }))

        logger.info(`Creating ${productsToCreate.length} products for ${data.name}`)

        try {
            await createProductsWorkflow.run({
                container,
                input: {
                    products: productsToCreate as any,
                    additional_data: { seller_id: seller.id }
                }
            })
        } catch (e) {
            logger.error(`Product creation failed for ${data.name}: ${e.message}`)
        }

        // 5. Fallback fulfillment journey
        try {
            await fulfillmentModule.createFulfillmentJourneys({
                type: 'manual',
                seller_id: seller.id
            })
        } catch (e) {
            // Ignore if exists
        }
    }

    logger.info('\n=== Comprehensive Life Events Seeding Completed ===')
}
