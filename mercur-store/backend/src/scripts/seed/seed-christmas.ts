import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import { createProductsWorkflow, createStockLocationsWorkflow } from '@medusajs/medusa/core-flows'
import { createSellerWorkflow, createLocationFulfillmentSetAndAssociateWithSellerWorkflow } from '@mercurjs/b2c-core/workflows'
import { SELLER_MODULE } from '@mercurjs/b2c-core/modules/seller'
import { FULFILLMENT_MODULE } from '../../modules/fulfillment'

const CHRISTMAS_TAG = 'christmas'

const christmasSellers = [
    {
        name: 'Christmas Tree Farm',
        email: 'trees@mercurjs.com',
        products: [
            {
                title: 'Nordmann Fir Christmas Tree 6ft',
                description: 'Premium non-drop Nordmann Fir delivered to your door.',
                prices: [{ amount: 7900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'tree' }, { value: 'decoration' }],
                options: [{ title: 'Size', values: ['6ft'] }],
                variants: [{ title: '6ft', options: { Size: '6ft' }, prices: [{ amount: 7900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'TREE-6FT', button_text: 'Reserve Tree' } } }
            },
            {
                title: 'Nordmann Fir Christmas Tree 7ft',
                description: 'Large premium Nordmann Fir for grand living spaces.',
                prices: [{ amount: 9900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'tree' }, { value: 'decoration' }],
                options: [{ title: 'Size', values: ['7ft'] }],
                variants: [{ title: '7ft', options: { Size: '7ft' }, prices: [{ amount: 9900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'TREE-7FT', button_text: 'Reserve Tree' } } }
            },
            {
                title: 'Potted Living Christmas Tree',
                description: 'Replantable living tree you can use year after year.',
                prices: [{ amount: 12900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'tree' }, { value: 'eco' }],
                options: [{ title: 'Size', values: ['4ft'] }],
                variants: [{ title: '4ft', options: { Size: '4ft' }, prices: [{ amount: 12900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Christmas Wreath Fresh',
                description: 'Handmade fresh holly and pine wreath.',
                prices: [{ amount: 3500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'decoration' }, { value: 'wreath' }],
                options: [{ title: 'Size', values: ['Standard'] }],
                variants: [{ title: 'Standard', options: { Size: 'Standard' }, prices: [{ amount: 3500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            }
        ]
    },
    {
        name: 'Christmas Feast Co',
        email: 'feast@mercurjs.com',
        products: [
            {
                title: 'Free Range Christmas Turkey',
                description: 'Premium free-range turkey 5-6kg, feeds 8-10.',
                prices: [{ amount: 8900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'food' }, { value: 'turkey' }],
                options: [{ title: 'Size', values: ['5-6kg'] }],
                variants: [{ title: '5-6kg', options: { Size: '5-6kg' }, prices: [{ amount: 8900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1574672280600-4c56c90c7db2?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'TURKEY-2026', button_text: 'Reserve Turkey' } } }
            },
            {
                title: 'Christmas Dinner Hamper',
                description: 'Complete hamper with turkey, stuffing, cranberry sauce and trimmings.',
                prices: [{ amount: 14900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'food' }, { value: 'hamper' }],
                options: [{ title: 'Size', values: ['Family'] }],
                variants: [{ title: 'Family', options: { Size: 'Family' }, prices: [{ amount: 14900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Christmas Pudding Traditional',
                description: 'Matured traditional Christmas pudding with brandy sauce.',
                prices: [{ amount: 2500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'food' }, { value: 'dessert' }],
                options: [{ title: 'Size', values: ['Large'] }],
                variants: [{ title: 'Large', options: { Size: 'Large' }, prices: [{ amount: 2500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Mince Pies Box of 12',
                description: 'Traditional homemade mince pies with all-butter pastry.',
                prices: [{ amount: 1500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'food' }, { value: 'bakery' }],
                options: [{ title: 'Quantity', values: ['12'] }],
                variants: [{ title: '12', options: { Quantity: '12' }, prices: [{ amount: 1500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            }
        ]
    },
    {
        name: 'Gift Voucher Store',
        email: 'vouchers@mercurjs.com',
        products: [
            {
                title: 'Amazon Gift Card €50',
                description: 'Digital Amazon gift card delivered instantly.',
                prices: [{ amount: 5000, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'gift' }, { value: 'voucher' }],
                options: [{ title: 'Value', values: ['€50'] }],
                variants: [{ title: '€50', options: { Value: '€50' }, prices: [{ amount: 5000, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'AMZN-50-XMAS', button_text: 'Get Gift Card' } } }
            },
            {
                title: 'Amazon Gift Card €100',
                description: 'Digital Amazon gift card delivered instantly.',
                prices: [{ amount: 10000, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'gift' }, { value: 'voucher' }],
                options: [{ title: 'Value', values: ['€100'] }],
                variants: [{ title: '€100', options: { Value: '€100' }, prices: [{ amount: 10000, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'AMZN-100-XMAS', button_text: 'Get Gift Card' } } }
            },
            {
                title: 'Spa Day Gift Voucher',
                description: 'Full day spa experience gift voucher.',
                prices: [{ amount: 19900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'gift' }, { value: 'voucher' }, { value: 'spa' }],
                options: [{ title: 'Type', values: ['Full Day'] }],
                variants: [{ title: 'Full Day', options: { Type: 'Full Day' }, prices: [{ amount: 19900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'SPA-XMAS', button_text: 'Get Spa Voucher' } } }
            },
            {
                title: 'Restaurant Gift Card €75',
                description: 'Fine dining experience gift card.',
                prices: [{ amount: 7500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'gift' }, { value: 'voucher' }, { value: 'dining' }],
                options: [{ title: 'Value', values: ['€75'] }],
                variants: [{ title: '€75', options: { Value: '€75' }, prices: [{ amount: 7500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600',
                metadata: { fulfillment_journey: { type: 'voucher', config: { code: 'DINE-75-XMAS', button_text: 'Get Dining Card' } } }
            }
        ]
    },
    {
        name: 'Christmas Decorations',
        email: 'decor@mercurjs.com',
        products: [
            {
                title: 'Fairy Lights 100 LED',
                description: 'Warm white fairy lights for indoor/outdoor use.',
                prices: [{ amount: 2500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'decoration' }, { value: 'lights' }],
                options: [{ title: 'Length', values: ['10m'] }],
                variants: [{ title: '10m', options: { Length: '10m' }, prices: [{ amount: 2500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Bauble Set Premium 24 Pack',
                description: 'Assorted glass baubles in red, gold and silver.',
                prices: [{ amount: 3900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'decoration' }, { value: 'baubles' }],
                options: [{ title: 'Color', values: ['Mixed'] }],
                variants: [{ title: 'Mixed', options: { Color: 'Mixed' }, prices: [{ amount: 3900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Christmas Stocking Set',
                description: 'Set of 4 embroidered velvet stockings.',
                prices: [{ amount: 4500, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'decoration' }, { value: 'stocking' }],
                options: [{ title: 'Set', values: ['Family 4'] }],
                variants: [{ title: 'Family 4', options: { Set: 'Family 4' }, prices: [{ amount: 4500, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            },
            {
                title: 'Outdoor Reindeer Lights',
                description: 'Light-up reindeer decoration for garden.',
                prices: [{ amount: 5900, currency_code: 'eur' }],
                tags: [{ value: CHRISTMAS_TAG }, { value: 'decoration' }, { value: 'outdoor' }],
                options: [{ title: 'Size', values: ['Large'] }],
                variants: [{ title: 'Large', options: { Size: 'Large' }, prices: [{ amount: 5900, currency_code: 'eur' }] }],
                thumbnail: 'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=600'
            }
        ]
    }
]

async function createCustomSeller(container: any, data: { name: string, email: string }) {
    const authService = container.resolve(Modules.AUTH)
    let authIdentity
    try {
        const res = await authService.register('emailpass', { body: { email: data.email, password: 'secret' } })
        authIdentity = res.authIdentity
    } catch (e) { console.log('User might already exist') }

    const { result: seller } = await createSellerWorkflow.run({
        container,
        input: {
            auth_identity_id: authIdentity?.id,
            member: { name: data.name, email: data.email },
            seller: { name: data.name }
        }
    })
    return seller
}

export default async function seedChristmas({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL)
    const [defaultSalesChannel] = await salesChannelModuleService.listSalesChannels({ name: 'Default Sales Channel' })
    const fulfillmentModule = container.resolve(FULFILLMENT_MODULE) as any
    const productModule = container.resolve(Modules.PRODUCT) as any

    logger.info('=== Starting Christmas Products Seeding ===')

    for (const data of christmasSellers) {
        logger.info(`Creating seller: ${data.name}`)

        let seller
        try {
            seller = await createCustomSeller(container, { name: data.name, email: data.email })
        } catch (e) {
            const sellerModule = container.resolve(SELLER_MODULE) as any
            const [existing] = await sellerModule.listSellers({ name: data.name })
            if (existing) { seller = existing } else { continue }
        }

        const link = container.resolve(ContainerRegistrationKeys.LINK)
        try {
            const { result: [stock] } = await createStockLocationsWorkflow(container).run({
                input: { locations: [{ name: `Stock for ${data.name}`, address: { city: 'Dublin', country_code: 'ie', address_1: 'Main St' } }] }
            })
            await link.create([
                { [SELLER_MODULE]: { seller_id: seller.id }, [Modules.STOCK_LOCATION]: { stock_location_id: stock.id } },
                { [Modules.STOCK_LOCATION]: { stock_location_id: stock.id }, [Modules.FULFILLMENT]: { fulfillment_provider_id: 'manual_manual' } },
                { [Modules.SALES_CHANNEL]: { sales_channel_id: defaultSalesChannel.id }, [Modules.STOCK_LOCATION]: { stock_location_id: stock.id } }
            ])
            await createLocationFulfillmentSetAndAssociateWithSellerWorkflow.run({
                container, input: { fulfillment_set_data: { name: `${seller.id} set`, type: 'shipping' }, location_id: stock.id, seller_id: seller.id }
            })
        } catch (e) { logger.warn(`Fulfillment setup for ${data.name} may exist`) }

        // Create tags
        const allTags = new Set<string>()
        data.products.forEach(p => p.tags?.forEach(t => allTags.add(t.value)))
        try {
            const existingTags = await productModule.listProductTags({ value: Array.from(allTags) })
            const existingValues = new Set(existingTags.map((t: any) => t.value))
            const missingValues = Array.from(allTags).filter(t => !existingValues.has(t))
            if (missingValues.length > 0) await productModule.createProductTags(missingValues.map(t => ({ value: t })))
        } catch (e) { }

        const resolvedTags = await productModule.listProductTags({ value: Array.from(allTags) })
        const tagMap = new Map(resolvedTags.map((t: any) => [t.value, t.id]))

        const productsToCreate = data.products.map(p => ({
            ...p,
            tags: p.tags?.map(t => ({ id: tagMap.get(t.value) })).filter(t => t.id),
            sales_channels: [{ id: defaultSalesChannel.id }],
            status: 'published'
        }))

        logger.info(`Creating ${productsToCreate.length} products`)
        try {
            await createProductsWorkflow.run({ container, input: { products: productsToCreate as any, additional_data: { seller_id: seller.id } } })
        } catch (e) { logger.error(`Product creation failed: ${e.message}`) }

        try { await fulfillmentModule.createFulfillmentJourneys({ type: 'manual', seller_id: seller.id }) } catch (e) { }
    }

    logger.info('=== Christmas Products Seeding Completed ===')
}
