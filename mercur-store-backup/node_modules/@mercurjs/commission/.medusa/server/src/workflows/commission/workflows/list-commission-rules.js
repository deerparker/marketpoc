"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.listCommissionRulesWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const steps_1 = require("../steps");
const find_commission_references_1 = require("../steps/find-commission-references");
exports.listCommissionRulesWorkflow = (0, workflows_sdk_1.createWorkflow)('list-commission-rules', function (input) {
    const data = (0, steps_1.findCommissionRulesStep)(input);
    const references = (0, find_commission_references_1.findCommissionReferencesStep)(data.commission_rules);
    const result = (0, workflows_sdk_1.transform)({ data, references }, ({ data, references }) => {
        return data.commission_rules.map((rule) => {
            let ref_value = '';
            if (rule.reference === 'seller') {
                ref_value = references.sellers.find((ref) => ref.id === rule.reference_id).value;
            }
            if (rule.reference === 'product_type') {
                ref_value = references.productTypes.find((ref) => ref.id === rule.reference_id).value;
            }
            if (rule.reference === 'product_category') {
                ref_value = references.productCategories.find((ref) => ref.id === rule.reference_id).value;
            }
            if (rule.reference === 'seller+product_category') {
                const ids = rule.reference_id.split('+');
                ref_value =
                    references.sellers.find((ref) => ref.id === ids[0]).value +
                        ' + ' +
                        references.productCategories.find((ref) => ref.id === ids[1]).value;
            }
            if (rule.reference === 'seller+product_type') {
                const ids = rule.reference_id.split('+');
                ref_value =
                    references.sellers.find((ref) => ref.id === ids[0]).value +
                        ' + ' +
                        references.productTypes.find((ref) => ref.id === ids[1]).value;
            }
            return {
                ...rule,
                ref_value
            };
        });
    });
    return new workflows_sdk_1.WorkflowResponse({
        commission_rules: result,
        count: data.count
    });
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibGlzdC1jb21taXNzaW9uLXJ1bGVzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9jb21taXNzaW9uL3dvcmtmbG93cy9saXN0LWNvbW1pc3Npb24tcnVsZXMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsMkRBSWdDO0FBSWhDLG9DQUFrRDtBQUNsRCxvRkFBa0Y7QUFFckUsUUFBQSwyQkFBMkIsR0FBRyxJQUFBLDhCQUFjLEVBQ3ZELHVCQUF1QixFQUN2QixVQUFVLEtBT1Q7SUFDQyxNQUFNLElBQUksR0FBRyxJQUFBLCtCQUF1QixFQUFDLEtBQUssQ0FBQyxDQUFBO0lBQzNDLE1BQU0sVUFBVSxHQUFHLElBQUEseURBQTRCLEVBQUMsSUFBSSxDQUFDLGdCQUFnQixDQUFDLENBQUE7SUFFdEUsTUFBTSxNQUFNLEdBQUcsSUFBQSx5QkFBUyxFQUFDLEVBQUUsSUFBSSxFQUFFLFVBQVUsRUFBRSxFQUFFLENBQUMsRUFBRSxJQUFJLEVBQUUsVUFBVSxFQUFFLEVBQUUsRUFBRTtRQUN0RSxPQUFPLElBQUksQ0FBQyxnQkFBZ0IsQ0FBQyxHQUFHLENBQUMsQ0FBQyxJQUFJLEVBQUUsRUFBRTtZQUN4QyxJQUFJLFNBQVMsR0FBRyxFQUFFLENBQUE7WUFFbEIsSUFBSSxJQUFJLENBQUMsU0FBUyxLQUFLLFFBQVEsRUFBRSxDQUFDO2dCQUNoQyxTQUFTLEdBQUcsVUFBVSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQ2pDLENBQUMsR0FBRyxFQUFFLEVBQUUsQ0FBQyxHQUFHLENBQUMsRUFBRSxLQUFLLElBQUksQ0FBQyxZQUFZLENBQ3RDLENBQUMsS0FBSyxDQUFBO1lBQ1QsQ0FBQztZQUVELElBQUksSUFBSSxDQUFDLFNBQVMsS0FBSyxjQUFjLEVBQUUsQ0FBQztnQkFDdEMsU0FBUyxHQUFHLFVBQVUsQ0FBQyxZQUFZLENBQUMsSUFBSSxDQUN0QyxDQUFDLEdBQUcsRUFBRSxFQUFFLENBQUMsR0FBRyxDQUFDLEVBQUUsS0FBSyxJQUFJLENBQUMsWUFBWSxDQUN0QyxDQUFDLEtBQUssQ0FBQTtZQUNULENBQUM7WUFFRCxJQUFJLElBQUksQ0FBQyxTQUFTLEtBQUssa0JBQWtCLEVBQUUsQ0FBQztnQkFDMUMsU0FBUyxHQUFHLFVBQVUsQ0FBQyxpQkFBaUIsQ0FBQyxJQUFJLENBQzNDLENBQUMsR0FBRyxFQUFFLEVBQUUsQ0FBQyxHQUFHLENBQUMsRUFBRSxLQUFLLElBQUksQ0FBQyxZQUFZLENBQ3RDLENBQUMsS0FBSyxDQUFBO1lBQ1QsQ0FBQztZQUVELElBQUksSUFBSSxDQUFDLFNBQVMsS0FBSyx5QkFBeUIsRUFBRSxDQUFDO2dCQUNqRCxNQUFNLEdBQUcsR0FBRyxJQUFJLENBQUMsWUFBWSxDQUFDLEtBQUssQ0FBQyxHQUFHLENBQUMsQ0FBQTtnQkFDeEMsU0FBUztvQkFDUCxVQUFVLENBQUMsT0FBTyxDQUFDLElBQUksQ0FBQyxDQUFDLEdBQUcsRUFBRSxFQUFFLENBQUMsR0FBRyxDQUFDLEVBQUUsS0FBSyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxLQUFLO3dCQUN6RCxLQUFLO3dCQUNMLFVBQVUsQ0FBQyxpQkFBaUIsQ0FBQyxJQUFJLENBQUMsQ0FBQyxHQUFHLEVBQUUsRUFBRSxDQUFDLEdBQUcsQ0FBQyxFQUFFLEtBQUssR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsS0FBSyxDQUFBO1lBQ3ZFLENBQUM7WUFFRCxJQUFJLElBQUksQ0FBQyxTQUFTLEtBQUsscUJBQXFCLEVBQUUsQ0FBQztnQkFDN0MsTUFBTSxHQUFHLEdBQUcsSUFBSSxDQUFDLFlBQVksQ0FBQyxLQUFLLENBQUMsR0FBRyxDQUFDLENBQUE7Z0JBQ3hDLFNBQVM7b0JBQ1AsVUFBVSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQyxHQUFHLEVBQUUsRUFBRSxDQUFDLEdBQUcsQ0FBQyxFQUFFLEtBQUssR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsS0FBSzt3QkFDekQsS0FBSzt3QkFDTCxVQUFVLENBQUMsWUFBWSxDQUFDLElBQUksQ0FBQyxDQUFDLEdBQUcsRUFBRSxFQUFFLENBQUMsR0FBRyxDQUFDLEVBQUUsS0FBSyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxLQUFLLENBQUE7WUFDbEUsQ0FBQztZQUVELE9BQU87Z0JBQ0wsR0FBRyxJQUFJO2dCQUNQLFNBQVM7YUFDVixDQUFBO1FBQ0gsQ0FBQyxDQUFDLENBQUE7SUFDSixDQUFDLENBQUMsQ0FBQTtJQUVGLE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQztRQUMxQixnQkFBZ0IsRUFBRSxNQUFvQztRQUN0RCxLQUFLLEVBQUUsSUFBSSxDQUFDLEtBQUs7S0FDbEIsQ0FBQyxDQUFBO0FBQ0osQ0FBQyxDQUNGLENBQUEifQ==