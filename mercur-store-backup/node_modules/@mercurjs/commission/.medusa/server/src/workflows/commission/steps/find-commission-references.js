"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findCommissionReferencesStep = void 0;
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
exports.findCommissionReferencesStep = (0, workflows_sdk_1.createStep)('find-commission-references', async (input, { container }) => {
    const knex = container.resolve('__pg_connection__');
    const sellerIds = input
        .filter((i) => i.reference === 'seller')
        .map((v) => v.reference_id);
    const productTypeIds = input
        .filter((i) => i.reference === 'product_type')
        .map((v) => v.reference_id);
    const productCategoryIds = input
        .filter((i) => i.reference === 'product_category')
        .map((v) => v.reference_id);
    input
        .filter((i) => i.reference === 'seller+product_type' ||
        i.reference === 'seller+product_category')
        .forEach((v) => {
        const ids = v.reference_id.split('+');
        sellerIds.push(ids[0]);
        if (v.reference === 'seller+product_category') {
            productCategoryIds.push(ids[1]);
        }
        else {
            productTypeIds.push(ids[1]);
        }
    });
    const sellers = await knex('seller')
        .select(['id', 'name AS value'])
        .whereIn('id', [...new Set(sellerIds)]);
    const productTypes = await knex('product_type')
        .select(['id', 'value'])
        .whereIn('id', [...new Set(productTypeIds)]);
    const productCategories = await knex('product_category')
        .select(['id', 'name AS value'])
        .whereIn('id', [...new Set(productCategoryIds)]);
    return new workflows_sdk_1.StepResponse({ sellers, productTypes, productCategories });
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZmluZC1jb21taXNzaW9uLXJlZmVyZW5jZXMuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvd29ya2Zsb3dzL2NvbW1pc3Npb24vc3RlcHMvZmluZC1jb21taXNzaW9uLXJlZmVyZW5jZXMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEscUVBQTRFO0FBSS9ELFFBQUEsNEJBQTRCLEdBQUcsSUFBQSwwQkFBVSxFQUNwRCw0QkFBNEIsRUFDNUIsS0FBSyxFQUFFLEtBQWdCLEVBQUUsRUFBRSxTQUFTLEVBQUUsRUFBRSxFQUFFO0lBQ3hDLE1BQU0sSUFBSSxHQUFHLFNBQVMsQ0FBQyxPQUFPLENBQUMsbUJBQW1CLENBQUMsQ0FBQTtJQUNuRCxNQUFNLFNBQVMsR0FBRyxLQUFLO1NBQ3BCLE1BQU0sQ0FBQyxDQUFDLENBQUMsRUFBRSxFQUFFLENBQUMsQ0FBQyxDQUFDLFNBQVMsS0FBSyxRQUFRLENBQUM7U0FDdkMsR0FBRyxDQUFDLENBQUMsQ0FBQyxFQUFFLEVBQUUsQ0FBQyxDQUFDLENBQUMsWUFBWSxDQUFDLENBQUE7SUFDN0IsTUFBTSxjQUFjLEdBQUcsS0FBSztTQUN6QixNQUFNLENBQUMsQ0FBQyxDQUFDLEVBQUUsRUFBRSxDQUFDLENBQUMsQ0FBQyxTQUFTLEtBQUssY0FBYyxDQUFDO1NBQzdDLEdBQUcsQ0FBQyxDQUFDLENBQUMsRUFBRSxFQUFFLENBQUMsQ0FBQyxDQUFDLFlBQVksQ0FBQyxDQUFBO0lBQzdCLE1BQU0sa0JBQWtCLEdBQUcsS0FBSztTQUM3QixNQUFNLENBQUMsQ0FBQyxDQUFDLEVBQUUsRUFBRSxDQUFDLENBQUMsQ0FBQyxTQUFTLEtBQUssa0JBQWtCLENBQUM7U0FDakQsR0FBRyxDQUFDLENBQUMsQ0FBQyxFQUFFLEVBQUUsQ0FBQyxDQUFDLENBQUMsWUFBWSxDQUFDLENBQUE7SUFFN0IsS0FBSztTQUNGLE1BQU0sQ0FDTCxDQUFDLENBQUMsRUFBRSxFQUFFLENBQ0osQ0FBQyxDQUFDLFNBQVMsS0FBSyxxQkFBcUI7UUFDckMsQ0FBQyxDQUFDLFNBQVMsS0FBSyx5QkFBeUIsQ0FDNUM7U0FDQSxPQUFPLENBQUMsQ0FBQyxDQUFDLEVBQUUsRUFBRTtRQUNiLE1BQU0sR0FBRyxHQUFHLENBQUMsQ0FBQyxZQUFZLENBQUMsS0FBSyxDQUFDLEdBQUcsQ0FBQyxDQUFBO1FBQ3JDLFNBQVMsQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUE7UUFDdEIsSUFBSSxDQUFDLENBQUMsU0FBUyxLQUFLLHlCQUF5QixFQUFFLENBQUM7WUFDOUMsa0JBQWtCLENBQUMsSUFBSSxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFBO1FBQ2pDLENBQUM7YUFBTSxDQUFDO1lBQ04sY0FBYyxDQUFDLElBQUksQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtRQUM3QixDQUFDO0lBQ0gsQ0FBQyxDQUFDLENBQUE7SUFFSixNQUFNLE9BQU8sR0FBRyxNQUFNLElBQUksQ0FBQyxRQUFRLENBQUM7U0FDakMsTUFBTSxDQUFDLENBQUMsSUFBSSxFQUFFLGVBQWUsQ0FBQyxDQUFDO1NBQy9CLE9BQU8sQ0FBQyxJQUFJLEVBQUUsQ0FBQyxHQUFHLElBQUksR0FBRyxDQUFDLFNBQVMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtJQUV6QyxNQUFNLFlBQVksR0FBRyxNQUFNLElBQUksQ0FBQyxjQUFjLENBQUM7U0FDNUMsTUFBTSxDQUFDLENBQUMsSUFBSSxFQUFFLE9BQU8sQ0FBQyxDQUFDO1NBQ3ZCLE9BQU8sQ0FBQyxJQUFJLEVBQUUsQ0FBQyxHQUFHLElBQUksR0FBRyxDQUFDLGNBQWMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtJQUU5QyxNQUFNLGlCQUFpQixHQUFHLE1BQU0sSUFBSSxDQUFDLGtCQUFrQixDQUFDO1NBQ3JELE1BQU0sQ0FBQyxDQUFDLElBQUksRUFBRSxlQUFlLENBQUMsQ0FBQztTQUMvQixPQUFPLENBQUMsSUFBSSxFQUFFLENBQUMsR0FBRyxJQUFJLEdBQUcsQ0FBQyxrQkFBa0IsQ0FBQyxDQUFDLENBQUMsQ0FBQTtJQUVsRCxPQUFPLElBQUksNEJBQVksQ0FBQyxFQUFFLE9BQU8sRUFBRSxZQUFZLEVBQUUsaUJBQWlCLEVBQUUsQ0FBQyxDQUFBO0FBQ3ZFLENBQUMsQ0FDRixDQUFBIn0=