"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GET = GET;
const utils_1 = require("@medusajs/framework/utils");
/**
 * @oas [get] /admin/reviews
 * operationId: "AdminListReviews"
 * summary: "List reviews"
 * description: "Retrieves review list"
 * x-authenticated: true
 * parameters:
 *   - in: query
 *     name: limit
 *     schema:
 *       type: number
 *     description: The number of items to return. Default 50.
 *   - in: query
 *     name: offset
 *     schema:
 *       type: number
 *     description: The number of items to skip before starting the response. Default 0.
 *   - name: fields
 *     in: query
 *     schema:
 *       type: string
 *     required: false
 *     description: Comma-separated fields to include in the response.
 *   - name: reference
 *     in: query
 *     schema:
 *       type: string
 *       enum: [product,seller]
 *     required: false
 *     description: Filter by review reference
 * responses:
 *   "200":
 *     description: OK
 *     content:
 *       application/json:
 *         schema:
 *           type: object
 *           properties:
 *             reviews:
 *               type: array
 *               items:
 *                 $ref: "#/components/schemas/Review"
 *             count:
 *               type: integer
 *               description: The total number of reviews
 *             offset:
 *               type: integer
 *               description: The number of reviews skipped
 *             limit:
 *               type: integer
 *               description: The number of reviews per page
 * tags:
 *   - Admin Reviews
 * security:
 *   - api_token: []
 *   - cookie_auth: []
 */
async function GET(req, res) {
    const query = req.scope.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: reviews, metadata } = await query.graph({
        entity: 'review',
        fields: req.queryConfig.fields,
        filters: req.filterableFields,
        pagination: req.queryConfig.pagination
    });
    res.json({
        requests: reviews,
        count: metadata?.count,
        offset: metadata?.skip,
        limit: metadata?.take
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicm91dGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL3Jldmlld3Mvcm91dGUudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUE0REEsa0JBa0JDO0FBN0VELHFEQUFxRTtBQUVyRTs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7R0F3REc7QUFDSSxLQUFLLFVBQVUsR0FBRyxDQUN2QixHQUFrQixFQUNsQixHQUFtQjtJQUVuQixNQUFNLEtBQUssR0FBRyxHQUFHLENBQUMsS0FBSyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUNoRSxNQUFNLEVBQUUsSUFBSSxFQUFFLE9BQU8sRUFBRSxRQUFRLEVBQUUsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEQsTUFBTSxFQUFFLFFBQVE7UUFDaEIsTUFBTSxFQUFFLEdBQUcsQ0FBQyxXQUFXLENBQUMsTUFBTTtRQUM5QixPQUFPLEVBQUUsR0FBRyxDQUFDLGdCQUFnQjtRQUM3QixVQUFVLEVBQUUsR0FBRyxDQUFDLFdBQVcsQ0FBQyxVQUFVO0tBQ3ZDLENBQUMsQ0FBQTtJQUVGLEdBQUcsQ0FBQyxJQUFJLENBQUM7UUFDUCxRQUFRLEVBQUUsT0FBTztRQUNqQixLQUFLLEVBQUUsUUFBUSxFQUFFLEtBQUs7UUFDdEIsTUFBTSxFQUFFLFFBQVEsRUFBRSxJQUFJO1FBQ3RCLEtBQUssRUFBRSxRQUFRLEVBQUUsSUFBSTtLQUN0QixDQUFDLENBQUE7QUFDSixDQUFDIn0=