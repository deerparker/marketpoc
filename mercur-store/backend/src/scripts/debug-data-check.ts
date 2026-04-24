import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import { FULFILLMENT_MODULE } from '../modules/fulfillment'

export default async function debugDataCheck({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const query = container.resolve(ContainerRegistrationKeys.QUERY)
    const fulfillmentModule = container.resolve(FULFILLMENT_MODULE) as any

    logger.info('--- Debug Data Check ---')

    // 1. List Sellers
    const { data: sellers } = await query.graph({
        entity: 'seller',
        fields: ['id', 'handle', 'name'],
    })
    logger.info(`Found ${sellers.length} sellers:`)
    sellers.forEach((s: any) => logger.info(` - ${s.id} (${s.handle})`))

    // 2. List Fulfillment Journeys
    const result = await fulfillmentModule.listFulfillmentJourneys({})
    const journeys = Array.isArray(result) ? result : result[0] // handle [items, count] or items[]

    if (!journeys) {
        logger.info('Journeys is undefined/null')
    } else {
        logger.info(`Found ${journeys.length} fulfillment journeys:`)
        journeys.forEach((j: any) => logger.info(` - ${j.id} (type: ${j.type}) for seller: ${j.seller_id}`))
    }

    // 3. Check AIR FORCE 1 Product
    const { data: products } = await query.graph({
        entity: 'product',
        fields: ['id', 'title', 'seller.id'],
        filters: {
            handle: 'air-force-1-luxe-unisex-sneakers'
        }
    })

    if (products.length > 0) {
        const p = products[0]
        logger.info(`Product "AIR FORCE 1": ${p.id}`)
        logger.info(` - Linked Seller ID: ${p.seller?.id}`)
    } else {
        logger.warn('Product "AIR FORCE 1" not found via query.')
    }

    logger.info('--- End Debug ---')
}
