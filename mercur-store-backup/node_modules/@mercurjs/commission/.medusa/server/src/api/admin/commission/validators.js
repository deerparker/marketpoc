"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AdminGetCommissionLinesParams = exports.validateCommissionRule = exports.validateCommissionRate = exports.AdminUpsertDefaultCommissionRule = exports.AdminUpdateCommissionRule = exports.AdminCreateCommissionRule = exports.CommissionRuleReferenceType = exports.AdminCommissionRuleParams = exports.AdminCreateCommissionRate = exports.CommissionRateType = void 0;
const zod_1 = require("zod");
const utils_1 = require("@medusajs/framework/utils");
const validators_1 = require("@medusajs/medusa/api/utils/validators");
exports.CommissionRateType = zod_1.z.enum(['flat', 'percentage']);
/**
 * @schema AdminCommissionRatePrice
 * type: object
 * properties:
 *   currency_code:
 *     type: string
 *     description: Currency of the price.
 *   amount:
 *     type: number
 *     description: The subtitle of the product.
 */
const Price = zod_1.z.object({
    amount: zod_1.z.number(),
    currency_code: zod_1.z.string().refine((z) => z.toLowerCase())
});
exports.AdminCreateCommissionRate = zod_1.z.object({
    type: exports.CommissionRateType,
    percentage_rate: zod_1.z.number().min(0).max(100).optional(),
    include_tax: zod_1.z.boolean(),
    price_set: zod_1.z.array(Price).optional(),
    max_price_set: zod_1.z.array(Price).optional(),
    min_price_set: zod_1.z.array(Price).optional()
});
exports.AdminCommissionRuleParams = (0, validators_1.createFindParams)({
    offset: 0,
    limit: 50
});
/**
 * Reference type for commission rule
 * We have simple (one reference_id at once), and combined types: 'seller+product_category', 'seller+product_type'
 * For combined types let's assume that reference_id is also combined in format: 'ref_id1+ref_id2'
 * For example:
 * {
 *  reference: 'seller+product_category'
 *  reference_id: 'sel_01JER8T3FWMY7T8ETYDNNYVE39+pcat_01JENRK39TBX7H88YB5JN63RP2'
 * }
 */
exports.CommissionRuleReferenceType = zod_1.z.enum([
    'product_type',
    'product_category',
    'seller_group',
    'seller+product_category',
    'seller+product_type',
    'seller'
]);
exports.AdminCreateCommissionRule = zod_1.z.object({
    name: zod_1.z.string(),
    reference: exports.CommissionRuleReferenceType,
    reference_id: zod_1.z.string(),
    is_active: zod_1.z.boolean().default(true),
    rate: exports.AdminCreateCommissionRate
});
exports.AdminUpdateCommissionRule = zod_1.z.object({
    name: zod_1.z.string().optional(),
    is_active: zod_1.z.boolean().optional()
});
exports.AdminUpsertDefaultCommissionRule = zod_1.z.object({
    name: zod_1.z.string().default('default'),
    reference: zod_1.z.enum(['site']).default('site'),
    reference_id: zod_1.z.enum(['']).default(''),
    is_active: zod_1.z.boolean().default(true),
    rate: exports.AdminCreateCommissionRate
});
const validateCommissionRate = (rate) => {
    if (rate.type === 'flat' &&
        (!rate.price_set || rate.price_set.length === 0)) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_DATA, 'Flat rate requires fee value');
    }
    if (rate.type === 'percentage' &&
        typeof rate.percentage_rate === 'undefined') {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_DATA, 'Percentage rate requires percent value');
    }
};
exports.validateCommissionRate = validateCommissionRate;
const validateCommissionRule = (obj) => {
    const errors = [
        obj.reference === 'seller' && !obj.reference_id.startsWith('sel'),
        obj.reference === 'product_category' &&
            !obj.reference_id.startsWith('pcat'),
        obj.reference === 'product_type' && !obj.reference_id.startsWith('ptyp'),
        obj.reference === 'seller+product_type' &&
            (!obj.reference_id.split('+')[0].startsWith('sel') ||
                !obj.reference_id.split('+')[1].startsWith('ptyp')),
        obj.reference === 'seller+product_category' &&
            (!obj.reference_id.split('+')[0].startsWith('sel') ||
                !obj.reference_id.split('+')[1].startsWith('pcat'))
    ];
    if (errors.find((v) => v)) {
        throw new utils_1.MedusaError(utils_1.MedusaError.Types.INVALID_DATA, 'Invalid reference id');
    }
};
exports.validateCommissionRule = validateCommissionRule;
exports.AdminGetCommissionLinesParams = (0, validators_1.createFindParams)({
    limit: 15,
    offset: 0
}).merge(zod_1.z.object({
    start_date: zod_1.z.coerce.date().optional(),
    end_date: zod_1.z.coerce.date().optional(),
    seller_id: zod_1.z.string().optional()
}));
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmFsaWRhdG9ycy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy9hcGkvYWRtaW4vY29tbWlzc2lvbi92YWxpZGF0b3JzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLDZCQUF1QjtBQUV2QixxREFBdUQ7QUFDdkQsc0VBQXdFO0FBRTNELFFBQUEsa0JBQWtCLEdBQUcsT0FBQyxDQUFDLElBQUksQ0FBQyxDQUFDLE1BQU0sRUFBRSxZQUFZLENBQUMsQ0FBQyxDQUFBO0FBRWhFOzs7Ozs7Ozs7O0dBVUc7QUFDSCxNQUFNLEtBQUssR0FBRyxPQUFDLENBQUMsTUFBTSxDQUFDO0lBQ3JCLE1BQU0sRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFO0lBQ2xCLGFBQWEsRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsTUFBTSxDQUFDLENBQUMsQ0FBQyxFQUFFLEVBQUUsQ0FBQyxDQUFDLENBQUMsV0FBVyxFQUFFLENBQUM7Q0FDekQsQ0FBQyxDQUFBO0FBZ0NXLFFBQUEseUJBQXlCLEdBQUcsT0FBQyxDQUFDLE1BQU0sQ0FBQztJQUNoRCxJQUFJLEVBQUUsMEJBQWtCO0lBQ3hCLGVBQWUsRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxHQUFHLENBQUMsQ0FBQyxRQUFRLEVBQUU7SUFDdEQsV0FBVyxFQUFFLE9BQUMsQ0FBQyxPQUFPLEVBQUU7SUFDeEIsU0FBUyxFQUFFLE9BQUMsQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLENBQUMsUUFBUSxFQUFFO0lBQ3BDLGFBQWEsRUFBRSxPQUFDLENBQUMsS0FBSyxDQUFDLEtBQUssQ0FBQyxDQUFDLFFBQVEsRUFBRTtJQUN4QyxhQUFhLEVBQUUsT0FBQyxDQUFDLEtBQUssQ0FBQyxLQUFLLENBQUMsQ0FBQyxRQUFRLEVBQUU7Q0FDekMsQ0FBQyxDQUFBO0FBS1csUUFBQSx5QkFBeUIsR0FB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