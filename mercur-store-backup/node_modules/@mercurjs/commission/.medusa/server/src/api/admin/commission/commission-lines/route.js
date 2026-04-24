"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GET = GET;
const workflows_1 = require("../../../../workflows/commission/workflows");
/**
 * @oas [get] /admin/commission/commission-lines
 * operationId: "AdminListCommissionLines"
 * summary: "List Commission Lines"
 * description: "Retrieves a list of commission lines with optional filtering and expansion."
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
 *   - name: fields
 *     in: query
 *     schema:
 *       type: string
 *     required: false
 *     description: Comma-separated fields to include in the response.
 *   - name: start_date
 *     in: query
 *     schema:
 *       type: string
 *       format: date-time
 *     required: false
 *     description: Filter commission lines created after this date.
 *   - name: end_date
 *     in: query
 *     schema:
 *       type: string
 *       format: date-time
 *     required: false
 *     description: Filter commission lines created before this date.
 *   - name: seller_id
 *     in: query
 *     schema:
 *       type: string
 *     required: false
 *     description: Filter commission lines by seller ID.
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             commission_lines:
 *               type: array
 *               items:
 *                 $ref: "#/components/schemas/AdminCommissionLine"
 *             count:
 *               type: integer
 *               description: The total number of items available
 *             offset:
 *               type: integer
 *               description: The number of items skipped before these items
 *             limit:
 *               type: integer
 *               description: The number of items per page
 * tags:
 *   - Admin Commission
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function GET(req, res) {
    const { result: { lines: commission_lines, count } } = await (0, workflows_1.listCommissionLinesWorkflow)(req.scope).run({
        input: {
            expand: true,
            pagination: {
                skip: req.queryConfig.pagination.skip,
                take: req.queryConfig.pagination.take || 20
            },
            filters: req.filterableFields
        }
    });
    res.json({
        commission_lines,
        count,
        offset: req.queryConfig.pagination.skip,
        limit: req.queryConfig.pagination.take
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL2NvbW1pc3Npb24vY29tbWlzc2lvbi1saW5lcy9yb3V0ZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQTZFQSxrQkF1QkM7QUFsR0QsMEVBQXdGO0FBR3hGOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQXVFRztBQUNJLEtBQUssVUFBVSxHQUFHLENBQ3ZCLEdBQXFELEVBQ3JELEdBQW1CO0lBRW5CLE1BQU0sRUFDSixNQUFNLEVBQUUsRUFBRSxLQUFLLEVBQUUsZ0JBQWdCLEVBQUUsS0FBSyxFQUFFLEVBQzNDLEdBQUcsTUFBTSxJQUFBLHVDQUEyQixFQUFDLEdBQUcsQ0FBQyxLQUFLLENBQUMsQ0FBQyxHQUFHLENBQUM7UUFDbkQsS0FBSyxFQUFFO1lBQ0wsTUFBTSxFQUFFLElBQUk7WUFDWixVQUFVLEVBQUU7Z0JBQ1YsSUFBSSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsVUFBVSxDQUFDLElBQUk7Z0JBQ3JDLElBQUksRUFBRSxHQUFHLENBQUMsV0FBVyxDQUFDLFVBQVUsQ0FBQyxJQUFJLElBQUksRUFBRTthQUM1QztZQUNELE9BQU8sRUFBRSxHQUFHLENBQUMsZ0JBQWdCO1NBQzlCO0tBQ0YsQ0FBQyxDQUFBO0lBRUYsR0FBRyxDQUFDLElBQUksQ0FBQztRQUNQLGdCQUFnQjtRQUNoQixLQUFLO1FBQ0wsTUFBTSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsVUFBVSxDQUFDLElBQUk7UUFDdkMsS0FBSyxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsVUFBVSxDQUFDLElBQUk7S0FDdkMsQ0FBQyxDQUFBO0FBQ0osQ0FBQyJ9