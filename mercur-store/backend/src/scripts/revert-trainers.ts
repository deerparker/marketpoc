import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys } from '@medusajs/framework/utils'
import { FULFILLMENT_MODULE } from '../modules/fulfillment'

export default async function revertTrainers({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const query = container.resolve(ContainerRegistrationKeys.QUERY)
    const fulfillmentModule = container.resolve(FULFILLMENT_MODULE) as any

    logger.info('Reverting Trainers Fulfillment to Manual/Basket...')

    // 1. Find "dolans-trainers" seller
    const { data: sellers } = await query.graph({
        entity: 'seller',
        fields: ['id', 'handle'],
        filters: {
            handle: 'dolans-trainers'
        }
    })

    if (sellers.length === 0) {
        logger.warn('Seller "dolans-trainers" not found!')
        return
    }

    const seller = sellers[0]
    logger.info(`Found seller: ${seller.handle} (${seller.id})`)

    // 2. Find existing journey
    const result = await fulfillmentModule.listFulfillmentJourneys({
        seller_id: seller.id
    })
    const journeys = Array.isArray(result) ? result : result[0]

    if (!journeys || journeys.length === 0) {
        logger.info('No journey found for this seller. It creates "manual" behavior by default (null).')
        // Determine if we need to create explicit manual or leave as null.
        // App logic: if (journey == null || journey.type == 'manual') -> Basket.
        // So leaving it null is fine, but to prevent seed-fulfillment from re-adding whatsapp,
        // maybe we should explicitly create a 'manual' one.
        await fulfillmentModule.createFulfillmentJourneys({
            type: 'manual',
            config: {},
            seller_id: seller.id
        })
        logger.info('Created explicit "manual" journey.')
        return
    }

    const journey = journeys[0]
    logger.info(`Found journey: ${journey.id} type=${journey.type}`)

    // 3. Update to manual
    if (journey.type !== 'manual') {
        await fulfillmentModule.updateFulfillmentJourneys([
            {
                id: journey.id,
                type: 'manual',
                config: {} // Clear config
            }
        ])
        logger.info('Updated journey to "manual".')
    } else {
        logger.info('Journey is already manual.')
    }
}
