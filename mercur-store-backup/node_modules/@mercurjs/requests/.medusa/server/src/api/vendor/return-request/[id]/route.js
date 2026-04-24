"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POST = exports.GET = void 0;
const utils_1 = require("@medusajs/framework/utils");
const workflows_1 = require("../../../../workflows/order-return-request/workflows");
/**
 * @oas [get] /vendor/return-request/{id}
 * operationId: "VendorGetOrderReturnRequestById"
 * summary: "Get return request by id"
 * description: "Retrieves a request by id for the authenticated vendor."
 * x-authenticated: true
 * parameters:
 *   - in: path
 *     name: id
 *     required: true
 *     description: The ID of the Request.
 *     schema:
 *       type: string
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
 *             orderReturnRequest:
 *               $ref: "#/components/schemas/OrderReturnRequest"
 * tags:
 *   - Vendor Return Requests
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
const GET = async (req, res) => {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [order_return_request] } = await query.graph({
        entity: 'order_return_request',
        fields: req.queryConfig.fields,
        filters: {
            id: req.params.id
        }
    });
    res.json({ order_return_request });
};
exports.GET = GET;
/**
 * @oas [post] /vendor/return-request/{id}
 * operationId: "VendorUpdateOrderReturnRequestById"
 * summary: "Update return request by id"
 * description: "Updates a request by id for the authenticated vendor."
 * x-authenticated: true
 * parameters:
 *   - in: path
 *     name: id
 *     required: true
 *     description: The ID of the Request.
 *     schema:
 *       type: string
 * requestBody:
 *   content:
 *     application/json:
 *       schema:
 *         $ref: "#/components/schemas/VendorUpdateOrderReturnRequest"
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             orderReturnRequest:
 *               $ref: "#/components/schemas/OrderReturnRequest"
 * tags:
 *   - Vendor Return Requests
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
const POST = async (req, res) => {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [request] } = await query.graph({
        entity: 'order_return_request',
        fields: req.queryConfig.fields,
        filters: {
            id: req.params.id,
            status: 'pending'
        }
    });
    if (!request) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_ARGUMENT, 'Request is not in pending state!');
    }
    const { result: order_return_request } = await workflows_1.updateOrderReturnRequestWorkflow.run({
        input: {
            id: req.params.id,
            ...req.validatedBody,
            vendor_reviewer_id: req.auth_context.actor_id,
            vendor_review_date: new Date()
        },
        container: req.scope
    });
    res.json({ order_return_request });
};
exports.POST = POST;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL3ZlbmRvci9yZXR1cm4tcmVxdWVzdC9baWRdL3JvdXRlLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLHFEQUdrQztBQUVsQyxvRkFBdUc7QUFHdkc7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7R0FrQ0c7QUFDSSxNQUFNLEdBQUcsR0FBRyxLQUFLLEVBQ3RCLEdBQStCLEVBQy9CLEdBQW1CLEVBQ25CLEVBQUU7SUFDRixNQUFNLEtBQUssR0FBRyxHQUFHLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUVoRSxNQUFNLEVBQ0osSUFBSSxFQUFFLENBQUMsb0JBQW9CLENBQUMsRUFDN0IsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLHNCQUFzQjtRQUM5QixNQUFNLEVBQUUsR0FBRyxDQUFDLFdBQVcsQ0FBQyxNQUFNO1FBQzlCLE9BQU8sRUFBRTtZQUNQLEVBQUUsRUFBRSxHQUFHLENBQUMsTUFBTSxDQUFDLEVBQUU7U0FDbEI7S0FDRixDQUFDLENBQUE7SUFFRixHQUFHLENBQUMsSUFBSSxDQUFDLEVBQUUsb0JBQW9CLEVBQUUsQ0FBQyxDQUFBO0FBQ3BDLENBQUMsQ0FBQTtBQWpCWSxRQUFBLEdBQUcsT0FpQmY7QUFFRDs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0dBaUNHO0FBQ0ksTUFBTSxJQUFJLEdBQUcsS0FBSyxFQUN2QixHQUFtRSxFQUNuRSxHQUFtQixFQUNuQixFQUFFO0lBQ0YsTUFBTSxLQUFLLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxPQUFPLENBQUMsaUNBQXlCLENBQUMsS0FBSyxDQUFDLENBQUE7SUFFaEUsTUFBTSxFQUNKLElBQUksRUFBRSxDQUFDLE9BQU8sQ0FBQyxFQUNoQixHQUFHLE1BQU0sS0FBSyxDQUFDLEtBQUssQ0FBQztRQUNwQixNQUFNLEVBQUUsc0JBQXNCO1FBQzlCLE1BQU0sRUFBRSxHQUFHLENBQUMsV0FBVyxDQUFDLE1BQU07UUFDOUIsT0FBTyxFQUFFO1lBQ1AsRUFBRSxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtZQUNqQixNQUFNLEVBQUUsU0FBUztTQUNsQjtLQUNGLENBQUMsQ0FBQTtJQUVGLElBQUksQ0FBQyxPQUFPLEVBQUUsQ0FBQztRQUNiLE1BQU0sSUFBSSxtQkFBVyxDQUNuQixtQkFBVyxDQUFDLEtBQUssQ0FBQyxnQkFBZ0IsRUFDbEMsa0NBQWtDLENBQ25DLENBQUE7SUFDSCxDQUFDO0lBRUQsTUFBTSxFQUFFLE1BQU0sRUFBRSxvQkFBb0IsRUFBRSxHQUNwQyxNQUFNLDRDQUFnQyxDQUFDLEdBQUcsQ0FBQztRQUN6QyxLQUFLLEVBQUU7WUFDTCxFQUFFLEVBQUUsR0FBRyxDQUFDLE1BQU0sQ0FBQyxFQUFFO1lBQ2pCLEdBQUcsR0FBRyxDQUFDLGFBQWE7WUFDcEIsa0JBQWtCLEVBQUUsR0FBRyxDQUFDLFlBQVksQ0FBQyxRQUFRO1lBQzdDLGtCQUFrQixFQUFFLElBQUksSUFBSSxFQUFFO1NBQy9CO1FBQ0QsU0FBUyxFQUFFLEdBQUcsQ0FBQyxLQUFLO0tBQ3JCLENBQUMsQ0FBQTtJQUVKLEdBQUcsQ0FBQyxJQUFJLENBQUMsRUFBRSxvQkFBb0IsRUFBRSxDQUFDLENBQUE7QUFDcEMsQ0FBQyxDQUFBO0FBcENZLFFBQUEsSUFBSSxRQW9DaEIifQ==