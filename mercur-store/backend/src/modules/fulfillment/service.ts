import { MedusaService } from "@medusajs/framework/utils"
import { FulfillmentJourney } from "./models/fulfillment-journey"

class FulfillmentModuleService extends MedusaService({
    FulfillmentJourney,
}) { }

export default FulfillmentModuleService
