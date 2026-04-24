"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POST = POST;
exports.DELETE = DELETE;
exports.GET = GET;
const utils_1 = require("@medusajs/framework/utils");
const workflows_1 = require("../../../../../workflows/commission/workflows");
/**
 * @oas [post] /admin/commission/rules/{id}
 * operationId: "AdminUpdateCommissionRuleById"
 * summary: "Update CommissionRule"
 * description: "Updates commission rule by id."
 * x-authenticated: true
 * parameters:
 *   - in: path
 *     name: id
 *     required: true
 *     description: The ID of the Rule.
 *     schema:
 *       type: string
 * requestBody:
 *   content:
 *     application/json:
 *       schema:
 *         $ref: "#/components/schemas/AdminUpdateCommissionRule"
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
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    await workflows_1.updateCommissionRuleWorkflow.run({
        input: { ...req.validatedBody, id: req.params.id },
        container: req.scope
    });
    const { data: [commission_rule] } = await query.graph({
        entity: 'commission_rule',
        fields: req.queryConfig.fields,
        filters: {
            id: req.params.id
        }
    });
    res.status(200).json({
        commission_rule
    });
}
/**
 * @oas [delete] /admin/commission/rules/{id}
 * operationId: "AdminDeleteCommissionRuleById"
 * summary: "Delete a Commission Rule"
 * description: "Deletes a commission rule by id."
 * x-authenticated: true
 * parameters:
 *   - in: path
 *     name: id
 *     required: true
 *     description: The ID of the rule.
 *     schema:
 *       type: string
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
 *               description: The ID of the deleted rule
 *             object:
 *               type: string
 *               description: The type of the object that was deleted
 *             deleted:
 *               type: boolean
 *               description: Whether or not the items were deleted
 * tags:
 *   - Admin Commission
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function DELETE(req, res) {
    const { result } = await workflows_1.deleteCommissionRuleWorkflow.run({
        input: req.params.id,
        container: req.scope
    });
    res.json({
        id: result,
        object: 'commission_rule',
        deleted: true
    });
}
/**
 * @oas [get] /admin/commission/rules/{id}
 * operationId: "AdminGetCommissionRuleById"
 * summary: "Get commission rule by id"
 * description: "Retrieves a commission rule by id."
 * x-authenticated: true
 * parameters:
 * - in: path
 *   name: id
 *   required: true
 *   description: The ID of the Rule.
 *   schema:
 *     type: string
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
    const { result: { commission_rules: [commission_rule] } } = await workflows_1.listCommissionRulesWorkflow.run({
        container: req.scope,
        input: {
            ids: [req.params.id]
        }
    });
    if (!commission_rule) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.NOT_FOUND, 'Rule not found!');
    }
    res.json({
        commission_rule
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL2NvbW1pc3Npb24vcnVsZXMvW2lkXS9yb3V0ZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQStDQSxvQkF3QkM7QUFzQ0Qsd0JBY0M7QUErQkQsa0JBc0JDO0FBL0tELHFEQUdrQztBQUVsQyw2RUFJc0Q7QUFHdEQ7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQWlDRztBQUNJLEtBQUssVUFBVSxJQUFJLENBQ3hCLEdBQWlELEVBQ2pELEdBQW1CO0lBRW5CLE1BQU0sS0FBSyxHQUFHLEdBQUcsQ0FBQyxLQUFLLENBQUMsT0FBTyxDQUFDLGlDQUF5QixDQUFDLEtBQUssQ0FBQyxDQUFBO0lBRWhFLE1BQU0sd0NBQTRCLENBQUMsR0FBRyxDQUFDO1FBQ3JDLEtBQUssRUFBRSxFQUFFLEdBQUcsR0FBRyxDQUFDLGFBQWEsRUFBRSxFQUFFLEVBQUUsR0FBRyxDQUFDLE1BQU0sQ0FBQyxFQUFFLEVBQUU7UUFDbEQsU0FBUyxFQUFFLEdBQUcsQ0FBQyxLQUFLO0tBQ3JCLENBQUMsQ0FBQTtJQUVGLE1BQU0sRUFDSixJQUFJLEVBQUUsQ0FBQyxlQUFlLENBQUMsRUFDeEIsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixNQUFNLEVBQUUsR0FBRyxDQUFDLFdBQVcsQ0FBQyxNQUFNO1FBQzlCLE9BQU8sRUFBRTtZQUNQLEVBQUUsRUFBRSxHQUFHLENBQUMsTUFBTSxDQUFDLEVBQUU7U0FDbEI7S0FDRixDQUFDLENBQUE7SUFFRixHQUFHLENBQUMsTUFBTSxDQUFDLEdBQUcsQ0FBQyxDQUFDLElBQUksQ0FBQztRQUNuQixlQUFlO0tBQ2hCLENBQUMsQ0FBQTtBQUNKLENBQUM7QUFFRDs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7R0FtQ0c7QUFDSSxLQUFLLFVBQVUsTUFBTSxDQUMxQixHQUFrQixFQUNsQixHQUFtQjtJQUVuQixNQUFNLEVBQUUsTUFBTSxFQUFFLEdBQUcsTUFBTSx3Q0FBNEIsQ0FBQyxHQUFHLENBQUM7UUFDeEQsS0FBSyxFQUFFLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtRQUNwQixTQUFTLEVBQUUsR0FBRyxDQUFDLEtBQUs7S0FDckIsQ0FBQyxDQUFBO0lBRUYsR0FBRyxDQUFDLElBQUksQ0FBQztRQUNQLEVBQUUsRUFBRSxNQUFNO1FBQ1YsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixPQUFPLEVBQUUsSUFBSTtLQUNkLENBQUMsQ0FBQTtBQUNKLENBQUM7QUFFRDs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQTRCRztBQUNJLEtBQUssVUFBVSxHQUFHLENBQ3ZCLEdBQWtCLEVBQ2xCLEdBQW1CO0lBRW5CLE1BQU0sRUFDSixNQUFNLEVBQUUsRUFDTixnQkFBZ0IsRUFBRSxDQUFDLGVBQWUsQ0FBQyxFQUNwQyxFQUNGLEdBQUcsTUFBTSx1Q0FBMkIsQ0FBQyxHQUFHLENBQUM7UUFDeEMsU0FBUyxFQUFFLEdBQUcsQ0FBQyxLQUFLO1FBQ3BCLEtBQUssRUFBRTtZQUNMLEdBQUcsRUFBRSxDQUFDLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRSxDQUFDO1NBQ3JCO0tBQ0YsQ0FBQyxDQUFBO0lBRUYsSUFBSSxDQUFDLGVBQWUsRUFBRSxDQUFDO1FBQ3JCLE1BQU0sSUFBSSxtQkFBVyxDQUFDLG1CQUFXLENBQUMsS0FBSyxDQUFDLFNBQVMsRUFBRSxpQkFBaUIsQ0FBQyxDQUFBO0lBQ3ZFLENBQUM7SUFFRCxHQUFHLENBQUMsSUFBSSxDQUFDO1FBQ1AsZUFBZTtLQUNoQixDQUFDLENBQUE7QUFDSixDQUFDIn0=