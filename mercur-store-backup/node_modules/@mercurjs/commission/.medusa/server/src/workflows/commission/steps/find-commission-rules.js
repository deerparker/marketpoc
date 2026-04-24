"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findCommissionRulesStep = void 0;
const utils_1 = require("@medusajs/framework/utils");
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
async function selectPriceSetPrices(container, price_set_id) {
    const query = container.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [price] } = await query.graph({
        entity: 'price_set',
        fields: ['*', 'prices.*'],
        filters: {
            id: price_set_id
        }
    });
    return price
        ? {
            id: price.id,
            prices: price.prices.map((p) => ({
                currency_code: p.currency_code,
                amount: p.amount
            }))
        }
        : {
            id: null,
            prices: []
        };
}
exports.findCommissionRulesStep = (0, workflows_sdk_1.createStep)('find-commission-rules', async (input, { container }) => {
    const query = container.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const filters = input.ids
        ? { id: input.ids }
        : { reference: { $ne: 'site' } };
    const { data: commissions, metadata } = await query.graph({
        entity: 'commission_rule',
        fields: ['*', 'rate.*'],
        filters: filters,
        pagination: input.pagination
    });
    const commission_rules = [];
    for (const commission of commissions) {
        const aggregate = {
            id: commission.id,
            name: commission.name,
            reference: commission.reference,
            reference_id: commission.reference_id,
            is_active: commission.is_active,
            type: commission.rate.type,
            include_tax: commission.rate.include_tax,
            percentage_rate: commission.rate.percentage_rate,
            price_set_id: null,
            price_set: [],
            min_price_set_id: null,
            min_price_set: [],
            max_price_set_id: null,
            max_price_set: [],
            fee_value: `${commission.rate.percentage_rate}%`
        };
        if (commission.rate.min_price_set_id) {
            const minPrice = await selectPriceSetPrices(container, commission.rate.min_price_set_id);
            aggregate.min_price_set_id = minPrice.id;
            aggregate.min_price_set = minPrice.prices;
        }
        if (commission.rate.max_price_set_id) {
            const maxPrice = await selectPriceSetPrices(container, commission.rate.max_price_set_id);
            aggregate.max_price_set_id = maxPrice.id;
            aggregate.max_price_set = maxPrice.prices;
        }
        if (commission.rate.type === 'flat') {
            const price = await selectPriceSetPrices(container, commission.rate.price_set_id);
            aggregate.price_set_id = price.id;
            aggregate.price_set = price.prices;
            aggregate.fee_value =
                price.prices
                    .map((p) => `${p.amount}${p.currency_code?.toUpperCase()}`)
                    .join('/') || '-';
        }
        commission_rules.push(aggregate);
    }
    return new workflows_sdk_1.StepResponse({ commission_rules, count: metadata?.count || 0 });
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZmluZC1jb21taXNzaW9uLXJ1bGVzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9jb21taXNzaW9uL3N0ZXBzL2ZpbmQtY29tbWlzc2lvbi1ydWxlcy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFDQSxxREFBcUU7QUFDckUscUVBQTRFO0FBRTVFLEtBQUssVUFBVSxvQkFBb0IsQ0FDakMsU0FBMEIsRUFDMUIsWUFBb0I7SUFFcEIsTUFBTSxLQUFLLEdBQUcsU0FBUyxDQUFDLE9BQU8sQ0FBQyxpQ0FBeUIsQ0FBQyxLQUFLLENBQUMsQ0FBQTtJQUNoRSxNQUFNLEVBQ0osSUFBSSxFQUFFLENBQUMsS0FBSyxDQUFDLEVBQ2QsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDcEIsTUFBTSxFQUFFLFdBQVc7UUFDbkIsTUFBTSxFQUFFLENBQUMsR0FBRyxFQUFFLFVBQVUsQ0FBQztRQUN6QixPQUFPLEVBQUU7WUFDUCxFQUFFLEVBQUUsWUFBWTtTQUNqQjtLQUNGLENBQUMsQ0FBQTtJQUVGLE9BQU8sS0FBSztRQUNWLENBQUMsQ0FBQztZQUNFLEVBQUUsRUFBRSxLQUFLLENBQUMsRUFBRTtZQUNaLE1BQU0sRUFBRSxLQUFLLENBQUMsTUFBTSxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsRUFBRSxFQUFFLENBQUMsQ0FBQztnQkFDL0IsYUFBYSxFQUFFLENBQUMsQ0FBQyxhQUFhO2dCQUM5QixNQUFNLEVBQUUsQ0FBQyxDQUFDLE1BQU07YUFDakIsQ0FBQyxDQUFDO1NBQ0o7UUFDSCxDQUFDLENBQUM7WUFDRSxFQUFFLEVBQUUsSUFBSTtZQUNSLE1BQU0sRUFBRSxFQUFFO1NBQ1gsQ0FBQTtBQUNQLENBQUM7QUFFWSxRQUFBLHVCQUF1QixHQUFHLElBQUEsMEJBQVUsRUFDL0MsdUJBQXVCLEVBQ3ZCLEtBQUssRUFDSCxLQU1DLEVBQ0QsRUFBRSxTQUFTLEVBQUUsRUFDYixF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