import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { FULFILLMENT_MODULE } from "../../../../modules/fulfillment"

export const GET = async (req: MedusaRequest, res: MedusaResponse) => {
    const fulfillmentModule = req.scope.resolve(FULFILLMENT_MODULE) as any
    const query = req.scope.resolve("query")

    // Use Query to fetch with filters if possible, or use module service
    // Since link is established, we could query graph.
    // But for now, let's just query the module directly if we have seller_id stored in it.
    // Our model has seller_id.

    const [journey] = await fulfillmentModule.listFulfillmentJourneys({
        seller_id: req.params.seller_id
    })

    res.json({
        journey: journey || null
    })
}
