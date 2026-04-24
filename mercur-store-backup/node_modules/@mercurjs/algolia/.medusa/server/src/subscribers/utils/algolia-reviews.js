"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findAndTransformAlgoliaReviews = findAndTransformAlgoliaReviews;
const zod_1 = require("zod");
const utils_1 = require("@medusajs/framework/utils");
const framework_1 = require("@mercurjs/framework");
async function findAndTransformAlgoliaReviews(container, ids = []) {
    const query = container.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: reviews } = await query.graph({
        entity: 'review',
        fields: ['*', 'seller.id', 'product.id'],
        filters: ids.length
            ? {
                id: ids
            }
            : {}
    });
    for (const review of reviews) {
        review.reference_id = review.seller?.id || review.product?.id;
    }
    return zod_1.z.array(framework_1.AlgoliaReviewValidator).parse(reviews);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWxnb2xpYS1yZXZpZXdzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vc3JjL3N1YnNjcmliZXJzL3V0aWxzL2FsZ29saWEtcmV2aWV3cy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQU9BLHdFQW9CQztBQTNCRCw2QkFBdUI7QUFHdkIscURBQXFFO0FBRXJFLG1EQUE0RDtBQUVyRCxLQUFLLFVBQVUsOEJBQThCLENBQ2xELFNBQTBCLEVBQzFCLE1BQWdCLEVBQUU7SUFFbEIsTUFBTSxLQUFLLEdBQUcsU0FBUyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUNoRSxNQUFNLEVBQUUsSUFBSSxFQUFFLE9BQU8sRUFBRSxHQUFHLE1BQU0sS0FBSyxDQUFDLEtBQUssQ0FBQztRQUMxQyxNQUFNLEVBQUUsUUFBUTtRQUNoQixNQUFNLEVBQUUsQ0FBQyxHQUFHLEVBQUUsV0FBVyxFQUFFLFlBQVksQ0FBQztRQUN4QyxPQUFPLEVBQUUsR0FBRyxDQUFDLE1BQU07WUFDakIsQ0FBQyxDQUFDO2dCQUNFLEVBQUUsRUFBRSxHQUFHO2FBQ1I7WUFDSCxDQUFDLENBQUMsRUFBRTtLQUNQLENBQUMsQ0FBQTtJQUVGLEtBQUssTUFBTSxNQUFNLElBQUksT0FBTyxFQUFFLENBQUM7UUFDN0IsTUFBTSxDQUFDLFlBQVksR0FBRyxNQUFNLENBQUMsTUFBTSxFQUFFLEVBQUUsSUFBSSxNQUFNLENBQUMsT0FBTyxFQUFFLEVBQUUsQ0FBQTtJQUMvRCxDQUFDO0lBRUQsT0FBTyxPQUFDLENBQUMsS0FBSyxDQUFDLGtDQUFzQixDQUFDLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxDQUFBO0FBQ3ZELENBQUMifQ==