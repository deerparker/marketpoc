import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import {
    createProductsWorkflow,
    createSalesChannelsWorkflow,
    createStockLocationsWorkflow
} from '@medusajs/medusa/core-flows'
import {
    createSellerWorkflow
} from '@mercurjs/b2c-core/workflows'
import { SELLER_MODULE } from '@mercurjs/b2c-core/modules/seller'
import { financialEventSellers } from './seed/financial-events-data'

export default async function seedFinancialEvents({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)

    logger.info('Starting Financial Events Seeding...')

    // 1. Get or Create Default Sales Channel
    const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL)
    let [salesChannel] = await salesChannelModuleService.listSalesChannels({
        name: 'Default Sales Channel'
    })

    if (!salesChannel) {
        const { result } = await createSalesChannelsWorkflow(container).run({
            input: { salesChannelsData: [{ name: 'Default Sales Channel' }] }
        })
        salesChannel = result[0]
    }

    logger.info(`Using Sales Channel: ${salesChannel.id}`)

    // 2. Create Tags First (Global)
    const allTags = new Set<string>()
    financialEventSellers.forEach(s => s.products.forEach(p => p.tags.forEach(t => allTags.add(t.value))))

    const productService = container.resolve(Modules.PRODUCT)
    const allTagValues = Array.from(allTags)

    // Find existing tags
    const existingTags = await productService.listProductTags({
        value: allTagValues
    })
    const existingTagValues = new Set(existingTags.map(t => t.value))

    // Create missing tags
    const missingTags = allTagValues.filter(t => !existingTagValues.has(t))
    let newTags: any[] = []
    if (missingTags.length > 0) {
        newTags = await productService.createProductTags(missingTags.map(t => ({ value: t })))
        logger.info(`Created ${newTags.length} new tags.`)
    }

    const allTagsCombined = [...existingTags, ...newTags]
    const tagMap = new Map(allTagsCombined.map(t => [t.value, t.id]))

    logger.info(`Created/Found ${allTagsCombined.length} tags.`)

    // 3. Iterate and Create Sellers
    for (const sellerData of financialEventSellers) {
        logger.info(`Processing Seller: ${sellerData.name}`)

        const authService = container.resolve(Modules.AUTH)
        let authIdentity

        try {
            // Try to register new
            const reg = await authService.register('emailpass', {
                body: {
                    email: sellerData.email,
                    password: 'secret_password_123'
                }
            })
            authIdentity = reg.authIdentity
            logger.info(`Created new auth identity for ${sellerData.email}`)
        } catch (e) {
            // console.error(e) // optional debug
            // If failed, likely exists. We continue to see if seller exists.
        }

        if (authIdentity) {
            logger.info(`Auth identity obtained: ${authIdentity.id}`)
        }

        let sellerId

        // Robust Seller Lookup
        const query = container.resolve(ContainerRegistrationKeys.QUERY)
        const { data: allSellers } = await query.graph({
            entity: 'seller',
            fields: ['id', 'handle']
        })
        logger.info(`Existing Sellers: ${allSellers.map(s => s.handle).join(', ')}`)
        // @ts-ignore
        const existingSeller = allSellers.find(s => s.handle === sellerData.handle)

        if (existingSeller) {
            sellerId = existingSeller.id
            logger.info(`Seller ${sellerData.name} already exists (${sellerId}). Updating...`)
            const sellerModule = container.resolve(SELLER_MODULE) as any
            await sellerModule.updateSellers({
                id: sellerId,
                description: sellerData.description,
                metadata: sellerData.metadata
            })
        } else {
            if (!authIdentity) {
                logger.warn(`Skipping seller creation for ${sellerData.name} because auth identity could not be created or found, and seller does not exist.`)
                continue
            }

            const { result: seller } = await createSellerWorkflow.run({
                container,
                input: {
                    auth_identity_id: authIdentity.id,
                    member: {
                        name: sellerData.name.split(' ')[0],
                        email: sellerData.email,
                    },
                    seller: {
                        name: sellerData.name,
                        handle: sellerData.handle,
                        description: sellerData.description,
                        metadata: sellerData.metadata // Pass metadata
                    }
                }
            })
            sellerId = seller.id
            logger.info(`Created Seller: ${seller.id}`)

            // Create Stock Location
            const { result: [stockLocation] } = await createStockLocationsWorkflow(container).run({
                input: {
                    locations: [{
                        name: `${sellerData.name} Warehouse`,
                        address: { city: 'Berlin', country_code: 'de', address_1: 'Test St' }
                    }]
                }
            })

            const link = container.resolve(ContainerRegistrationKeys.LINK)
            await link.create([
                {
                    [SELLER_MODULE]: { seller_id: sellerId },
                    [Modules.STOCK_LOCATION]: { stock_location_id: stockLocation.id }
                },
                {
                    [Modules.SALES_CHANNEL]: { sales_channel_id: salesChannel.id },
                    [Modules.STOCK_LOCATION]: { stock_location_id: stockLocation.id }
                }
            ])
        }

        // 4. Manage Products (Create or Update Tags)
        const existingProducts = await productService.listProducts({
            handle: sellerData.products.map(p => p.handle)
        })
        const productMap = new Map(existingProducts.map(p => [p.handle, p]))

        // Products to Create
        const productsToCreate = sellerData.products.filter(p => !productMap.has(p.handle))

        if (productsToCreate.length > 0) {
            logger.info(`Creating ${productsToCreate.length} products for ${sellerData.name}...`)
            const productsInput = productsToCreate.map(p => ({
                ...p,
                tags: p.tags.map(t => ({ id: tagMap.get(t.value) })).filter(t => t.id),
                sales_channels: [{ id: salesChannel.id }],
                status: 'published',
                // @ts-ignore
                metadata: p.metadata, // Pass metadata
                variants: p.variants.map(v => ({
                    ...v,
                    manage_inventory: false,
                    allow_backorder: true
                }))
            }))

            await createProductsWorkflow.run({
                container,
                input: {
                    products: productsInput,
                    additional_data: { seller_id: sellerId }
                }
            })
        }

        // Products to Update (Tags & Metadata)
        const productsToUpdate = sellerData.products.filter(p => productMap.has(p.handle))
        if (productsToUpdate.length > 0) {
            logger.info(`Updating tags & metadata for ${productsToUpdate.length} existing products...`)
            for (const p of productsToUpdate) {
                const existing = productMap.get(p.handle)
                const tagIds = p.tags.map(t => ({ id: tagMap.get(t.value) })).filter(t => t.id)

                // @ts-ignore
                await productService.updateProducts(existing.id, {
                    tags: tagIds,
                    // @ts-ignore
                    metadata: p.metadata // Update metadata
                })
            }
        }
    }

    logger.info('Financial Events Seeding Completed!')
}
