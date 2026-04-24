import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import { updateProductsWorkflow } from '@medusajs/medusa/core-flows'

// Re-define the tags we want locally for simplicity
const repairs = [
    { title: 'Premium Baby Stroller', tags: ['baby', 'kids', 'havingBaby'] },
    { title: 'Newborn Essentials Kit', tags: ['baby', 'clothes'] },
    { title: 'Nursery Design Consultation', tags: ['baby', 'service'] },
    { title: 'Custom Wedding Invitations', tags: ['wedding', 'paper', 'gettingMarried'] },
    { title: 'Bridal Boutique Appointment', tags: ['wedding', 'service'] },
    { title: 'GPS Navigation System', tags: ['car', 'electronics', 'buyingCar'] },
    { title: 'Full Vehicle Detailing', tags: ['car', 'service'] },
    { title: 'Ergonomic Office Chair', tags: ['business', 'furniture', 'startingBusiness'] },
    { title: 'Legal Incorporation Package', tags: ['business', 'service'] }
]

export default async function repairLifeEvents({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    logger.info('Starting Life Events Repair (Upsert Strategy)...')

    // 1. Resolve Tags (Fetch existing, create missing)
    const allUniqueTags = new Set<string>()
    repairs.forEach(r => r.tags.forEach(t => allUniqueTags.add(t)))
    const allTagValues = Array.from(allUniqueTags)

    logger.info(`Resolving ${allUniqueTags.size} tags...`)

    let existingTags: any[] = []
    try {
        existingTags = await productModule.listProductTags({ value: allTagValues })
    } catch (e) {
        logger.warn('Error listing tags, assuming none exist or empty list returned', e)
    }

    const existingValues = new Set(existingTags.map((t: any) => t.value))
    const missingValues = allTagValues.filter(t => !existingValues.has(t))

    if (missingValues.length > 0) {
        logger.info(`Creating ${missingValues.length} missing tags...`)
        const newTags = await productModule.createProductTags(
            missingValues.map(t => ({ value: t }))
        )
        existingTags = [...existingTags, ...newTags]
    }

    const tagMap = new Map(existingTags.map((t: any) => [t.value, t.id]))

    logger.info(`Resolved ${tagMap.size} tag IDs.`)

    // 2. Update Target Products
    for (const repair of repairs) {
        const [product] = await productModule.listProducts({ title: repair.title })

        if (!product) {
            logger.warn(`Product not found: ${repair.title}`)
            continue
        }

        logger.info(`Updating ${product.title}...`)

        const tagRef = repair.tags.map(t => ({ id: tagMap.get(t) })).filter(t => t.id)

        // Using workflow for full product update cycle
        await updateProductsWorkflow(container).run({
            input: {
                products: [{
                    id: product.id,
                    status: 'published',
                    tags: tagRef
                }] as any
            }
        })

        logger.info(`  -> Published & Tagged`)
    }

    logger.info('Repair Completed.')
}
