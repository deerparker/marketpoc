"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GET = void 0;
const utils_1 = require("@medusajs/framework/utils");
const seller_return_request_1 = __importDefault(require("../../../links/seller-return-request"));
/**
 * @oas [get] /vendor/return-request
 * operationId: "VendorListOrderReturnRequests"
 * summary: "List return requests"
 * description: "Retrieves requests list"
 * x-authenticated: true
 * parameters:
 *   - name: fields
 *     in: query
 *     schema:
 *       type: string
 *     required: false
 *     description: Comma-separated fields to include in the response.
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             order_return_request:
 *               type: array
 *               items:
 *                 $ref: "#/components/schemas/OrderReturnRequest"
 *             count:
 *               type: integer
 *               description: The total number of requests
 *             offset:
 *               type: integer
 *               description: The number of requests skipped
 *             limit:
 *               type: integer
 *               description: The number of requests per page
 * tags:
 *   - Vendor Return Requests
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
const GET = async (req, res) => {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: orderReturnRequests, metadata } = await query.graph({
        entity: seller_return_request_1.default.entryPoint,
        fields: req.queryConfig.fields.map((field) => `order_return_request.${field}`),
        filters: {
            ...req.filterableFields,
            deleted_at: {
                $eq: null
            }
        },
        pagination: req.queryConfig.pagination
    });
    res.json({
        order_return_request: orderReturnRequests.map((rel) => rel.order_return_request),
        count: metadata.count,
        offset: metadata.skip,
        limit: metadata.take
    });
};
exports.GET = GET;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL3ZlbmRvci9yZXR1cm4tcmVxdWVzdC9yb3V0ZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7Ozs7QUFDQSxxREFBcUU7QUFFckUsaUdBQXNFO0FBRXRFOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7R0F1Q0c7QUFDSSxNQUFNLEdBQUcsR0FBRyxLQUFLLEVBQ3RCLEdBQStCLEVBQy9CLEdBQW1CLEVBQ25CLEVBQUU7SUFDRixNQUFNLEtBQUssR0FBRyxHQUFHLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUVoRSxNQUFNLEVBQUUsSUFBSSxFQUFFLG1CQUFtQixFQUFFLFFBQVEsRUFBRSxHQUFHLE1BQU0sS0FBSyxDQUFDLEtBQUssQ0FBQztRQUNoRSxNQUFNLEVBQUUsK0JBQW1CLENBQUMsVUFBVTtRQUN0QyxNQUFNLEVBQUUsR0FBRyxDQUFDLFdBQVcsQ0FBQyxNQUFNLENBQUMsR0FBRyxDQUNoQyxDQUFDLEtBQUssRUFBRSxFQUFFLENBQUMsd0JBQXdCLEtBQUssRUFBRSxDQUMzQztRQUNELE9BQU8sRUFBRTtZQUNQLEdBQUcsR0FBRyxDQUFDLGdCQUFnQjtZQUN2QixVQUFVLEVBQUU7Z0JBQ1YsR0FBRyxFQUFFLElBQUk7YUFDVjtTQUNGO1FBQ0QsVUFBVSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsVUFBVTtLQUN2QyxDQUFDLENBQUE7SUFFRixHQUFHLENBQUMsSUFBSSxDQUFDO1FBQ1Asb0JBQW9CLEVBQUUsbUJBQW1CLENBQUMsR0FBRyxDQUMzQyxDQUFDLEdBQUcsRUFBRSxFQUFFLENBQUMsR0FBRyxDQUFDLG9CQUFvQixDQUNsQztRQUNELEtBQUssRUFBRSxRQUFTLENBQUMsS0FBSztRQUN0QixNQUFNLEVBQUUsUUFBUyxDQUFDLElBQUk7UUFDdEIsS0FBSyxFQUFFLFFBQVMsQ0FBQyxJQUFJO0tBQ3RCLENBQUMsQ0FBQTtBQUNKLENBQUMsQ0FBQTtBQTVCWSxRQUFBLEdBQUcsT0E0QmYifQ==