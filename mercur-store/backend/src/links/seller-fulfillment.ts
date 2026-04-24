import { defineLink } from "@medusajs/framework/utils"
import SellerModule from "@mercurjs/b2c-core/modules/seller"
import FulfillmentModule from "../modules/fulfillment"

export default defineLink(
    SellerModule.linkable.seller,
    FulfillmentModule.linkable.fulfillmentJourney
)
