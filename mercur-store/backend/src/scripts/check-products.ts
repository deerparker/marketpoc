import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function checkProducts({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productApp = container.resolve(Modules.PRODUCT)

    const products = await productApp.listProducts({
        title: ['Premium Baby Stroller', 'Nursery Design Consultation', 'GPS Navigation System']
    }, {
        relations: ['tags']
    })

    logger.info(`Found ${products.length} seeded products.`)

    for (const p of products) {
        logger.info(`Product: ${p.title}`)
        logger.info(`  Status: ${p.status}`)
        logger.info(`  Tags: ${p.tags?.map(t => t.value).join(', ') || 'None'}`)
    }
}
