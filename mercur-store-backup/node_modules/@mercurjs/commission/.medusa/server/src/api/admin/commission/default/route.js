"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POST = POST;
exports.GET = GET;
const utils_1 = require("@medusajs/framework/utils");
const workflows_1 = require("../../../../workflows/commission/workflows");
const validators_1 = require("../validators");
/**
 * @oas [post] /admin/commission/default
 * operationId: "AdminUpsertDefaultCommissionRule"
 * summary: "Upsert default CommissionRule"
 * description: "Creates or updates default commission rule."
 * x-authenticated: true
 * requestBody:
 *   content:
 *     application/json:
 *       schema:
 *         $ref: "#/components/schemas/AdminUpsertDefaultCommissionRule"
 * responses:
 *   "200":
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
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    await workflows_1.upsertDefaultCommissionRuleWorkflow.run({
        container: req.scope,
        input: req.validatedBody
    });
    const { data: [default_rule] } = await query.graph({
        entity: 'commission_rule',
        fields: ['id'],
        filters: {
            reference: 'site'
        }
    });
    const { result: { commission_rules: [commission_rule] } } = await workflows_1.listCommissionRulesWorkflow.run({
        container: req.scope,
        input: {
            ids: [default_rule.id]
        }
    });
    res.json({
        commission_rule
    });
}
/**
 * @oas [get] /admin/commission/default
 * operationId: "AdminGetDefaultCommissionRule"
 * summary: "Get default commission rule"
 * description: "Retrieves a commission rule with 'site' reference type."
 * x-authenticated: true
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             commission_rule:
 *               $ref: "#/components/schemas/AdminCommissionAggregate"
 * tags:
 *   - Admin Commission
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function GET(req, res) {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [default_rule] } = await query.graph({
        entity: 'commission_rule',
        fields: ['id'],
        filters: {
            reference: 'site'
        }
    });
    if (!default_rule) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.NOT_FOUND, 'Rule not found!');
    }
    const { result: { commission_rules: [commission_rule] } } = await workflows_1.listCommissionRulesWorkflow.run({
        container: req.scope,
        input: {
            ids: [default_rule.id]
        }
    });
    res.json({
        commission_rule
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL2NvbW1pc3Npb24vZGVmYXVsdC9yb3V0ZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQTBDQSxvQkFvQ0M7QUF3QkQsa0JBa0NDO0FBdklELHFEQUdrQztBQUVsQywwRUFHbUQ7QUFDbkQsOENBR3NCO0FBRXRCOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQTBCRztBQUNJLEtBQUssVUFBVSxJQUFJLENBQ3hCLEdBQXdELEVBQ3hELEdBQW1CO0lBRW5CLElBQUEsbUNBQXNCLEVBQUMsR0FBRyxDQUFDLGFBQWEsQ0FBQyxJQUFJLENBQUMsQ0FBQTtJQUM5QyxNQUFNLEtBQUssR0FBRyxHQUFHLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUVoRSxNQUFNLCtDQUFtQyxDQUFDLEdBQUcsQ0FBQztRQUM1QyxTQUFTLEVBQUUsR0FBRyxDQUFDLEtBQUs7UUFDcEIsS0FBSyxFQUFFLEdBQUcsQ0FBQyxhQUFhO0tBQ3pCLENBQUMsQ0FBQTtJQUVGLE1BQU0sRUFDSixJQUFJLEVBQUUsQ0FBQyxZQUFZLENBQUMsRUFDckIsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixNQUFNLEVBQUUsQ0FBQyxJQUFJLENBQUM7UUFDZCxPQUFPLEVBQUU7WUFDUCxTQUFTLEVBQUUsTUFBTTtTQUNsQjtLQUNGLENBQUMsQ0FBQTtJQUVGLE1BQU0sRUFDSixNQUFNLEVBQUUsRUFDTixnQkFBZ0IsRUFBRSxDQUFDLGVBQWUsQ0FBQyxFQUNwQyxFQUNGLEdBQUcsTUFBTSx1Q0FBMkIsQ0FBQyxHQUFHLENBQUM7UUFDeEMsU0FBUyxFQUFFLEdBQUcsQ0FBQyxLQUFLO1FBQ3BCLEtBQUssRUFBRTtZQUNMLEdBQUcsRUFBRSxDQUFDLFlBQVksQ0FBQyxFQUFFLENBQUM7U0FDdkI7S0FDRixDQUFDLENBQUE7SUFFRixHQUFHLENBQUMsSUFBSSxDQUFDO1FBQ1AsZUFBZTtLQUNoQixDQUFDLENBQUE7QUFDSixDQUFDO0FBRUQ7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQXFCRztBQUNJLEtBQUssVUFBVSxHQUFHLENBQ3ZCLEdBQWtCLEVBQ2xCLEdBQW1CO0lBRW5CLE1BQU0sS0FBSyxHQUFHLEdBQUcsQ0FBQyxLQUFLLENBQUMsT0FBTyxDQUFDLGlDQUF5QixDQUFDLEtBQUssQ0FBQyxDQUFBO0lBRWhFLE1BQU0sRUFDSixJQUFJLEVBQUUsQ0FBQyxZQUFZLENBQUMsRUFDckIsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixNQUFNLEVBQUUsQ0FBQyxJQUFJLENBQUM7UUFDZCxPQUFPLEVBQUU7WUFDUCxTQUFTLEVBQUUsTUFBTTtTQUNsQjtLQUNGLENBQUMsQ0FBQTtJQUVGLElBQUksQ0FBQyxZQUFZLEVBQUUsQ0FBQztRQUNsQixNQUFNLElBQUksbUJBQVcsQ0FBQyxtQkFBVyxDQUFDLEtBQUssQ0FBQyxTQUFTLEVBQUUsaUJBQWlCLENBQUMsQ0FBQTtJQUN2RSxDQUFDO0lBRUQsTUFBTSxFQUNKLE1BQU0sRUFBRSxFQUNOLGdCQUFnQixFQUFFLENBQUMsZUFBZSxDQUFDLEVBQ3BDLEVBQ0YsR0FBRyxNQUFNLHVDQUEyQixDQUFDLEdBQUcsQ0FBQztRQUN4QyxTQUFTLEVBQUUsR0FBRyxDQUFDLEtBQUs7UUFDcEIsS0FBSyxFQUFFO1lBQ0wsR0FBRyxFQUFFLENBQUMsWUFBWSxDQUFDLEVBQUUsQ0FBQztTQUN2QjtLQUNGLENBQUMsQ0FBQTtJQUVGLEdBQUcsQ0FBQyxJQUFJLENBQUM7UUFDUCxlQUFlO0tBQ2hCLENBQUMsQ0FBQTtBQUNKLENBQUMifQ==