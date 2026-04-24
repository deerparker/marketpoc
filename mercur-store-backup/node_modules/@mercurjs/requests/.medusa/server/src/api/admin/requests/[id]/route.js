"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POST = POST;
exports.GET = GET;
const utils_1 = require("@medusajs/framework/utils");
const select_workflow_1 = require("../../../../workflows/requests/utils/select-workflow");
const workflows_1 = require("../../../../workflows/requests/workflows");
/**
 * @oas [post] /admin/requests/{id}
 * operationId: "AdminReviewRequestById"
 * summary: "Get return request by id"
 * description: "Retrieves a request by id."
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
 *         $ref: "#/components/schemas/AdminReviewRequest"
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             id:
 *               type: string
 *             status:
 *               type: string
 *               enum: [accepted,rejected]
 * tags:
 *   - Admin Requests
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function POST(req, res) {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [request] } = await query.graph({
        entity: 'request',
        fields: ['id', 'type', 'data', 'submitter_id'],
        filters: {
            id: req.params.id,
            status: 'pending'
        }
    });
    if (!request) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_ARGUMENT, 'This request is already reviewed');
    }
    if (req.validatedBody.status === 'rejected') {
        await workflows_1.updateRequestWorkflow.run({
            input: {
                id: req.params.id,
                reviewer_id: req.auth_context.actor_id,
                ...req.validatedBody
            },
            container: req.scope
        });
        return res.json({
            id: req.params.id,
            status: 'rejected'
        });
    }
    const workflow = (0, select_workflow_1.getRequestWorkflowByType)(request.type);
    if (!workflow) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_DATA, 'This type of request does not have workflow');
    }
    const { result: createdResource } = await workflow(req.scope).run({
        input: {
            id: req.params.id,
            reviewer_id: req.auth_context.actor_id,
            data: request.data,
            ...req.validatedBody
        },
        throwOnError: true
    });
    return res.json({
        id: req.params.id,
        status: 'accepted',
        createdResourceType: request.type,
        createdResource
    });
}
/**
 * @oas [get] /admin/requests/{id}
 * operationId: "AdminGetRequestById"
 * summary: "Get return request by id"
 * description: "Retrieves a request by id."
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
 *             request:
 *               $ref: "#/components/schemas/AdminRequest"
 * tags:
 *   - Admin Requests
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function GET(req, res) {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [request] } = await query.graph({
        entity: 'request',
        fields: req.queryConfig.fields,
        filters: {
            id: req.params.id
        }
    });
    res.json({ request });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL3JlcXVlc3RzL1tpZF0vcm91dGUudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUErQ0Esb0JBaUVDO0FBcUNELGtCQWlCQztBQXJLRCxxREFHa0M7QUFFbEMsMEZBQStGO0FBQy9GLHdFQUFnRjtBQUdoRjs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0dBb0NHO0FBQ0ksS0FBSyxVQUFVLElBQUksQ0FDeEIsR0FBdUQsRUFDdkQsR0FBbUI7SUFFbkIsTUFBTSxLQUFLLEdBQUcsR0FBRyxDQUFDLEtBQUssQ0FBQyxPQUFPLENBQUMsaUNBQXlCLENBQUMsS0FBSyxDQUFDLENBQUE7SUFFaEUsTUFBTSxFQUNKLElBQUksRUFBRSxDQUFDLE9BQU8sQ0FBQyxFQUNoQixHQUFHLE1BQU0sS0FBSyxDQUFDLEtBQUssQ0FBQztRQUNwQixNQUFNLEVBQUUsU0FBUztRQUNqQixNQUFNLEVBQUUsQ0FBQyxJQUFJLEVBQUUsTUFBTSxFQUFFLE1BQU0sRUFBRSxjQUFjLENBQUM7UUFDOUMsT0FBTyxFQUFFO1lBQ1AsRUFBRSxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtZQUNqQixNQUFNLEVBQUUsU0FBUztTQUNsQjtLQUNGLENBQUMsQ0FBQTtJQUVGLElBQUksQ0FBQyxPQUFPLEVBQUUsQ0FBQztRQUNiLE1BQU0sSUFBSSxtQkFBVyxDQUNuQixtQkFBVyxDQUFDLEtBQUssQ0FBQyxnQkFBZ0IsRUFDbEMsa0NBQWtDLENBQ25DLENBQUE7SUFDSCxDQUFDO0lBRUQsSUFBSSxHQUFHLENBQUMsYUFBYSxDQUFDLE1BQU0sS0FBSyxVQUFVLEVBQUUsQ0FBQztRQUM1QyxNQUFNLGlDQUFxQixDQUFDLEdBQUcsQ0FBQztZQUM5QixLQUFLLEVBQUU7Z0JBQ0wsRUFBRSxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtnQkFDakIsV0FBVyxFQUFFLEdBQUcsQ0FBQyxZQUFZLENBQUMsUUFBUTtnQkFDdEMsR0FBRyxHQUFHLENBQUMsYUFBYTthQUNyQjtZQUNELFNBQVMsRUFBRSxHQUFHLENBQUMsS0FBSztTQUNyQixDQUFDLENBQUE7UUFFRixPQUFPLEdBQUcsQ0FBQyxJQUFJLENBQUM7WUFDZCxFQUFFLEVBQUUsR0FBRyxDQUFDLE1BQU0sQ0FBQyxFQUFFO1lBQ2pCLE1BQU0sRUFBRSxVQUFVO1NBQ25CLENBQUMsQ0FBQTtJQUNKLENBQUM7SUFFRCxNQUFNLFFBQVEsR0FBRyxJQUFBLDBDQUF3QixFQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQTtJQUV2RCxJQUFJLENBQUMsUUFBUSxFQUFFLENBQUM7UUFDZCxNQUFNLElBQUksbUJBQVcsQ0FDbkIsbUJBQVcsQ0FBQyxLQUFLLENBQUMsWUFBWSxFQUM5Qiw2Q0FBNkMsQ0FDOUMsQ0FBQTtJQUNILENBQUM7SUFFRCxNQUFNLEVBQUUsTUFBTSxFQUFFLGVBQWUsRUFBRSxHQUFHLE1BQU0sUUFBUSxDQUFDLEdBQUcsQ0FBQyxLQUFLLENBQUMsQ0FBQyxHQUFHLENBQUM7UUFDaEUsS0FBSyxFQUFFO1lBQ0wsRUFBRSxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtZQUNqQixXQUFXLEVBQUUsR0FBRyxDQUFDLFlBQVksQ0FBQyxRQUFRO1lBQ3RDLElBQUksRUFBRSxPQUFPLENBQUMsSUFBSTtZQUNsQixHQUFHLEdBQUcsQ0FBQyxhQUFhO1NBQ3JCO1FBQ0QsWUFBWSxFQUFFLElBQUk7S0FDbkIsQ0FBQyxDQUFBO0lBRUYsT0FBTyxHQUFHLENBQUMsSUFBSSxDQUFDO1FBQ2QsRUFBRSxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtRQUNqQixNQUFNLEVBQUUsVUFBVTtRQUNsQixtQkFBbUIsRUFBRSxPQUFPLENBQUMsSUFBSTtRQUNqQyxlQUFlO0tBQ2hCLENBQUMsQ0FBQTtBQUNKLENBQUM7QUFFRDs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQWtDRztBQUNJLEtBQUssVUFBVSxHQUFHLENBQ3ZCLEdBQStCLEVBQy9CLEdBQW1CO0lBRW5CLE1BQU0sS0FBSyxHQUFHLEdBQUcsQ0FBQyxLQUFLLENBQUMsT0FBTyxDQUFDLGlDQUF5QixDQUFDLEtBQUssQ0FBQyxDQUFBO0lBRWhFLE1BQU0sRUFDSixJQUFJLEVBQUUsQ0FBQyxPQUFPLENBQUMsRUFDaEIsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLFNBQVM7UUFDakIsTUFBTSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsTUFBTTtRQUM5QixPQUFPLEVBQUU7WUFDUCxFQUFFLEVBQUUsR0FBRyxDQUFDLE1BQU0sQ0FBQyxFQUFFO1NBQ2xCO0tBQ0YsQ0FBQyxDQUFBO0lBRUYsR0FBRyxDQUFDLElBQUksQ0FBQyxFQUFFLE9BQU8sRUFBRSxDQUFDLENBQUE7QUFDdkIsQ0FBQyJ9