import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function verifyFitnessProducts({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    logger.info('=== Verifying Fitness Products ===')

    // Check products tagged with gettingFit
    const fitnessProducts = await productModule.listProducts(
        { tags: { value: ['gettingFit'] } },
        { relations: ['tags'] }
    )

    logger.info(`Found ${fitnessProducts.length} products with 'gettingFit' tag`)

    for (const p of fitnessProducts) {
        logger.info(`  - ${p.title} (${p.status}) [${p.tags?.map(t => t.value).join(', ')}]`)
    }

    // Also check trainer/running products
    const trainerProducts = await productModule.listProducts(
        { q: 'Trainer' },
        { relations: ['tags'] }
    )

    logger.info(`\nProducts matching 'Trainer':`)
    for (const p of trainerProducts) {
        logger.info(`  - ${p.title} (${p.status}) [${p.tags?.map(t => t.value).join(', ')}]`)
    }
}
