import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function checkTags({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    const [products] = await productModule.listAndCountProducts({}, {
        relations: ['tags'],
        select: ['id', 'title', 'tags']
    })

    logger.info(`Checking tags for ${products.length} products:`)

    // Check trainers/sneakers specifically
    const trainers = products.filter(p =>
        p.title.toLowerCase().includes('trainer') ||
        p.title.toLowerCase().includes('sneaker') ||
        p.title.toLowerCase().includes('runner')
    )

    logger.info(`--- Trainers/Sneakers (${trainers.length}) ---`)
    trainers.forEach(p => {
        logger.info(`Product: ${p.title} | Tags: ${JSON.stringify(p.tags?.map(t => t.value) || [])}`)
    })

    // Check Christmas products
    const christmas = products.filter(p => p.tags?.some(t => t.value === 'christmas'))
    logger.info(`\n--- Christmas Products (${christmas.length}) ---`)
    christmas.forEach(p => {
        logger.info(`Product: ${p.title} | Tags: ${JSON.stringify(p.tags?.map(t => t.value) || [])}`)
    })
}
