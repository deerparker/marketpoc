"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.listOrderCommissionLinesStep = void 0;
const utils_1 = require("@medusajs/framework/utils");
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
exports.listOrderCommissionLinesStep = (0, workflows_sdk_1.createStep)('list-order-commission-lines', async (input, { container }) => {
    const query = container.resolve(utils_1.ContainerRegistrationKeys.QUERY);
    const { data: [order] } = await query.graph({
        entity: 'order',
        fields: ['items.id', 'currency_code'],
        filters: {
            id: input.order_id
        }
    });
    const order_line_items = order.items.map((i) => i.id);
    const { data: commission_lines } = await query.graph({
        entity: 'commission_line',
        fields: ['*'],
        filters: {
            item_line_id: order_line_items
        }
    });
    const amount = commission_lines.reduce((acc, current) => {
        return utils_1.MathBN.add(acc, current.value);
    }, utils_1.MathBN.convert(0));
    return new workflows_sdk_1.StepResponse({
        commission_value: { amount, currency_code: order.currency_code },
        commission_lines
    });
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibGlzdC1vcmRlci1jb21taXNzaW9uLWxpbmVzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9jb21taXNzaW9uL3N0ZXBzL2xpc3Qtb3JkZXItY29tbWlzc2lvbi1saW5lcy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSxxREFJa0M7QUFDbEMscUVBQTRFO0FBRS9ELFFBQUEsNEJBQTRCLEdBQUcsSUFBQSwwQkFBVSxFQUNwRCw2QkFBNkIsRUFDN0IsS0FBSyxFQUNILEtBRUMsRUFDRCxFQUFFLFNBQVMsRUFBRSxFQUNiLEVBQUU7SUFDRixNQUFNLEtBQUssR0FBRyxTQUFTLENBQUMsT0FBTyxDQUFDLGlDQUF5QixDQUFDLEtBQUssQ0FBQyxDQUFBO0lBRWhFLE1BQU0sRUFDSixJQUFJLEVBQUUsQ0FBQyxLQUFLLENBQUMsRUFDZCxHQUFHLE1BQU0sS0FBSyxDQUFDLEtBQUssQ0FBQztRQUNwQixNQUFNLEVBQUUsT0FBTztRQUNmLE1BQU0sRUFBRSxDQUFDLFVBQVUsRUFBRSxlQUFlLENBQUM7UUFDckMsT0FBTyxFQUFFO1lBQ1AsRUFBRSxFQUFFLEtBQUssQ0FBQyxRQUFRO1NBQ25CO0tBQ0YsQ0FBQyxDQUFBO0lBRUYsTUFBTSxnQkFBZ0IsR0FBRyxLQUFLLENBQUMsS0FBSyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsRUFBRSxFQUFFLENBQUMsQ0FBQyxDQUFDLEVBQUUsQ0FBQyxDQUFBO0lBRXJELE1BQU0sRUFBRSxJQUFJLEVBQUUsZ0JBQWdCLEVBQUUsR0FBRyxNQUFNLEtBQUssQ0FBQyxLQUFLLENBQUM7UUFDbkQsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixNQUFNLEVBQUUsQ0FBQyxHQUFHLENBQUM7UUFDYixPQUFPLEVBQUU7WUFDUCxZQUFZLEVBQUUsZ0JBQWdCO1NBQy9CO0tBQ0YsQ0FBQyxDQUFBO0lBRUYsTUFBTSxNQUFNLEdBQWMsZ0JBQWdCLENBQUMsTUFBTSxDQUFDLENBQUMsR0FBRyxFQUFFLE9BQU8sRUFBRSxFQUFFO1FBQ2pFLE9BQU8sY0FBTSxDQUFDLEdBQUcsQ0FBQyxHQUFHLEVBQUUsT0FBTyxDQUFDLEtBQUssQ0FBQyxDQUFBO0lBQ3ZDLENBQUMsRUFBRSxjQUFNLENBQUMsT0FBTyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUE7SUFFckIsT0FBTyxJQUFJLDRCQUFZLENBQUM7UUFDdEIsZ0JBQWdCLEVBQUUsRUFBRSxNQUFNLEVBQUUsYUFBYSxFQUFFLEtBQUssQ0FBQyxhQUFhLEVBQUU7UUFDaEUsZ0JBQWdCO0tBQ2pCLENBQUMsQ0FBQTtBQUNKLENBQUMsQ0FDRixDQUFBIn0=