import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function verifyChristmas({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    logger.info('=== Verifying Christmas Products ===')

    // Check products tagged with christmas
    const christmasProducts = await productModule.listProducts(
        { tags: { value: ['christmas'] } },
        { relations: ['tags'] }
    )

    logger.info(`Products with 'christmas' tag: ${christmasProducts.length}`)
    for (const p of christmasProducts) {
        logger.info(`  ✓ ${p.title} (${p.status}) [${p.tags?.map(t => t.value).join(', ')}]`)
    }

    // Also check by title
    const treeProducts = await productModule.listProducts({ q: 'Christmas' }, { relations: ['tags'] })
    logger.info(`\nProducts matching 'Christmas' in title: ${treeProducts.length}`)
    for (const p of treeProducts) {
        logger.info(`  - ${p.title} [${p.tags?.map(t => t.value).join(', ')}]`)
    }

    const turkeyProducts = await productModule.listProducts({ q: 'Turkey' }, { relations: ['tags'] })
    logger.info(`\nProducts matching 'Turkey': ${turkeyProducts.length}`)
    for (const p of turkeyProducts) {
        logger.info(`  - ${p.title} [${p.tags?.map(t => t.value).join(', ')}]`)
    }
}
