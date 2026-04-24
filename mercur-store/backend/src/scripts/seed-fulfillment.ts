import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys } from '@medusajs/framework/utils'
import { FULFILLMENT_MODULE } from '../modules/fulfillment'

export default async function seedFulfillment({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const fulfillmentModule = container.resolve(FULFILLMENT_MODULE) as any
    const query = container.resolve(ContainerRegistrationKeys.QUERY)

    logger.info('Seeding Fulfillment Journeys...')

    // 1. Find the seller we want to update (e.g. the one created by main seed)
    // 1. Find ALL sellers
    const { data: sellers } = await query.graph({
        entity: "seller",
        fields: ["id", "handle"],
    })

    if (sellers.length === 0) {
        logger.warn("No sellers found. Skipping fulfillment seeding.")
        return
    }

    logger.info(`Found ${sellers.length} sellers. Seeding fulfillment journeys for all...`)

    // 2. iterate and create journey for each
    for (const seller of sellers) {
        try {
            const existing = await fulfillmentModule.listFulfillmentJourneys({
                seller_id: seller.id
            })

            if (existing.length > 0) {
                logger.info(`Seller ${seller.handle} already has journey. Skipping.`)
                continue
            }

            await fulfillmentModule.createFulfillmentJourneys({
                type: 'whatsapp',
                config: {
                    phone: '+15550101234', // Default phone
                    message_template: 'Hi, I found {product} on Mercur and would like to buy it.'
                },
                seller_id: seller.id
            })
            logger.info(`Created WhatsApp journey for seller: ${seller.handle}`)
        } catch (error) {
            logger.error(`Error creating fulfillment journey for seller ${seller.handle}:`, error)
        }
    }

    logger.info('Fulfillment seeding finished.')
}
