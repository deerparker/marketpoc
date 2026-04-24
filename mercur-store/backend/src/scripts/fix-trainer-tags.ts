import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'
import { updateProductsWorkflow } from '@medusajs/medusa/core-flows'

export default async function repairTags({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    const tagValues = ['gettingFit', 'trainer', 'fitness']

    // 1. Resolve Tags
    logger.info('Resolving tags...')
    const existingTags = await productModule.listProductTags({ value: tagValues })
    const existingValues = new Set(existingTags.map(t => t.value))
    const missingValues = tagValues.filter(v => !existingValues.has(v))

    let allTags = [...existingTags]
    if (missingValues.length > 0) {
        logger.info(`Creating ${missingValues.length} missing tags...`)
        const newTags = await productModule.createProductTags(
            missingValues.map(v => ({ value: v }))
        )
        allTags = [...allTags, ...newTags]
    }

    const tagIds = allTags.map(t => ({ id: t.id }))

    // 2. Fetch products
    const [products] = await productModule.listAndCountProducts({
        q: 'sneaker'
    }, { select: ['id'], relations: ['tags'] })

    const [runners] = await productModule.listAndCountProducts({
        q: 'runner'
    }, { select: ['id'], relations: ['tags'] })

    const toUpdate = [...products, ...runners]
    const uniqueToUpdate = Array.from(new Set(toUpdate.map(p => p.id)))
        .map(id => toUpdate.find(p => p.id === id))

    logger.info(`Found ${uniqueToUpdate.length} sneakers/runners to tag.`)

    const updates = uniqueToUpdate.map(p => {
        // Build new tags list (existing + new)
        const currentTagIds = (p.tags || []).map(t => ({ id: t.id }))
        const combined = [...currentTagIds]

        allTags.forEach(at => {
            if (!combined.some(c => c.id === at.id)) {
                combined.push({ id: at.id })
            }
        })

        return {
            id: p.id,
            tags: combined
        }
    })

    if (updates.length > 0) {
        await updateProductsWorkflow(container).run({
            input: { products: updates }
        })
        logger.info('Successfully updated trainer tags.')
    }
}
