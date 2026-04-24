"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POST = POST;
exports.GET = GET;
const utils_1 = require("@medusajs/framework/utils");
const workflows_1 = require("../../../../workflows/commission/workflows");
const validators_1 = require("../validators");
/**
 * @oas [post] /admin/commission/rules
 * operationId: "AdminCreateCommissionRule"
 * summary: "Create a CommissionRule"
 * description: "Creates a new commission rule."
 * x-authenticated: true
 * requestBody:
 *   content:
 *     application/json:
 *       schema:
 *         $ref: "#/components/schemas/AdminCreateCommissionRule"
 * responses:
 *   "201":
 *     description: Created
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             commission_rule:
 *               $ref: "#/components/schemas/AdminCommissionRule"
 * tags:
 *   - Admin Commission
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function POST(req, res) {
    (0, validators_1.validateCommissionRate)(req.validatedBody.rate);
    (0, validators_1.validateCommissionRule)(req.validatedBody);
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { result } = await workflows_1.createCommissionRuleWorkflow.run({
        input: req.validatedBody,
        container: req.scope,
        throwOnError: true
    });
    const { data: [commission_rule] } = await query.graph({
        entity: 'commission_rule',
        fields: req.queryConfig.fields,
        filters: {
            id: result.id
        }
    });
    res.status(201).json({
        commission_rule
    });
}
/**
 * @oas [get] /admin/commission/rules
 * operationId: "AdminListCommissionRules"
 * summary: "List Commission rules"
 * description: "Retrieves a list of commission rules."
 * x-authenticated: true
 * parameters:
 *   - name: offset
 *     in: query
 *     schema:
 *       type: number
 *     required: false
 *     description: The number of items to skip before starting to collect the result set.
 *   - name: limit
 *     in: query
 *     schema:
 *       type: number
 *     required: false
 *     description: The number of items to return.
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             commission_rules:
 *               type: array
 *               items:
 *                 $ref: "#/components/schemas/AdminCommissionAggregate"
 *             count:
 *               type: integer
 *               description: The total number of items available
 *             offset:
 *               type: integer
 *               description: The number of items skipped before these items
 *             limit:
 *               type: integer
 *               description: The number of items per page
 *
 * tags:
 *   - Admin Commission
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function GET(req, res) {
    const { result } = await workflows_1.listCommissionRulesWorkflow.run({
        container: req.scope,
        input: { pagination: req.queryConfig.pagination }
    });
    res.json({
        commission_rules: result.commission_rules,
        count: result.count,
        offset: req.queryConfig.pagination.skip,
        limit: req.queryConfig.pagination.take
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL2NvbW1pc3Npb24vcnVsZXMvcm91dGUudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUF3Q0Esb0JBMkJDO0FBaURELGtCQWVDO0FBbElELHFEQUFxRTtBQUVyRSwwRUFHbUQ7QUFDbkQsOENBSXNCO0FBRXRCOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQTBCRztBQUNJLEtBQUssVUFBVSxJQUFJLENBQ3hCLEdBQWlELEVBQ2pELEdBQW1CO0lBRW5CLElBQUEsbUNBQXNCLEVBQUMsR0FBRyxDQUFDLGFBQWEsQ0FBQyxJQUFJLENBQUMsQ0FBQTtJQUM5QyxJQUFBLG1DQUFzQixFQUFDLEdBQUcsQ0FBQyxhQUFhLENBQUMsQ0FBQTtJQUN6QyxNQUFNLEtBQUssR0FBRyxHQUFHLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUVoRSxNQUFNLEVBQUUsTUFBTSxFQUFFLEdBQUcsTUFBTSx3Q0FBNEIsQ0FBQyxHQUFHLENBQUM7UUFDeEQsS0FBSyxFQUFFLEdBQUcsQ0FBQyxhQUFhO1FBQ3hCLFNBQVMsRUFBRSxHQUFHLENBQUMsS0FBSztRQUNwQixZQUFZLEVBQUUsSUFBSTtLQUNuQixDQUFDLENBQUE7SUFFRixNQUFNLEVBQ0osSUFBSSxFQUFFLENBQUMsZUFBZSxDQUFDLEVBQ3hCLEdBQUcsTUFBTSxLQUFLLENBQUMsS0FBSyxDQUFDO1FBQ3BCLE1BQU0sRUFBRSxpQkFBaUI7UUFDekIsTUFBTSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsTUFBTTtRQUM5QixPQUFPLEVBQUU7WUFDUCxFQUFFLEVBQUUsTUFBTSxDQUFDLEVBQUU7U0FDZDtLQUNGLENBQUMsQ0FBQTtJQUVGLEdBQUcsQ0FBQyxNQUFNLENBQUMsR0FBRyxDQUFDLENBQUMsSUFBSSxDQUFDO1FBQ25CLGVBQWU7S0FDaEIsQ0FBQyxDQUFBO0FBQ0osQ0FBQztBQUVEOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0dBOENHO0FBQ0ksS0FBSyxVQUFVLEdBQUcsQ0FDdkIsR0FBa0IsRUFDbEIsR0FBbUI7SUFFbkIsTUFBTSxFQUFFLE1BQU0sRUFBRSxHQUFHLE1BQU0sdUNBQTJCLENBQUMsR0FBRyxDQUFDO1FBQ3ZELFNBQVMsRUFBRSxHQUFHLENBQUMsS0FBSztRQUNwQixLQUFLLEVBQUUsRUFBRSxVQUFVLEVBQUUsR0FBRyxDQUFDLFdBQVcsQ0FBQyxVQUFVLEVBQUU7S0FDbEQsQ0FBQyxDQUFBO0lBRUYsR0FBRyxDQUFDLElBQUksQ0FBQztRQUNQLGdCQUFnQixFQUFFLE1BQU0sQ0FBQyxnQkFBZ0I7UUFDekMsS0FBSyxFQUFFLE1BQU0sQ0FBQyxLQUFLO1FBQ25CLE1BQU0sRUFBRSxHQUFHLENBQUMsV0FBVyxDQUFDLFVBQVUsQ0FBQyxJQUFJO1FBQ3ZDLEtBQUssRUFBRSxHQUFHLENBQUMsV0FBVyxDQUFDLFVBQVUsQ0FBQyxJQUFJO0tBQ3ZDLENBQUMsQ0FBQTtBQUNKLENBQUMifQ==