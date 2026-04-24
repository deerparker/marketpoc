import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function seedProductOverride({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productService = container.resolve(Modules.PRODUCT) as any

    logger.info('Seeding Product Override...')

    // 1. Find a product
    const [products] = await productService.listAndCountProducts({}, { take: 1 })

    if (products.length === 0) {
        logger.warn('No products found.')
        return
    }

    const product = products[0]
    logger.info(`Updating product: ${product.title} (${product.id})`)

    // 2. Update metadata with override
    // We'll set it to a 'link' type to test the new functionality
    await productService.updateProducts(product.id, {
        metadata: {
            ...product.metadata,
            fulfillment_journey: {
                type: 'link',
                config: {
                    url: 'https://www.google.com/search?q=tracking_test',
                    button_text: 'Buy on Google (Tracked)',
                    tracking_code: 'ref=123'
                }
            }
        }
    })

    logger.info('Successfully updated product metadata with fulfillment override.')
}
